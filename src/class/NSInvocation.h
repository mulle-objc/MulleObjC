//
//  NSInvocation.h
//  MulleObjC
//
//  Copyright (c) 2018 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSObject.h"


@class NSMethodSignature;


//
// NSInvocations can be variable in size, as _storage expands and contracts
// with MetaABI parameters.
// Big Question: can a NSInvocation be variadic ? Meaning can we create an
// invocation for [NSString stringWithFormat:@"%d %d %d %d", 1, 2, 3, 4]; ?
// The answer is ... can we copy the metaABI frame into the NSInvocation ?
// I don't see how. We would need a special "ephemeral" NSInvocation that can
// not be retained or copied, that keeps the original metaABI alive., That's
// just super-fragile. Ppl. should be "just" using `forward:` for this.
// We could solve this by writing a sizeof() value into the metaABI param block
// though, maybe at a negative offset. That way we could at least forward
// stuff (can't retain it though), but to what good ?
//
// Subclasses that add properties, even if not readonly must release them
// in dealloc as -finalize does nothing.
//
@interface NSInvocation : NSObject
{
   char   *_storage;
   char   *_sentinel;
   char   _argumentsRetained;
   char   _returnValueRetained;
   IMP    _implementation;   // optional: if set, invocation will call this IMP directly
}

@property( retain, readonly) NSMethodSignature   *methodSignature;

+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel
                              implementation:(IMP) imp
                                      object:(id) object;

- (IMP) implementation;
- (void) setImplementation:(IMP) imp;

//
// build an invocation by passing target, sel, arguments just like
// a variable argument method call
// e.g. [NSInvocation mulleInvocationWithTarget:arary
//                                     selector:@selector( objectAtIndex:), (NSUInteger) i];
//

+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel, ...;

+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel
                             methodSignature:(NSMethodSignature *) sig, ...;

+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel
                                      object:(id) object;

+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel
                                metaABIFrame:(void *) frame;                                      

+ (NSInvocation *) invocationWithMethodSignature:(NSMethodSignature *) signature;


//
- (BOOL) argumentsRetained;


- (void) invoke;
- (void) invokeWithTarget:(id) target;

// mulle additions

- (void) _setMetaABIFrame:(void *) frame;
- (BOOL) mulleReturnValueRetained;

// used by NSThread to fill _rval (when called by -main)
- (int) mulleIntReturnValue;

@end


// you should not override any of these argument and return value methods,
// internally NSInvocation will not use them
@interface NSInvocation( MulleBasicAccessors)

- (void) getReturnValue:(void *) value_p;
- (void) setReturnValue:(void *) value_p;

- (void) getArgument:(void *) value_p
             atIndex:(NSUInteger) i;
- (void) setArgument:(void *) value_p
             atIndex:(NSUInteger) i;

- (SEL) selector;
- (void) setSelector:(SEL) selector;

- (id) target;
- (void) setTarget:(id) target;

- (void) retainArguments;
- (void) mulleRetainReturnValue;

@end


// Compiler support: creates an NSInvocation from a prebuilt MetaABI frame.
// imp may be 0 (NULL) for normal method dispatch.
NSInvocation   *NSInvocationCreateWithMetaABIFrame( NSMethodSignature *sig,
                                                    id target,
                                                    SEL sel,
                                                    void *frame,
                                                    IMP imp);


// idea:
// A root class, that does something funny. You send the class the method
// you want to call with the arguments and you get an NSInvocation back.
// You can then -invokeWithTarget:  on a target that supports this method.
// This is way more convenient than building a NSInvocation by hand.
// If you use arguments that don't match pointer, object or NSInteger then
// you should create a category interface (no implementation) with said
// method.
//
// invocation = [NSInvocation objectAtIndex:12];
// [invocation invokeWithTarget:array];
// [invocation getReturnValue:&obj];
//
//@interface NSInvocationBuilder
//@end
