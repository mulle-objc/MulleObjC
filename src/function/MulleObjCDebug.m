//
//  MulleObjCDebug.h
//  MulleObjC
//
//  Copyright © 2023 Mulle kybernetiK.
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
#define _GNU_SOURCE

#include "MulleObjCDebug.h"

#include "include-private.h"

#include "MulleObjCUniverse.h"

#ifdef MULLE_OBJC_DEBUG_SUPPORT

#include <mulle-objc-debug/mulle-objc-debug.h>
#include <string.h>




static struct _mulle_objc_infraclass   *infraclass_from_string( char *classname)
{
   struct _mulle_objc_universe     *universe;
   struct _mulle_objc_infraclass   *infra;
   mulle_objc_classid_t            classid;

   if( ! classname || ! *classname)
   {
      fprintf( stderr, "Invalid classname\n");
      return( NULL);
   }

   universe = MulleObjCGetUniverse();
   classid  = mulle_objc_classid_from_string( classname);
   infra    = _mulle_objc_universe_lookup_infraclass( universe, classid);
   if( ! infra)
   {
      fprintf( stderr, "Class \"%s\" is unknown to the universe\n", classname);
      return( NULL);
   }

   return( infra);
}


void   MulleObjCHTMLDumpUniverseToDirectory( char *directory)
{
   struct _mulle_objc_universe   *universe;

   universe = MulleObjCGetUniverse();
   mulle_objc_universe_htmldump_to_directory( universe, directory);
}


void   MulleObjCHTMLDumpUniverseToTmp( void)
{
   struct _mulle_objc_universe   *universe;
   char                          *tmp;

   universe = MulleObjCGetUniverse();
   tmp      = _mulle_objc_get_tmpdir();
   mulle_objc_universe_htmldump_to_directory( universe, tmp);
}


void   MulleObjCHTMLDumpUniverse( void)
{
   struct _mulle_objc_universe   *universe;

   universe = MulleObjCGetUniverse();
   mulle_objc_universe_htmldump_to_directory( universe, ".");
}



void   MulleObjCHTMLDumpClassToDirectory( char *classname, char *directory)
{
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_class        *cls;

   infra = infraclass_from_string( classname);
   if( ! infra)
   {
      perror( "class not found:");
      return;
   }

   cls = _mulle_objc_infraclass_as_class( infra);
   mulle_objc_class_htmldump_to_directory( cls, directory);
}


void   MulleObjCHTMLDumpClass( char *classname)
{
   MulleObjCHTMLDumpClassToDirectory( classname, ".");
}


void   MulleObjCHTMLDumpClassToTmp( char *classname)
{
   char   *tmp;

   tmp = _mulle_objc_get_tmpdir();
   MulleObjCHTMLDumpClassToDirectory( classname, tmp);
}


#pragma mark - more conveniences

void   MulleObjCDotdumpUniverseToTmp()
{
   struct _mulle_objc_universe   *universe;
   char                          *tmp;

   universe = MulleObjCGetUniverse();
   tmp      = _mulle_objc_get_tmpdir();
   mulle_objc_universe_dotdump_to_directory( universe, tmp);
}


void   MulleObjCDotdumpClassToDirectory( char *classname, char *directory)
{
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_class        *cls;

   infra = infraclass_from_string( classname);
   if( ! infra)
   {
      perror( "class not found:");
      return;
   }

   cls = _mulle_objc_infraclass_as_class( infra);
   mulle_objc_class_dotdump_to_directory( cls, directory);
}


void   MulleObjCDotdumpClassToTmp( char *classname)
{
   char   *tmp;

   tmp = _mulle_objc_get_tmpdir();
   MulleObjCDotdumpClassToDirectory( classname, tmp);
}


void   MulleObjCDotdumpClass( char *classname)
{
   MulleObjCDotdumpClassToDirectory( classname, ".");
}


void   MulleObjCDotdumpUniverseFrameToTmp( void)
{
   struct _mulle_objc_universe   *universe;
   char                          *tmp;

   universe = MulleObjCGetUniverse();
   tmp      = _mulle_objc_get_tmpdir();
   mulle_objc_universe_dotdump_frame_to_directory( universe, tmp);
}


void   MulleObjCDotdumpUniverse( void)
{
   struct _mulle_objc_universe   *universe;

   universe = MulleObjCGetUniverse();
   mulle_objc_universe_dotdump_to_directory( universe, ".");
}


void   MulleObjCDotdumpInfraHierarchyToDirectory( char *classname, char *directory)
{
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_class        *cls;
   char                            *filename;

   infra = infraclass_from_string( classname);
   if( ! infra)
   {
      perror( "class not found:");
      return;
   }

   cls = _mulle_objc_infraclass_as_class( infra);

   mulle_asprintf( &filename, "%s/%s-infra.dot", directory, classname);
   mulle_objc_classhierarchy_dotdump_to_file( cls, filename);
   mulle_free( filename);
}


void   MulleObjCDotdumpInfraHierarchyToTmp( char *classname)
{
   char   *tmp;

   tmp = _mulle_objc_get_tmpdir();
   MulleObjCDotdumpInfraHierarchyToDirectory( classname, tmp);
}


void   MulleObjCDotdumpInfraHierarchy( char *classname)
{
   MulleObjCDotdumpInfraHierarchyToDirectory( classname, ".");
}


void   MulleObjCDotdumpMetaHierarchyToDirectory( char *classname, char *directory)
{
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_class        *cls;
   char                            *filename;

   infra = infraclass_from_string( classname);
   if( ! infra)
   {
      perror( "class not found:");
      return;
   }

   cls = _mulle_objc_metaclass_as_class( _mulle_objc_infraclass_get_metaclass( infra));
   mulle_asprintf( &filename, "%s/%s-meta.dot", directory, classname);
   mulle_objc_classhierarchy_dotdump_to_file( cls, filename);
   mulle_free( filename);
}


void   MulleObjCDotdumpMetaHierarchyToTmp( char *classname)
{
   char   *tmp;

   tmp = _mulle_objc_get_tmpdir();
   MulleObjCDotdumpMetaHierarchyToDirectory( classname, tmp);
}


void   MulleObjCDotdumpMetaHierarchy( char *classname)
{
   MulleObjCDotdumpMetaHierarchyToDirectory( classname, ".");
}

#else

void   MulleObjCHTMLDumpUniverseToDirectory( char *directory)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCHTMLDumpUniverseToTmp( void)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCHTMLDumpUniverse( void)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}



void   MulleObjCHTMLDumpClassToDirectory( char *classname, char *directory)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCHTMLDumpClass( char *classname)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCHTMLDumpClassToTmp( char *classname)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpUniverseToTmp()
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpClassToDirectory( char *classname, char *directory)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpClassToTmp( char *classname)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpClass( char *classname)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpUniverseFrameToTmp( void)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpUniverse( void)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpInfraHierarchyToDirectory( char *classname, char *directory)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpInfraHierarchyToTmp( char *classname)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpInfraHierarchy( char *classname)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpMetaHierarchyToDirectory( char *classname, char *directory)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpMetaHierarchyToTmp( char *classname)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}


void   MulleObjCDotdumpMetaHierarchy( char *classname)
{
   fprintf( stderr, "%s is only available when MulleObjC is compiled with \
-DMULLE_OBJC_DEBUG_SUPPORT\n", __FUNCTION__);
}

#endif
