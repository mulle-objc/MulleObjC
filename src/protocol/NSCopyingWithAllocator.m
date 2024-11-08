//
//  NSCopying.m
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
#import "import-private.h"

#import "NSCopyingWithAllocator.h"

#import "NSObject.h"
#import "MulleObjCAllocation.h"
#import "NSRange.h"


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
#pragma clang diagnostic ignored "-Wprotocol"


struct copy_info
{
   id                       obj;
   id                       clone;
   struct mulle_allocator   *allocator;
};

int   _MulleObjCInstanceCopyWithAllocatorProperty( struct _mulle_objc_property *property,
                                                   struct _mulle_objc_infraclass *cls,
                                                   void *userinfo);

int   _MulleObjCInstanceCopyWithAllocatorProperty( struct _mulle_objc_property *property,
                                                   struct _mulle_objc_infraclass *cls,
                                                   void *userinfo)
{
   struct copy_info           *info = userinfo;
   uint32_t                   bits;
   ptrdiff_t                  offset;
   struct _mulle_objc_ivar    *ivar;
   mulle_objc_ivarid_t        ivarid;
   id                         value;

   bits = _mulle_objc_property_get_bits( property);
   if( bits & _mulle_objc_property_dynamic)
      return( 0);

   if( ! (bits & _mulle_objc_property_copy))
      return( 0);

   ivarid = _mulle_objc_property_get_ivarid( property);
   ivar   = mulle_objc_infraclass_search_ivar( cls, ivarid);
   offset = _mulle_objc_ivar_get_offset( ivar);
   value  = mulle_objc_object_get_property_value( info->obj, 0, offset, 0);
   if( ! value)
      return( 0);
   value = [value copyWithAllocator:info->allocator];
   mulle_objc_object_set_property_value( info->obj, 0, offset, NULL, 0);

   //
   // This happens for readonly properties, which have no setter.
   // They are penalized with a bsearch for the ivar.
   //
   // Why ?
   //    Readonly properties are unneccessary. Use a regular accessor.
   //    The property has no direct link to the ivar. The compiler can't emit
   //    this as the ivar could reside in the superclass.
   //    Adding the ivar at runtime into the loaded structure breaks the
   //    constness of the setup, which I'd like to keep and blows up the
   //    runtime for supporting readonly, which I find superfluous and
   //    likely to be removed.
   //
   // Remedy?
   //    Compiler emits setter code for readonly properties. Let the compiler
   //    complain/warn about the missing setter.
   //
   if( bits & _mulle_objc_property_autoreleaseclear)
   {
      ivarid = _mulle_objc_property_get_ivarid( property);
      ivar   = mulle_objc_infraclass_search_ivar( cls, ivarid);
      offset = _mulle_objc_ivar_get_offset( ivar);
      mulle_objc_object_set_property_value( info->obj, 0, offset, NULL, 0);
   }
   return( 0);
}


int   _MulleObjCClassCopyWithAllocatorProperties( struct _mulle_objc_infraclass *infra,
                                                  mulle_objc_walkpropertiescallback_t f,
                                                  void *userinfo);

int   _MulleObjCClassCopyWithAllocatorProperties( struct _mulle_objc_infraclass *infra,
                                                  mulle_objc_walkpropertiescallback_t f,
                                                  void *userinfo)
{
   struct _mulle_objc_propertylist   *list;
   struct _mulle_objc_infraclass     *superclass;
   unsigned int                      n;
   int                               rval;

   n = mulle_concurrent_pointerarray_get_count( &infra->propertylists);
   assert( n);
   if( infra->base.inheritance & MULLE_OBJC_CLASS_DONT_INHERIT_CATEGORIES)
      n = 1;

   mulle_concurrent_pointerarray_for_reverse( &infra->propertylists, n, list)
   {
      if( (rval = _mulle_objc_propertylist_walk( list, f, infra, userinfo)))
         return( rval);
   }

   superclass = _mulle_objc_infraclass_get_superclass( infra);
   if( superclass && superclass != infra)
      return( _MulleObjCClassCopyWithAllocatorProperties( superclass, f, userinfo));

   return( 0);
}



id   MulleObjCInstanceCopyWithAllocator( id obj,
                                NSUInteger extraBytes,
                                struct mulle_allocator *allocator)
{
   id                clone;
   Class             infraCls;
   struct copy_info  info;


   if( [obj respondsToSelector:@selector( mulleAllocator)] &&
       [(NSObject *) obj mulleAllocator] == allocator)
   {
      return( [obj retain]);
   }

   infraCls = [obj class];
   clone    = _MulleObjCClassAllocateInstanceWithAllocator( infraCls,
                                                            extraBytes, allocator);

   info.obj       = obj;
   info.clone     = clone;
   info.allocator = allocator;

   _MulleObjCClassCopyWithAllocatorProperties( infraCls,
                                              _MulleObjCInstanceCopyWithAllocatorProperty,
                                              &info);

   memcpy( clone, obj, extraBytes + _mulle_objc_infraclass_get_instancesize( infraCls));
   return( clone);
}


@interface NSCopyingWithAllocator < NSCopyingWithAllocator>
@end



@implementation NSCopyingWithAllocator

- (id) copyWithAllocator:(struct mulle_allocator *) allocator
{
   return( MulleObjCInstanceCopyWithAllocator( self, 0, allocator));
}

@end

