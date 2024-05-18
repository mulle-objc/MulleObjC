//
//  MulleObjCDebug.h
//  MulleObjC
//
//  Created by Nat! on 11.03.23.
//  Copyright © 2023 Mulle kybernetiK.
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

#include "include.h"

// these need to be in MulleObjC to get the compiled UNIVERSE ID

MULLE_OBJC_GLOBAL
void   MulleObjCHTMLDumpUniverseToDirectory( char *directory);
MULLE_OBJC_GLOBAL
void   MulleObjCHTMLDumpUniverseToTmp( void);
MULLE_OBJC_GLOBAL
void   MulleObjCHTMLDumpUniverse( void);

MULLE_OBJC_GLOBAL
void   MulleObjCHTMLDumpClassToDirectory( char *classname, char *directory);
MULLE_OBJC_GLOBAL
void   MulleObjCHTMLDumpClass( char *classname);
MULLE_OBJC_GLOBAL
void   MulleObjCHTMLDumpClassToTmp( char *classname);

MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpClassToDirectory( char *classname, char *directory);
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpClassToTmp( char *classname);
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpClass( char *classname);

MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpUniverseFrameToTmp( void);
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpUniverseToTmp( void);
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpUniverse( void);

// dump all relevant classes and instance methods, starting from classname
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpMetaHierarchyToDirectory( char *classname, char *directory);
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpInfraHierarchyToTmp( char *classname);
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpInfraHierarchy( char *classname);

// dump all relevant classes and class methods, starting from classname
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpMetaHierarchyToDirectory( char *classname, char *directory);
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpMetaHierarchyToTmp( char *classname);
MULLE_OBJC_GLOBAL
void   MulleObjCDotdumpMetaHierarchy( char *classname);


MULLE_OBJC_GLOBAL
void   MulleObjCDumpObject( id object);

