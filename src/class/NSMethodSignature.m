//
//  NSMethodSignature.m
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
#import "NSMethodSignature.h"

#import "NSAutoreleasePool.h"
#import "MulleObjCAllocation.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "NSRange.h"


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
#pragma clang diagnostic ignored "-Wparentheses"


//
// The offsets in the signature, are the offsets in the NSInvocation
// not! the offsets on the stack.
//
@implementation NSMethodSignature

#pragma mark - convenience constructors

+ (NSMethodSignature *) signatureWithObjCTypes:(char *) types
{
   return( [NSMethodSignatureCreate( self, types, 0) autorelease]);
}

#pragma mark - constructors


static inline void   *getExtraMemory( NSMethodSignature *self)
{
   return( (void *) &self->_infos[ 3]);
}


static void  fill_infos( NSMethodSignature *self);   // forward


//
// All instances are over-allocated: extra bytes hold any overflow arginfos
// (count > 3) followed by the types string copy.
// _extra is always > 0 for dynamic instances, so dealloc never needs to
// free _types or _infos separately.
//
static NSMethodSignature *NSMethodSignatureCreate( Class cls,
                                                   const char *types,
                                                   NSUInteger bits)
{
   NSMethodSignature   *obj;
   NSUInteger          count;
   NSUInteger          overflow;
   NSUInteger          typesize;
   NSUInteger          extra;

   if( ! types)
      return( nil);

   count = mulle_objc_signature_count_typeinfos( types);
   if( count < 3)
      return( nil);

   overflow = (count > 3) ? (count - 3) * sizeof( MulleObjCMethodSignatureTypeInfo) : 0;
   typesize = strlen( types) + 1;
   extra    = overflow + typesize;

   assert( extra < 0x10000);
   assert( count < 0x10000);

   obj         = _MulleObjCClassAllocateInstance( cls, extra);
   obj->_count = (uint16_t) count;
   obj->_extra = (uint16_t) extra;
   obj->_bits  = (uint32_t) bits;
   obj->_types = (char *) getExtraMemory( obj) + overflow;

   memcpy( obj->_types, types, typesize);
   fill_infos( obj);

   return( obj);
}


+ (NSMethodSignature *) _signatureWithObjCTypes:(char *) types
                                 descriptorBits:(NSUInteger) bits

{
   return( [NSMethodSignatureCreate( self, types, bits) autorelease]);
}



- (void) dealloc
{
   _MulleObjCInstanceFree( self);
}



#pragma mark - mark NSObject

//
// http://www.cse.yorku.ca/~oz/hash.html djb2
//
- (NSUInteger) hash
{
   NSUInteger      hash;
   int             c;
   unsigned char   *s;

   hash = 5381;
   s    = (unsigned char *) _types;

   while( (c = *s++))
      hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

   return( hash);
}


- (BOOL) isEqual:(id) other
{
   if( self == other)
      return( YES);

   if( ! [other isKindOfClass:[NSMethodSignature class]])
      return( NO);

   return( ! strcmp( _types, ((NSMethodSignature *) other)->_types));   //hmm
}


#pragma mark - petty accessors

- (BOOL) isOneway
{
#ifdef _C_ONEWAY
   return( *[self methodReturnType] == _C_ONEWAY);
#else
   return( NO);
#endif
}


- (BOOL) isVariadic
{
   return( (_bits & _mulle_objc_method_variadic) ? YES : NO);
}


- (NSUInteger) _descriptorBits
{
   return( _bits);
}


- (char *) _objCTypes
{
   return( self->_types);
}


- (NSUInteger) numberOfArguments
{
   // rval, self, _cmd, ...
   return( _count - 1);  // don't count "rval" so self,_cmd is 2
}


#pragma mark - more accessors

static void  fill_infos( NSMethodSignature *self)
{
   MulleObjCMetaABIType     rType;
   MulleObjCMetaABIType     pType;

   assert( self->_count);
   assert( self->_types);

   mulle_objc_signature_fill_arginfos( self->_types, self->_infos, self->_count);

   // Compute and cache metaABI type bits 22-25, used by the dispatch hot path.
   if( self->_bits & _mulle_objc_method_variadic)
   {
      rType = (MulleObjCMetaABIType) mulle_objc_signature_get_metaabireturntype( self->_types);
      pType = MulleObjCMetaABITypeParameterBlock;
   }
   else
   {
      rType = (MulleObjCMetaABIType) mulle_objc_signature_get_metaabireturntype( self->_types);
      pType = (self->_count == 3)
              ? MulleObjCMetaABITypeVoid
              : (MulleObjCMetaABIType) mulle_objc_signature_get_metaabiparamtype( self->_types);
   }

   self->_bits = _mulle_objc_method_bits_set_metaabi_types( self->_bits,
                                                            (unsigned int) rType,
                                                            (unsigned int) pType);
}


- (char *) getArgumentTypeAtIndex:(NSUInteger) i
{
   // +1, skip rval: start with self
   ++i;
   if( i >= _count)
      __mulle_objc_universe_raise_invalidindex( _mulle_objc_object_get_universe( self), i);

   // will have trailing garbage, but who cares ?
   return( &self->_types[ self->_infos[ i].type_offset]);
}


