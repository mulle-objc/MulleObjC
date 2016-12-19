//
//  MulleObjCTaggedPointer.m
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
#import "MulleObjCTaggedPointer.h"

#include "ns_exception.h"

#include <mulle_objc/mulle_objc.h>


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wprotocol"


@interface MulleObjCTaggedPointer < MulleObjCTaggedPointer>
@end


@implementation MulleObjCTaggedPointer

- (void) dealloc
{
   abort();
}


- (id) retain
{
   return( self);
}


- (id) autorelease
{
   return( self);
}


- (void) release
{
}


- (id) copy
{
   return( self);
}



/*
   MEMO:

   If the compiler doesn't produce tagged pointers. It's not a problem.
   The compiler must produce tagged pointer aware method calls, when inlining
   code.
*/
+ (BOOL) isTaggedPointerEnabled
{
   struct _mulle_objc_runtime  *runtime;

   runtime = _mulle_objc_class_get_runtime( self);
   return( ! runtime->config.no_tagged_pointers);
}


int   MulleObjCTaggedPointerRegisterClassAtIndex( Class cls, unsigned int index)
{
   struct _mulle_objc_runtime  *runtime;
   int                         rval;

   if( ! cls)
   {
      errno = EINVAL;
      return( -1);
   }

   runtime = _mulle_objc_class_get_runtime( cls);
   if( ! index)
      MulleObjCThrowInvalidIndexException( index);

   rval = _mulle_objc_runtime_set_taggedpointerclass_at_index( runtime, cls, index);
   if( ! rval)
      _mulle_objc_class_set_taggedpointerindex( cls, index);
   return( rval);
}

@end
