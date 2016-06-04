/*
 *  MulleFoundation - the mulle-objc class library
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
   MulleObjCMetaABITypeVoid           = 0,
   MulleObjCMetaABITypeVoidPointer    = 1,
   MulleObjCMetaABITypeParameterBlock = 2
} MulleObjCMetaABIType;


typedef struct mulle_objc_typeinfo    MulleObjCMethodSignatureTypeinfo;


@interface NSMethodSignature : NSObject 
{
   char                                *_types;
   char                                *_prettyTypes;
   uint32_t                            _count;
   uint32_t                            _bits; // see method_descriptor
   MulleObjCMethodSignatureTypeinfo    *_infos;
}

+ (NSMethodSignature *) signatureWithObjCTypes:(char *) types;

+ (NSMethodSignature *) _signatureWithObjCTypes:(char *) types
                           methodDescriptorBits:(NSUInteger) bits;

- (BOOL) isOneway;
- (BOOL) isVariadic;
- (NSUInteger) _methodDescriptorBits;
- (NSUInteger) frameLength;

- (NSUInteger) methodReturnLength;
- (char *) methodReturnType;
- (char *) getArgumentTypeAtIndex:(NSUInteger) index;

- (NSUInteger) numberOfArguments;

// mulle additions

- (MulleObjCMetaABIType) methodMetaABIReturnType;
- (MulleObjCMetaABIType) methodMetaABIParameterType;

@end

