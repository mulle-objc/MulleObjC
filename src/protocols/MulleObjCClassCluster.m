//
//  MulleObjCClassCluster.m
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

#import "MulleObjCClassCluster.h"

// other files in this library
#include "MulleObjCAllocation.h"

// std-c and dependencies


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wprotocol"


@interface MulleObjCClassCluster < MulleObjCClassCluster>
@end


@implementation MulleObjCClassCluster

//
// MULLE_OBJC_IS_CLASSCLUSTER gets inherited by the class, that implements the
// protocol but JUST that class
//
+ (void) initialize
{
   struct _mulle_objc_classpair   *pair;

   // has is shallow, conforms is deep
   pair = _mulle_objc_infraclass_get_classpair( self);
   if( _mulle_objc_classpair_has_protocolid( pair, (mulle_objc_protocolid_t) @protocol( MulleObjCClassCluster)))
      _mulle_objc_infraclass_set_state_bit( self, MULLE_OBJC_IS_CLASSCLUSTER);
}


static id   MulleObjCNewClassClusterPlaceholder( Class infraCls)
{
   mulle_objc_methodimplementation_t   imp;
   struct _mulle_objc_class            *cls;
   id                                  placeholder;
   mulle_objc_methodid_t               sel;
   
   placeholder = NSAllocateObject( infraCls, 0, NULL);
   cls         = _mulle_objc_infraclass_as_class( infraCls);
   sel         = @selector( __initPlaceholder);
   imp         = _mulle_objc_class_lookup_methodimplementation_no_forward( cls, sel);
   if( imp)
      (*imp)( placeholder, sel, NULL);

   return( placeholder);
}


+ (instancetype) alloc
{
   struct _mulle_objc_object   *placeholder;

   //
   // only the class marked as MulleObjCClassCluster gets the
   // placeholder, subclasses use regular alloc
   // the class being a classcluster marks itself during
   // +initialize
   //
   if( ! _mulle_objc_infraclass_get_state_bit( self, MULLE_OBJC_IS_CLASSCLUSTER))
   {
#if DEBUG
      fprintf( stderr, "warning: Class %08x \"%s\" is a subclass of MulleObjCClassCluster but gets allocated directly. (Non classcluster subclasses should implement +alloc)\n",
                 _mulle_objc_infraclass_get_classid( self),
                 _mulle_objc_infraclass_get_name( self));
#endif
      return( NSAllocateObject( self, 0, NULL));
   }
   assert( ! _mulle_objc_infraclass_get_state_bit( self, MULLE_OBJC_IS_SINGLETON));

   placeholder = _mulle_objc_infraclass_get_auxplaceholder( self);
   if( ! placeholder)
   {
      placeholder = (struct _mulle_objc_object *) MulleObjCNewClassClusterPlaceholder( self);
      _ns_add_placeholder( placeholder);
      _mulle_objc_infraclass_set_auxplaceholder( self, placeholder);
   }

   // retain the placeholder
   return( [(id) placeholder retain]);
}


+ (instancetype) new
{
   return( [[self alloc] init]);
}

@end
