//
//  NSContainer.h
//  MulleObjC
//
//  Copyright (c) 2019 Nat! - Mulle kybernetiK.
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
#import "import.h"

#import "mulle-objc-type.h"
#import "MulleObjCIntegralType.h"
#import "NSObjectProtocol.h"
#import "NSFastEnumeration.h"
#import "NSCopying.h"


// TODO: WHY IS THIS IN MulleObjC ??

// These basic protocols declare the "access" of each container. They
// are not concerned with initialization.

//
// Note the NSEnumeration is not required, as NSFastEnumeration
// is now used. NSFastEnumeration is also synonym for MulleContainer, which
// therefore doesn't exist.
//
// Use id <NSObject> so that NSProxy and other conforming root class
// instances can participate
//
@protocol NSArray < NSObject, NSFastEnumeration >

//- (instancetype) init;
//- (instancetype) initWithObjects:(id <NSObject>) objects
//                           count:(NSUInteger) count;
- (NSUInteger) count;
- (id) objectAtIndex:(NSUInteger) i;

@end


@protocol NSMutableArray < NSArray>

- (void) insertObject:(id <NSObject>) obj
              atIndex:(NSUInteger) i;
- (void) removeObjectAtIndex:(NSUInteger) i;
- (void) addObject:(id <NSObject>) obj;
- (void) removeLastObject;
- (void) removeAllObjects;
- (void) replaceObjectAtIndex:(NSUInteger) i
                  withObject:(id <NSObject>) obj;

@end


@protocol NSDictionary < NSObject, NSFastEnumeration >

//- (instancetype) init;
//- (instancetype) initWithObjects:(id <NSObject>)  objects
//                         forKeys:(id <NSObject, NSCopying>) keys
//                           count:(NSUInteger) count;
- (NSUInteger) count;
- (id) objectForKey:(id <NSObject, MulleObjCImmutableCopying>) key;

@end


@protocol NSMutableDictionary < NSDictionary>

- (void) setObject:(id <NSObject>) object
            forKey:(id <NSObject, MulleObjCImmutableCopying>) key;
- (void) removeObjectForKey:(id <NSObject, MulleObjCImmutableCopying>) key;
- (void) removeAllObjects;

@end



@protocol NSSet < NSObject, NSFastEnumeration >

//- (instancetype) init;
//- (instancetype) initWithObjects:(id <NSObject> *) objects
//                           count:(NSUInteger) count;
- (NSUInteger) count;
- (id) member:(id <NSObject>) object;

@end


@protocol NSMutableSet < NSSet>

- (void) addObject:(id <NSObject>) obj;
- (void) removeObject:(id <NSObject>) obj;
- (void) removeAllObjects;

@end

