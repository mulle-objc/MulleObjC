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

#import "NSMutableCopying.h"

#import "NSObject.h"
#import "MulleObjCAllocation.h"
#import "NSRange.h"

@interface NSObject( Copy)

- (id) copy;

@end

static mulle_objc_walkcommand_t
   copy_or_retain_property( struct _mulle_objc_property *property,
                            struct _mulle_objc_infraclass *cls,
                            void *info)
{
   id                        self = info;
   uint32_t                  mode;
   id                        *p_ivar;
   id                        value;
   int                       offset;
   mulle_objc_ivarid_t       ivarid;
   struct _mulle_objc_ivar   *ivar;
   
   mode = property->bits & (_mulle_objc_property_retain|_mulle_objc_property_copy);
   if( ! mode)
      return( mulle_objc_walk_ok);

   ivarid  = _mulle_objc_property_get_ivarid( property);
   if( ! ivarid)  // gotta by dynamic then
   {
      assert( property->bits & _mulle_objc_property_dynamic);
      return( mulle_objc_walk_ok);
   }

   ivar    = mulle_objc_infraclass_search_ivar( cls, ivarid);
   offset  = _mulle_objc_ivar_get_offset( ivar);
   p_ivar  = (id *) &((char *) self)[ offset];
   value   = (mode & _mulle_objc_property_copy) ? [*p_ivar copy] : [*p_ivar retain];
   *p_ivar = value;

   return( mulle_objc_walk_ok);
}


id   MulleObjCInstanceCopy( id object, NSUInteger extraBytes, NSZone *zone)
{
   id      clone;
   Class   infraCls;

   infraCls = [object class];
   clone    = _MulleObjCClassAllocateInstance( infraCls, extraBytes);
   memcpy( clone, object, extraBytes + _mulle_objc_infraclass_get_instancesize( infraCls));

   // MEMO: rename to mulleCopyOfInstanceRetainsProperties ?
   if( [infraCls mulleCopyRetainsProperties])
   {
      _mulle_objc_infraclass_walk_properties( infraCls,
                                              _mulle_objc_infraclass_get_inheritance( infraCls),
                                              copy_or_retain_property,
                                              clone);  
   }
   return( clone);
}




#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
#pragma clang diagnostic ignored "-Wprotocol"



@interface NSMutableCopying < NSMutableCopying>
@end


@implementation NSMutableCopying

- (id) mutableCopy
{
   return( MulleObjCInstanceCopy( self, 0, NULL));
}


+ (BOOL) mulleCopyRetainsProperties
{
   return( YES);
}

@end

