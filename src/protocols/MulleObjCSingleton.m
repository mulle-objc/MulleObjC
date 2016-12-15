//
//  MulleObjCSingleton.m
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

#import "MulleObjCSingleton.h"

#import "MulleObjCAllocation.h"

#include "ns_type.h"


@interface MulleObjCSingleton < MulleObjCSingleton>
@end


@implementation MulleObjCSingleton

+ (void) initialize
{
   _mulle_objc_class_set_state_bit( self, MULLE_OBJC_IS_SINGLETON);
}



id  MulleObjCSingletonCreate( Class self)
{
   id <NSObject>  singleton;
   Class          cls;
   
   assert( ! _mulle_objc_class_get_state_bit( self, MULLE_OBJC_IS_CLASSCLUSTER));

#if 0
   for( cls = self; cls; cls = [cls superclass])
      if( _mulle_objc_class_get_state_bit( cls, MULLE_OBJC_IS_SINGLETON))
         break;
#endif

   cls = self;
   if( ! _mulle_objc_class_get_state_bit( cls, MULLE_OBJC_IS_SINGLETON))
      mulle_objc_throw_internal_inconsistency_exception( "missing MULLE_OBJC_IS_CLASSCLUSTER bit on class %p", self);
   
   singleton = (id) _mulle_objc_class_get_auxplaceholder( cls);
   if( ! singleton)
   {
      // avoid +alloc here so that subclass can "abort" on alloc if desired
      singleton = [NSAllocateObject( self, 0, NULL) init];
      _ns_add_singleton( singleton);
      _mulle_objc_class_set_auxplaceholder( cls, (void *) singleton);
   }

   return( (id) singleton);
}


//
// a subclass can be installed and, when it's sharedInstance message is called
// it will override the superclass (and be stored in the superclass) provided
// that the subclass does not declare the protocol MulleObjCSingleton again
//
+ (instancetype) sharedInstance
{
   return( MulleObjCSingletonCreate( self));
}


@end
