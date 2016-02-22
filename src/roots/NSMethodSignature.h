/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMethodSignature.h is a part of MulleFoundation
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


typedef enum
{
   _NSMetaABITypeVoid           = 0,
   _NSMetaABITypeVoidPointer    = 1,
   _NSMetaABITypeParameterBlock = 2
} _NSMetaABIType;


typedef struct mulle_objc_typeinfo    _NSMethodSignatureTypeinfo;


@interface NSMethodSignature : NSObject 
{
   char                         *_types;
   uint32_t                     _count;
   _NSMethodSignatureTypeinfo   *_infos;
}

+ (NSMethodSignature *) signatureWithObjCTypes:(char *) types;

- (BOOL) isOneway;
- (NSUInteger) frameLength;

- (NSUInteger) methodReturnLength;
- (char *) methodReturnType;

- (char *) getArgumentTypeAtIndex:(NSUInteger) index;

- (NSUInteger) numberOfArguments;

// mulle additions

- (_NSMetaABIType) methodMetaABIReturnType;
- (_NSMetaABIType) methodMetaABIParameterType;

@end

