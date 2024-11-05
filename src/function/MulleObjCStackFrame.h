//
//  ns_debug.h
//  MulleObjC
//
//  Copyright (c) 2015 Nat! - Mulle kybernetiK.
//  Copyright (c) 2015 Codeon GmbH.
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

// need a different prefix here
#ifndef MulleObjCStackFrame__h__
#define MulleObjCStackFrame__h__

#import "import.h"

#import "MulleObjCIntegralType.h"

// this should move to OS Foundation!

MULLE_OBJC_GLOBAL
void         *MulleObjCFrameAddress( NSUInteger frame);

MULLE_OBJC_GLOBAL
void         *MulleObjCReturnAddress( NSUInteger frame);

MULLE_OBJC_GLOBAL
NSUInteger   MulleObjCCountFrames( void);


static inline void   *NSFrameAddress( NSUInteger frame)
{ 
   return( MulleObjCFrameAddress( frame));
}


static inline void   *NSReturnAddress( NSUInteger frame)
{ 
   return( MulleObjCReturnAddress( frame));
}


static inline NSUInteger   NSCountFrames( void)
{ 
   return( MulleObjCCountFrames());
}

#endif
