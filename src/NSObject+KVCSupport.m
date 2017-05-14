//
//  NSObject+KVCSupport.m
//  MulleObjC
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "NSObject+KVCSupport.h"

#import <mulle_concurrent/mulle_concurrent.h>


@implementation NSObject ( KVCSupport)


static void  divine_info( NSObject *self,
                          struct _MulleObjCKVCInformation *kvcInfo,
                          id <NSStringFuture> key,
                          struct _mulle_objc_kvcinfo *info,
                          enum _MulleObjCKVCMethodType type)
{
   [self _divineKVCInformation:kvcInfo
                        forKey:key
                    methodType:type];

   if( kvcInfo->offset)
   {
      assert( info->offset == kvcInfo->offset || ! info->offset);
      info->offset = kvcInfo->offset;
   }

   if( kvcInfo->valueType != _C_ID)
   {
      assert( (info->valueType == kvcInfo->valueType) || (info->valueType == _C_ID));
      info->valueType = kvcInfo->valueType;
   }

   info->methodid[ type]       = (mulle_objc_methodid_t) kvcInfo->selector;
   info->implementation[ type] = (mulle_objc_methodimplementation_t) kvcInfo->implementation;
}

//
// it's just a cache, if it's not there it's not a problem
// if there is a very unlikely collision, ignore the cache
//
- (void) _getKVCInformation:(struct _MulleObjCKVCInformation *) kvcInfo
                     forKey:(id <NSStringFuture>) key
                 methodType:(enum _MulleObjCKVCMethodType) type
{
   NSUInteger                   length;
   NSUInteger                   size;
   struct mulle_allocator       *allocator;
   struct _mulle_objc_kvcinfo   *info;
   struct _mulle_objc_class     *cls;
   unsigned int                 i;
   auto char                    buf[ 256];
   char                         *s;

   cls    = _mulle_objc_object_get_isa( self);
   size   = sizeof( buf);
   s      = buf;
   length = [key _getUTF8String:s
                     bufferSize:size];

   if( length >= size)
   {
      size      = length + 1;
      allocator = _mulle_objc_class_get_kvcinfo_allocator( cls);
      s         = mulle_allocator_malloc( allocator, size);
      [key _getUTF8String:s
               bufferSize:size];
   }

   info = _mulle_objc_class_lookup_kvcinfo( cls, buf);
   if( info)
   {
      if( s != buf)
         mulle_allocator_free( allocator, buf);

      if( info != MULLE_OBJC_KVCINFO_CONFLICT)
      {
         kvcInfo->key            = key;
         kvcInfo->offset         = (int) info->offset;
         kvcInfo->selector       = (SEL) info->methodid[ type];
         kvcInfo->implementation = (IMP) info->implementation[ type];
         kvcInfo->valueType      = info->valueType;
         return;
      }

      // cache don't work, just divine the info for this manually
      [self _divineKVCInformation:kvcInfo
                           forKey:key
                       methodType:type];
      return;
   }

   allocator = _mulle_objc_class_get_kvcinfo_allocator( cls);
   info      = _mulle_objc_kvcinfo_new( buf, allocator);
   if( s != buf)
      mulle_allocator_free( allocator, buf);

   assert( info->valueType == _C_ID);

   //
   // ok, divine the info for all 4 cases and put it into the cache
   // divine the one we want last
   //
   for( i = _MulleObjCKVCValueForKeyIndex; i <= _MulleObjCKVCTakeStoredValueForKeyIndex; i++)
   {
      if( i == type)
         continue;

      divine_info( self, kvcInfo, key, info, i);
   }

   divine_info( self, kvcInfo, key, info, type);

   _mulle_objc_class_set_kvcinfo( cls, info);
}

@end
