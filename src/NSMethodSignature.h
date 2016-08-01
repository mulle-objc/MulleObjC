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
   uint32_t                            _bits;    // see method_descriptor
   uint16_t                            _count;
   uint16_t                            _extra;
   char                                *_types;
   char                                *_prettyTypes;
   MulleObjCMethodSignatureTypeinfo    *_infos;
   // careful when adding stuff below !! (#X#)
}

+ (NSMethodSignature *) signatureWithObjCTypes:(char *) types;

//
// this does not call init, for performance reasons. It's used by the
// forwarding mechanism
//
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

- (MulleObjCMetaABIType) _methodMetaABIReturnType;
- (MulleObjCMetaABIType) _methodMetaABIParameterType;

@end

