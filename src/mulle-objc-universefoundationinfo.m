//
//  mulle-objc-foundationinfo.m
//  MulleObjC
//
//  Copyright (c) 2011-2018 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011-2018 Codeon GmbH.
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
#pragma clang diagnostic ignored "-Wparentheses"

#import "import-private.h"

#import "mulle-objc-universefoundationinfo-private.h"


# pragma mark -
# pragma mark root object handling


void   _mulle_objc_universefoundationinfo_add_rootobject( struct _mulle_objc_universefoundationinfo *config,
                                                          void *obj)
{
   assert( mulle_set_get( config->object.placeholders, obj) == NULL);
   assert( mulle_set_get( config->object.roots, obj) == NULL);
   assert( mulle_set_get( config->object.singletons, obj) == NULL);
   assert( mulle_set_get( config->object.threads, obj) == NULL);

   // no constant strings or tagged pointers
   assert( ! _mulle_objc_object_is_constant( obj));

   if( mulle_set_insert( config->object.roots, obj))
      mulle_objc_universe_fail_inconsistency( config->universe, "Object %p is already root", obj);
}


void   _mulle_objc_universefoundationinfo_remove_rootobject( struct _mulle_objc_universefoundationinfo *config,
                                                             void *obj)
{
   assert( mulle_set_get( config->object.roots, obj) != NULL);

   mulle_set_remove( config->object.roots, obj);
}


void   _mulle_objc_universefoundationinfo_release_rootobjects( struct _mulle_objc_universefoundationinfo *config)
{
   struct mulle_setenumerator   rover;
   void                         *obj;

   /* remove all root objects: need to have an enclosing
    * autoreleasepool here
    */
   rover = mulle_set_enumerate( config->object.roots);
   while( obj = mulle_setenumerator_next( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}


# pragma mark -
# pragma mark placeholder storage

void   _mulle_objc_universefoundationinfo_add_placeholder( struct _mulle_objc_universefoundationinfo *config,
                                                           void *obj)
{
   assert( mulle_set_get( config->object.placeholders, obj) == NULL);
   assert( mulle_set_get( config->object.roots, obj) == NULL);
   assert( mulle_set_get( config->object.singletons, obj) == NULL);
   assert( mulle_set_get( config->object.threads, obj) == NULL);

   mulle_set_set( config->object.placeholders, obj);
}


void   _mulle_objc_universefoundationinfo_release_placeholders( struct _mulle_objc_universefoundationinfo *config)
{
   struct mulle_setenumerator   rover;
   void                         *obj;

   /* remove all root objects: need to have an enclosing
    * autoreleasepool here
    */
   rover = mulle_set_enumerate( config->object.placeholders);
   while( obj = mulle_setenumerator_next( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}


# pragma mark -
# pragma mark singleton storage

void   _mulle_objc_universefoundationinfo_add_singleton( struct _mulle_objc_universefoundationinfo *config,
                                                         void *obj)
{
   assert( mulle_set_get( config->object.placeholders, obj) == NULL);
   assert( mulle_set_get( config->object.roots, obj) == NULL);
   assert( mulle_set_get( config->object.singletons, obj) == NULL);
   assert( mulle_set_get( config->object.threads, obj) == NULL);

   mulle_set_set( config->object.singletons, obj);
}


void   _mulle_objc_universefoundationinfo_release_singletons( struct _mulle_objc_universefoundationinfo *config)
{
   struct mulle_setenumerator   rover;
   void                         *obj;

   /* remove all root objects: need to have an enclosing
    * autoreleasepool here
    */
   rover = mulle_set_enumerate( config->object.singletons);
   while( obj = mulle_setenumerator_next( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}


# pragma mark -
# pragma mark thread storage

void   _mulle_objc_universefoundationinfo_add_rootthreadobject( struct _mulle_objc_universefoundationinfo *config,
                                                                void *obj)
{
   assert( mulle_set_get( config->object.placeholders, obj) == NULL);
   assert( mulle_set_get( config->object.roots, obj) == NULL);
   assert( mulle_set_get( config->object.singletons, obj) == NULL);
   assert( mulle_set_get( config->object.threads, obj) == NULL);

   mulle_set_set( config->object.threads, obj);
}


void   _mulle_objc_universefoundationinfo_remove_rootthreadobject( struct _mulle_objc_universefoundationinfo *config,
                                                                   void *obj)
{
   assert( mulle_set_get( config->object.threads, obj) != NULL);

   mulle_set_remove( config->object.threads, obj);
}



# pragma mark -
# pragma mark locking wrapper for above

void  _mulle_objc_universe_lockedcall_universefoundationinfo( struct _mulle_objc_universe *universe,
                                                              void (*f)( struct _mulle_objc_universefoundationinfo *))
{
   // get foundation add to roots
   struct _mulle_objc_universefoundationinfo   *config;

   _mulle_objc_universe_lock( universe);
   {
      config = _mulle_objc_universe_get_foundationdata( universe);
      (*f)( config);
   }
   _mulle_objc_universe_unlock( universe);
}


void  _mulle_objc_universe_lockedcall1_universefoundationinfo( struct _mulle_objc_universe *universe,
                                                               void (*f)( struct _mulle_objc_universefoundationinfo *, void *),
                                                               void *obj)
{
   struct _mulle_objc_universefoundationinfo   *config;

   assert( obj);

   _mulle_objc_universe_lock( universe);
   {
      config = _mulle_objc_universe_get_foundationdata( universe);
      (*f)( config, obj);
   }
   _mulle_objc_universe_unlock( universe);
}


