//
//  MulleObjCStandard.h
//  MulleObjC
//
//  Copyright (c) 2024 Nat! - Mulle kybernetiK.
//  All rights reserved.
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
#ifndef MulleObjCStandardImplementation_h__
#define MulleObjCStandardImplementation_h__

#include "mulle-objc.h"


//
// Standard method implementations as named C functions.
// These are the known-good implementations for the method families.
// Subclasses can opt back into the fast path by using:
//    @method_implementation -init = MulleObjCStandardInit;
//

// family 1: +alloc  (class method)
MULLE_OBJC_GLOBAL
id   MulleObjCStandardAlloc( id self, SEL sel, void *param);

// family 3: -init  (instance method)
MULLE_OBJC_GLOBAL
id   MulleObjCStandardInit( id self, SEL sel, void *param);

// family 5: +new  (class method)
MULLE_OBJC_GLOBAL
id   MulleObjCStandardNew( id self, SEL sel, void *param);

// family 6: -autorelease  (instance method)
MULLE_OBJC_GLOBAL
id   MulleObjCStandardAutorelease( id self, SEL sel, void *param);

// family 7: -dealloc  (instance method)
MULLE_OBJC_GLOBAL
void   MulleObjCStandardDealloc( id self, SEL sel);

// family 8: -finalize  (instance method)
MULLE_OBJC_GLOBAL
void   MulleObjCStandardFinalize( id self, SEL sel);

// family 9: -release  (instance method)
MULLE_OBJC_GLOBAL
void   MulleObjCStandardRelease( id self, SEL sel);

// family 10: -retain  (instance method)
MULLE_OBJC_GLOBAL
id   MulleObjCStandardRetain( id self, SEL sel, void *param);

// family 11: -retainCount  (instance method)
MULLE_OBJC_GLOBAL
NSUInteger   MulleObjCStandardRetainCount( id self, SEL sel, void *param);

// family 12: -self  (instance method)
MULLE_OBJC_GLOBAL
id   MulleObjCStandardSelf( id self, SEL sel, void *param);

#endif
