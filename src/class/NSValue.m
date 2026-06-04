//
//  NSValue.m
//  MulleObjCValueFoundation
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
#import "NSValue.h"

// other files in this library
#import "_MulleObjCConcreteValue.h"
#import "MulleDynamicObject.h"
#import "MulleObjCException.h"


// std-c and dependencies
#import "import-private.h"
#include <string.h>
#include <stdint.h>


@implementation NSObject( _NSValue)

- (BOOL) __isNSValue
{
   return( NO);
}

@end


@implementation NSValue

- (BOOL) __isNSValue
{
   return( YES);
}


#pragma mark - classcluster ?

- (instancetype) initWithBytes:(void *) value
                      objCType:(char *) type
{
   self = [_MulleObjCConcreteValue mulleNewWithBytes:value
                                            objCType:type];
   return( self);
}


#pragma mark - convenience constructors

// compiler: need an @alias( alloc, whatever), so that implementations
//           can  be shared


+ (instancetype) value:(void *) bytes
          withObjCType:(char *) type
{
   return( [[[self alloc] initWithBytes:bytes
                               objCType:type] autorelease]);
}


+ (instancetype) valueWithBytes:(void *) bytes
                       objCType:(char *) type
{
   return( [[[self alloc] initWithBytes:bytes
                               objCType:type] autorelease]);
}


+ (instancetype) valueWithPointer:(void *) pointer
{
   return( [[[self alloc] initWithBytes:&pointer
                               objCType:@encode( void *)] autorelease]);
}


+ (instancetype) valueWithRange:(NSRange) range
{
   return( [[[self alloc] initWithBytes:&range
                               objCType:@encode( NSRange)] autorelease]);
}


+ (instancetype) valueWithNonretainedObject:(id) obj
{
   static char   assign_obj[ 2] = { _C_ASSIGN_ID, 0 };

   return( [[[self alloc] initWithBytes:&obj
                               objCType:assign_obj] autorelease]);
}


- (NSUInteger) _size
{
   NSUInteger   size;

   NSGetSizeAndAlignment( [self objCType], &size, NULL);
   return( size);
}


- (void) getValue:(void *) bytes
             size:(NSUInteger) size
{
   NSUInteger   real;

   if( ! bytes && size)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "NULL bytes");

   NSGetSizeAndAlignment( [self objCType], &real, NULL);
   if( real != size)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "size should be %ld bytes on this platform", real);

   [self getValue:bytes];
}


- (void *) pointerValue
{
   void  *pointer;

   [self getValue:&pointer
             size:sizeof( void *)];
   return( pointer);
}


- (id) nonretainedObjectValue
{
   id   obj;

   [self getValue:&obj
             size:sizeof( id)];
   return( obj);
}


- (NSRange) rangeValue
{
   NSRange  range;

   [self getValue:&range
             size:sizeof( NSRange)];
   return( range);
}


- (BOOL) isEqual:(id) other
{
   if( self == other)
      return( YES);
   if( ! [other __isNSValue])
      return( NO);
   return( [self isEqualToValue:other]);
}


- (BOOL) isEqualToValue:(NSValue *) other
{
   char        *type;
   char        *oType;
   NSUInteger   size;
   NSUInteger   otherSize;
   BOOL         flag;

   assert( [other isKindOfClass:[NSValue class]]);

   type  = [self objCType];
   oType = [other objCType];

   // should not compare adornments ?
   if( strcmp( type, oType))
      return( NO);

   NSGetSizeAndAlignment( type, &size, NULL);
   NSGetSizeAndAlignment( oType, &otherSize, NULL);

   if( size != otherSize)
      return( NO);

   {
      auto char   buf[ size];
      auto char   buf2[ size];

      [self getValue:&buf];
      [other getValue:&buf2];

      flag = ! memcmp( buf, buf2, size);
   }

   return( flag);
}


MULLE_C_NONNULL_FIRST
static void   _MulleDynamicObjectRangeSetter( MulleDynamicObject *self,
                                              mulle_objc_methodid_t _cmd,
                                              void *_param)
{
   _MulleDynamicObjectValueSetter( self, _cmd, _param, @encode( NSRange));
}


MULLE_C_NONNULL_FIRST
static void   _MulleDynamicObjectRangeSetterWillChange( MulleDynamicObject *self,
                                                        mulle_objc_methodid_t _cmd,
                                                       void *_param)
{
   _mulle_objc_object_call_inline_full( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleDynamicObjectValueSetter( self, _cmd, _param, @encode( NSRange));
}


- (IMP) setterImplementationForObjCType:(char *) type
                           accessorBits:(NSUInteger) bits
{
   int   isObservable;

   type         = _mulle_objc_signature_skip_type_qualifier( type);
   isObservable = bits & _mulle_objc_property_observable;

   if( _mulle_objc_ivarsignature_is_binary_compatible( type, @encode( NSRange)))
      return( (IMP) (isObservable
                     ? _MulleDynamicObjectRangeSetterWillChange
                     : _MulleDynamicObjectRangeSetter));
   return( 0);
}

@end
