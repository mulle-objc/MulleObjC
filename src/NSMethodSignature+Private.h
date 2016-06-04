/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSMethodSignature+Private.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
@interface NSMethodSignature( _Private) 

- (MulleObjCMethodSignatureTypeinfo *) _runtimeTypeInfoAtIndex:(NSUInteger) i;
- (char *) _objCTypes;
- (id) initWithObjCTypes:(char *) types;

@end
