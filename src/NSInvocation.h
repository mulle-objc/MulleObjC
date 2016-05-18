/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSInvocation.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSObject.h"


@class NSMethodSignature;


@interface NSInvocation : NSObject 
{
   NSMethodSignature   *_methodSignature;
   void                *_storage;
   BOOL                _argumentsRetained;
}

@property( retain, readonly) NSMethodSignature   *methodSignature;

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

@end

