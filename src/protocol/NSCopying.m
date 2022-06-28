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

#import "NSCopying.h"

#import "NSObject.h"
#import "MulleObjCAllocation.h"
#import "NSRange.h"


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
#pragma clang diagnostic ignored "-Wprotocol"



id   NSCopyObject( id object, NSUInteger extraBytes, NSZone *zone)
{
   id      clone;
   Class   infraCls;

   infraCls = [object class];
   clone    = _MulleObjCClassAllocateInstance( infraCls, extraBytes);
   memcpy( clone, object, extraBytes + _mulle_objc_infraclass_get_instancesize( infraCls));
   return( clone);
}


@interface NSCopying < NSCopying>
@end



@implementation NSCopying

- (id) copy
{
   return( NSCopyObject( self, 0, NULL));
}

@end


@implementation NSObject ( NSCopying)


- (id) copyWithZone:(NSZone *) zone
{
   fprintf( stderr, "-[NSObject copyWithZone:] doesn't work anymore.\n"
"\n"
"Either rename your -copyWithZone: implementations to -copy or add a\n"
"-copy method to each class that implements -copyWithZone:\n"
"\n"
"Endless recursion awaits those, who don't heed this advice.\n");
   abort();
}


- (id) copy
{
   return( NSCopyObject( self, 0, NULL));
}


@end