- (char *) methodReturnType
{
   //
   // type info will have trailing garbage as its just an index into
   // the string
   return( &self->_types[ self->_infos[ 0].type_offset]);
}


// internal usage!
- (MulleObjCMethodSignatureTypeInfo *) mulleSignatureTypeInfoAtIndex:(NSUInteger) i
{
   if( i >= _count)
      __mulle_objc_universe_raise_invalidindex( _mulle_objc_object_get_universe( self), i);

   return( &self->_infos[ i]);
}


- (MulleObjCMetaABIType) _methodMetaABIParameterType
{
   MulleObjCMetaABIType   paramType;

   if( _bits & _mulle_objc_method_variadic)
      return( MulleObjCMetaABITypeParameterBlock);

   if( self->_count == 3)
      return( MulleObjCMetaABITypeVoid);

   paramType = (MulleObjCMetaABIType) mulle_objc_signature_get_metaabiparamtype( _types);
   assert( paramType != (MulleObjCMetaABIType) -1);
   return( paramType);
}


- (MulleObjCMetaABIType) _methodMetaABIReturnType
{
   MulleObjCMetaABIType   rvalType;

   rvalType = (MulleObjCMetaABIType) mulle_objc_signature_get_metaabireturntype( _types);
   assert( rvalType != (MulleObjCMetaABIType) -1);
   return( rvalType);
}


// this method does not round up for MetaABI
- (NSUInteger) frameLength
{
   MulleObjCMethodSignatureTypeInfo   *info;
   NSUInteger                         i;
   NSUInteger                         length;

   i      = _count - 1;
   info   = &self->_infos[ i];    // get last argument
   length = info->invocation_offset + info->natural_size;
   return( length);
}


- (NSUInteger) mulleMetaABIFrameLength
{
   MulleObjCMethodSignatureTypeInfo   *info;
   NSUInteger                         i;
   NSUInteger                         length;
   NSUInteger                         rval_size;
   NSUInteger                         arg_size;
   NSUInteger                         frame_length;

   info         = &self->_infos[ 0];
   rval_size    = info->natural_size;     // methodReturnLength

   i            = _count - 1;
   info         = &self->_infos[ i];    // get last argument
   arg_size     = info->invocation_offset + info->natural_size;

   length       = rval_size > arg_size ? rval_size : arg_size;
   frame_length = mulle_metaabi_sizeof_union( length);

   return( frame_length);
}


// used by NSInvocation
- (NSUInteger) mulleInvocationSize
{
   NSUInteger                         frame_size;
   MulleObjCMethodSignatureTypeInfo   *info;
   NSUInteger                         i;

   i           = _count - 1;
   info        = &self->_infos[ i];    // get last argument
   frame_size  = info->invocation_offset + info->natural_size;
   frame_size  = mulle_metaabi_sizeof_union( frame_size);

   info        = &self->_infos[ 0];
   frame_size += info->natural_size;     // methodReturnLength
   frame_size += alignof( double);  // for alignment

   return( frame_size);
}


// this method does not round up for MetaABI
- (NSUInteger) methodReturnLength
{
   MulleObjCMethodSignatureTypeInfo  *info;

   info = &self->_infos[ 0];
   return( info->natural_size);
}


- (void) mulleDump
{
   NSUInteger   i;

   fprintf( stderr, "signature:\n\t%s\n", self->_types);

   for( i = 0; i < _count; i++)
   {
      switch( i)
      {
      case 0  : mulle_fprintf( stderr, "rval:\n"); break;
      case 1  : mulle_fprintf( stderr, "self:\n"); break;
      case 2  : mulle_fprintf( stderr, "_cmd:\n"); break;
      default : mulle_fprintf( stderr, "arg%ld:\n", (long) i - 3); break;
      }

#ifdef mulle_objc_typeinfodump_h__
#  warning "mulle_objc_typeinfodump_h__ is no longer compatible with MulleObjCMethodSignatureTypeInfo (now struct mulle_methodsignature_arginfo)"
#endif
   }
}

@end


// Register NSMethodSignature as the static instance class for slot
// MULLE_OBJC_STATICINSTANCE_METHODSIGNATURE_INDEX (4).
// Any C struct with isa == (void *) 4 that has been added to the universe
// via _mulle_objc_universe_add_staticinstance will have its isa patched to
// the real NSMethodSignature class pointer when this +load runs.

@interface NSMethodSignatureLoader : NSObject
@end

@implementation NSMethodSignatureLoader

@dependency NSThread;

+ (void) load
{
   struct _mulle_objc_universe    *universe;
   struct _mulle_objc_infraclass  *arr[ MULLE_OBJC_STATICINSTANCE_CLASS_SLOTS];

   universe = _mulle_objc_infraclass_get_universe( self);

   memset( arr, 0, sizeof( arr));
   arr[ MULLE_OBJC_STATICINSTANCE_METHODSIGNATURE_INDEX] =
      (struct _mulle_objc_infraclass *) [NSMethodSignature class];
   _mulle_objc_universe_set_staticinstanceclasses( universe, arr, 0);
}

@end
