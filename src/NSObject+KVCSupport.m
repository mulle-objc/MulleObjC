//
//  NSObject+KVCSupport.m
//  MulleObjC
//
//  Created by Nat! on 15.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSObject+KVCSupport.h"

#import <mulle_concurrent/mulle_concurrent.h>


@implementation NSObject ( KVCSupport)

//
// it's just a cache, if it's not there it's not a problem
// if there is a very unlikely collision, ignore the cache
//
- (void) _getKVCInformation:(struct _MulleObjCKVCInformation *) kvcInfo
                     forKey:(id <NSStringFuture>) key
                 methodType:(enum _MulleObjCKVCMethodType) type
{
   NSUInteger                   size;
   struct mulle_allocator       *allocator;
   struct _mulle_objc_kvcinfo   *info;
   struct _mulle_objc_class     *cls;
   unsigned int                 i;
   
   cls  = _mulle_objc_object_get_isa( self);
   size = [key _UTF8StringLength] + 1;
   {
      auto char   buf[ size];
      
      [key getUTF8String:buf
              bufferSize:size];
      
      info = _mulle_objc_class_lookup_kvcinfo( cls, buf);
      if( info)
      {
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
      assert( info->valueType == _C_ID);
      
      //
      // ok, divine the info for all 4 cases and put it into the cache
      // divine the one we want last
      //
      for( i = 0; i < 5; i++)
      {
         if( i == type)
            continue;
         if( i == 5)
            i = type;
         
         [self _divineKVCInformation:kvcInfo
                              forKey:key
                          methodType:i];
         
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
         
         info->methodid[ i]       = (mulle_objc_methodid_t) kvcInfo->selector;
         info->implementation[ i] = (mulle_objc_methodimplementation_t) kvcInfo->implementation;
      }
      
      _mulle_objc_class_set_kvcinfo( cls, info);
   }
}

@end



