//
//  MulleObjCSingleton.h
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

#import "NSObjectProtocol.h"

#include "mulle-objc-classbit.h"

//
// singletons are expected to be created through "sharedInstance"
// and not through alloc, if you use alloc you get another instance
//
PROTOCOLCLASS_INTERFACE0( MulleObjCSingleton)

@optional  // MulleObjCSingleton implements this for you
+ (void) initialize;  // #1#
+ (instancetype) sharedInstance;

PROTOCOLCLASS_END()


// for subclasses, who don't use sharedInstance
id     MulleObjCSingletonCreate( Class self);


static inline BOOL   MulleObjCIsSingletonInstance( id obj)
{
   Class  infraCls;

   if( ! obj)
      return( NO);

   infraCls = mulle_objc_object_get_infraclass( obj);
   return( _mulle_objc_infraclass_get_state_bit( infraCls, MULLE_OBJC_INFRA_IS_SINGLETON) ? YES : NO);
}


// #1#
// if your class overrides +initialize and implements MulleObjCClassCluster
// then you must call [super initialize] or this
//

void   MulleObjCSingletonMarkClassAsSingleton( Class self);
