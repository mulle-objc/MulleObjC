//
//  NSDebug.h
//  MulleObjC
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
#import "NSObject.h"

#import "MulleObjCDebug.h"


@interface NSObject ( NSDebug)

- (id) debugDescription;

@end

// this is the method that is searched for by "gdb" when you do a `po obj`
// in it
MULLE_OBJC_GLOBAL
char   *_NSPrintForDebugger( id a);

MULLE_OBJC_GLOBAL
MULLE_C_CONST_RETURN
BOOL   MulleObjCIsDebugEnabled( void);

#define NSDebugEnabled  MulleObjCIsDebugEnabled()



MULLE_OBJC_GLOBAL
void   _MulleObjCZombifyObject( id obj, int shred);

static inline void   MulleObjCZombifyObject( id obj, int shred)
{
   if( ! obj)
      return;

   _MulleObjCZombifyObject( obj, shred);
}


//
// now coming up: some unused old junk
//                that sticks around for compatibility
enum
{
   NSObjectAutoreleasedEvent = 3,
   NSObjectExtraRefDecrementedEvent = 5,
   NSObjectExtraRefIncrementedEvent = 4,
   NSObjectInternalRefDecrementedEvent =7,
   NSObjectInternalRefIncrementedEvent = 8
};

extern BOOL   NSKeepAllocationStatistics;


// compatibility
static inline void   NSRecordAllocationEvent( int eventType, id object)
{
}


// interfaces with mulle-stacktrace value enhancer
MULLE_OBJC_GLOBAL
char   *MulleObjCStacktraceSymbolize( void *addresse,
                                      size_t max,
                                      char *buf,
                                      size_t len,
                                      void **userinfo);

MULLE_OBJC_GLOBAL
void   MulleObjCCSVDumpMethodsToTmp( void);
