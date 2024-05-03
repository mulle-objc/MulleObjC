//
//  NSInvocation.h
//  MulleObjC
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
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
// with MetaABI parameters
//
@interface NSInvocation : NSObject
{
   NSMethodSignature   *_methodSignature;
   char                *_storage;
   char                *_sentinel;
   char                _argumentsRetained;
   char                _returnValueRetained;
}

@property( retain, readonly) NSMethodSignature   *methodSignature;

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
                                      object:(id) object;

+ (NSInvocation *) invocationWithMethodSignature:(NSMethodSignature *) signature;

- (void) getReturnValue:(void *) value_p;
- (void) setReturnValue:(void *) value_p;

- (void) getArgument:(void *) value_p
             atIndex:(NSUInteger) i;
- (void) setArgument:(void *) value_p
             atIndex:(NSUInteger) i;

- (void) retainArguments;
- (BOOL) argumentsRetained;

- (SEL) selector;
- (void) setSelector:(SEL) selector;

- (id) target;
- (void) setTarget:target;

- (void) invoke;
- (void) invokeWithTarget:(id) target;

// mulle additions

- (void) _setMetaABIFrame:(void *) frame;
- (void) mulleRetainReturnValue;
- (BOOL) mulleReturnValueRetained;

@end


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
