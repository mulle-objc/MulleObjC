//
//  ns_rootconfiguration.h
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
#ifndef mmulle_objc_universeconfiguration_private__h__
#define mmulle_objc_universeconfiguration_private__h__

#include "mulle-objc-universefoundationinfo-private.h"

#include <stddef.h>

#pragma mark - universe configuration

struct _mulle_objc_universeconfiguration;


struct _mulle_objc_universeconfiguration_defaults
{
   // allocator that the universe uses for allocating classese etc.
   struct mulle_allocator                     *allocator;

   mulle_objc_universefriend_versionassert_t  *versionassert;
   struct _mulle_objc_method                  *forward;
   struct _mulle_objc_infraclass              *staticstringclass;


   void   (*uncaughtexception)( void *exception) MULLE_C_NO_RETURN;

   // this is called for each new _mulle_objc_threadinfo (i.e. per thread init)
   mulle_objc_universefriend_threadinfoinit_t   *threadinfoinitializer;
};


struct _mulle_objc_universeconfiguration_foundation
{
   // you can increase the size of the foundationspace of the universe
   // leave at 0 for ample space (512 bytes usually)
   size_t                                       configurationsize;

   // use a different allocator to create instances than what the universe
   // is using for its internals
   struct mulle_allocator                       *objectallocator;

   // the exception table to install
   struct _mulle_objc_exceptionhandlertable     exceptiontable;

   // Extend the header area ahead of an instance
   size_t                                       headerextrasize;
};


struct _mulle_objc_universeconfiguration_callbacks
{
   void  (*setup)( struct _mulle_objc_universeconfiguration *config,
                   struct _mulle_objc_universe *universe);
   void  (*postcreate)( struct _mulle_objc_universe *universe);
   void  (*teardown)( struct _mulle_objc_universe *universe);
};


struct _mulle_objc_universeconfiguration
{
   struct _mulle_objc_universeconfiguration_defaults     universe;
   struct _mulle_objc_universeconfiguration_foundation   foundation;
   struct _mulle_objc_universeconfiguration_callbacks    callbacks;
};


struct _mulle_objc_universefoundationinfo   *
   _mulle_objc_universeconfiguration_configure_universe( struct _mulle_objc_universeconfiguration *config,
                                                         struct _mulle_objc_universe *universe);
//
// This gets the configuration struct that will get passed to
// mulle_objc_universe_setup during __register_mulle_objc_universe, whic
// is defined in "MulleObjC-startup", the startup library.

const struct _mulle_objc_universeconfiguration   *
   mulle_objc_global_get_default_universeconfiguration( void);

//
// use this in standalone in get_or_create_universe
// setup will be modified by mulle_objc_universe_setup
//
void   mulle_objc_universe_configure( struct _mulle_objc_universe *universe,
                                      struct _mulle_objc_universeconfiguration *setup);

void   mulle_objc_postcreate_universe( struct _mulle_objc_universe  *universe);
void   mulle_objc_teardown_universe( struct _mulle_objc_universe *universe);

#endif
