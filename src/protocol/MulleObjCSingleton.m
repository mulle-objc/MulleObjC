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
#import "import-private.h"

#import "MulleObjCSingleton.h"

#import "mulle-objc-type.h"
#import "mulle-objc-classbit.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCAllocation.h"
#import "NSRange.h"
#import "version.h"

#import "mulle-objc-universefoundationinfo-private.h"


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wprotocol"


@interface MulleObjCSingleton < MulleObjCSingleton>
@end


@implementation MulleObjCSingleton


// MULLE_OBJC_IS_CLASSCLUSTER gets inherited by the class, that implements the
// protocol but JUST that class
//
void   MulleObjCSingletonMarkClassAsSingleton( Class self)
{
   struct _mulle_objc_classpair   *pair;

   // has is shallow, conforms is deep
   pair = _mulle_objc_infraclass_get_classpair( self);
   if( _mulle_objc_classpair_has_protocolid( pair, @protocol( MulleObjCSingleton)))
      _mulle_objc_infraclass_set_state_bit( self, MULLE_OBJC_INFRA_IS_SINGLETON);
#if DEBUG
   else
      fprintf( stderr, "warning: Class %08x \"%s\" is a subclass of MulleObjCSingleton but does not implement it as a protocol\n",
           _mulle_objc_infraclass_get_classid( self),
           _mulle_objc_infraclass_get_name( self));
#endif
}


+ (void) initialize
{
   MulleObjCSingletonMarkClassAsSingleton( self);
}


id  MulleObjCSingletonCreate( Class infraCls)
{
   id <NSObject>                 singleton;
   struct _mulle_objc_universe   *universe;

   assert( ! _mulle_objc_infraclass_get_state_bit( infraCls, MULLE_OBJC_INFRA_IS_CLASSCLUSTER));
   singleton = (id) _mulle_objc_infraclass_get_auxplaceholder( infraCls);
   if( singleton)
   	return( singleton);

   universe = _mulle_objc_infraclass_get_universe( infraCls);
   if( ! _mulle_objc_infraclass_get_state_bit( infraCls, MULLE_OBJC_INFRA_IS_SINGLETON))
      __mulle_objc_universe_raise_internalinconsistency( universe,
      			"MULLE_OBJC_INFRA_IS_SINGLETON bit is missing on class "
      			"\"%s\" with id %x", _mulle_objc_infraclass_get_name( infraCls),
      									   _mulle_objc_infraclass_get_classid( infraCls));

   // avoid +alloc here so that subclass can "abort" on alloc if desired
   singleton = [NSAllocateObject( infraCls, 0, NULL) init];
   _mulle_objc_universe_add_rootsingleton( universe, singleton);
   _mulle_objc_infraclass_set_auxplaceholder( infraCls, (void *) singleton);

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
