//
//  NSNull.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "NSNull.h"

// other files in this library

// other libraries of MulleObjCValueFoundation
#import "import.h"

// std-c and dependencies


@implementation NSObject( _NSNull)


- (BOOL) __isNSNull
{
   return( NO);
}

@end


@implementation NSNull

- (BOOL) __isNSNull
{
   return( YES);
}


//
// NSNull is hardcore singleton and does not like
// coexisting NSNulls because then you can not compare with pointer equality.
// Note that this is broken when using MULLE_OBJC_EPHEMERAL_SINGLETON, but
// thats not NSNulls fault ;)
//
- (id) init
{
   Class   cls;

   cls = MulleObjCObjectGetClass( self);
   [self release];
   return( [MulleObjCSingletonCreate( cls) retain]);
}



- (id) __initSingleton
{
   return( self);
}


- (instancetype) initWithCoder:(NSCoder *) coder
{
   return( [self init]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
}


+ (NSNull *) null
{
   return( MulleObjCSingletonCreate( self));
}


#ifdef DEBUG
- (id) retain
{
   return( [super retain]);
}

- (void) release
{
   [super release];
}
#endif


- (id) copy
{
   return( [self retain]);
}


- (NSComparisonResult) compare:(id) other
{
   if( other == self)
      return( NSOrderedSame);
   if( ! other)
      return( NSOrderedSame);
   return( NSOrderedAscending);
}

//
// Unknown messages sent to NSNull are just like methods sent to nil.
// Different to Apple Foundation, but makes it easier to use when they
// subsitute NSNumber, NSString, NSArray... basically anything because
// now -count or -length returns 0.
//
- (void *) forward:(void *) args
{
   return( NULL);
}

@end
