//
//  mulle-objc-foundationinfo-private.h
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
#ifndef mulle_objc_universefoundationinfo_private__h__
#define mulle_objc_universefoundationinfo_private__h__

#include "mulle-objc-exceptionhandlertable-private.h"

// MEMO: not sure anymore why this is private ?


// universe information pertaining to foundation
// this gets filled during mulle_objc_universe_configure from data
// in mulle_objc_foundationsetup

struct _mulle_objc_universefoundationinfo_object
{
   struct mulle_set    *roots;
   // single out thread into their own set
   struct mulle_set    *threads;

   unsigned char       debugenabled;
   unsigned char       zombieenabled;
   unsigned char       deallocatezombies;
};


struct _mulle_objc_universefoundationinfo_thread
{
   void                      *mainthread;  // NSThread object not retained
   mulle_atomic_pointer_t    n_threads;
   char                      was_multi_threaded;
};


struct _mulle_objc_universefoundationinfo_string
{
   void   *(*objectfromchars)( char *s);
   char   *(*charsfromobject)( void *obj);
};


struct _mulle_objc_universefoundationinfo_exception
{
   struct _mulle_objc_exceptionhandlertable   vectors;
};


struct _mulle_objc_universefoundationinfo_autoreleasepool
{
   mulle_thread_tss_t   config_key;
   Class                pool_class;
};


//
// this becomes part of the universe structure..
//
#define _MULLE_OBJC_FOUNDATIONINFO_N_STRINGSUBCLASSES  8
#define _MULLE_OBJC_FOUNDATIONINFO_N_NUMBERSUBCLASSES  8

struct _mulle_objc_universefoundationinfo
{
   struct _mulle_objc_universefoundationinfo_object            object;  // for easy access to allocator keep this up here

   struct _mulle_objc_universefoundationinfo_exception         exception;
   struct _mulle_objc_universefoundationinfo_string            string;
   struct _mulle_objc_universefoundationinfo_thread            thread;
   struct _mulle_objc_universefoundationinfo_autoreleasepool   pool;
   struct _mulle_objc_universe                                 *universe;

   // stuff used by the MulleStandardOSFoundation
   Class   stringsubclasses[ _MULLE_OBJC_FOUNDATIONINFO_N_STRINGSUBCLASSES];
   Class   numbersubclasses[ _MULLE_OBJC_FOUNDATIONINFO_N_NUMBERSUBCLASSES];

   void     (*teardown_callback)( struct _mulle_objc_universe  *universe);
};


MULLE_C_CONST_NON_NULL_RETURN static inline
   struct _mulle_objc_universefoundationinfo *
      _mulle_objc_universe_get_universefoundationinfo( struct _mulle_objc_universe *universe)
{
   return( _mulle_objc_universe_get_foundationdata( universe));
}


static inline int
   _mulle_objc_universe_is_debugenabled( struct _mulle_objc_universe *universe)
{
   // get foundation add to roots
   struct _mulle_objc_universefoundationinfo   *config;
   int                                         flag;

   config = _mulle_objc_universe_get_foundationdata( universe);
   flag   = config->object.debugenabled;

   return( flag);
}


static inline int
   _mulle_objc_universe_is_deallocatingzombies( struct _mulle_objc_universe *universe)
{
   // get foundation add to roots
   struct _mulle_objc_universefoundationinfo   *config;
   int                                         flag;

   config = _mulle_objc_universe_get_foundationdata( universe);
   flag   = config->object.deallocatezombies;

   return( flag);
}


static inline int
   _mulle_objc_universe_is_zombieenabled( struct _mulle_objc_universe *universe)
{
   // get foundation add to roots
   struct _mulle_objc_universefoundationinfo   *config;
   int                                         flag;

   config = _mulle_objc_universe_get_foundationdata( universe);
   flag   = config->object.zombieenabled;

   return( flag);
}


void
   _mulle_objc_universefoundationinfo_init( struct _mulle_objc_universefoundationinfo *info,
                                            struct _mulle_objc_universe *universe,
                                            struct mulle_allocator *allocator,
                                            struct _mulle_objc_exceptionhandlertable *exceptiontable);

void
   _mulle_objc_universefoundationinfo_willfinalize( struct _mulle_objc_universefoundationinfo *info);
void
   _mulle_objc_universefoundationinfo_finalize( struct _mulle_objc_universefoundationinfo *info);

void
   _mulle_objc_universefoundationinfo_done( struct _mulle_objc_universefoundationinfo *info);

//
// There functions are all implicitly "universe" functions.
// These functions do not retain/release.
// Currently these functions use locking, that could change in the future
//
void _mulle_objc_universefoundationinfo_add_rootobject( struct _mulle_objc_universefoundationinfo *config, void *obj);
void _mulle_objc_universefoundationinfo_remove_rootobject(  struct _mulle_objc_universefoundationinfo *config, void *obj);
void _mulle_objc_universefoundationinfo_release_rootobjects(  struct _mulle_objc_universefoundationinfo *config);

void _mulle_objc_universefoundationinfo_add_threadobject( struct _mulle_objc_universefoundationinfo *config, void *obj);
void _mulle_objc_universefoundationinfo_remove_threadobject( struct _mulle_objc_universefoundationinfo *config, void *obj);

void   _mulle_objc_universefoundationinfo_set_mainthreadobject( struct _mulle_objc_universefoundationinfo *info,
                                                                 void *obj);
void   *_mulle_objc_universefoundationinfo_get_mainthreadobject( struct _mulle_objc_universefoundationinfo *info);

void _mulle_objc_universe_lockedcall_universefoundationinfo( struct _mulle_objc_universe *universe,
                                                             void (*f)(struct _mulle_objc_universefoundationinfo *));
void _mulle_objc_universe_lockedcall1_universefoundationinfo( struct _mulle_objc_universe *universe,
                                                              void (*f)(struct _mulle_objc_universefoundationinfo *, void *),
                                                              void *obj);


# pragma mark - root object conveniences

static inline void
	_mulle_objc_universe_add_rootobject( struct _mulle_objc_universe *universe,
													 void *obj)
{
   _mulle_objc_universe_lockedcall1_universefoundationinfo( universe,
   		_mulle_objc_universefoundationinfo_add_rootobject,
   		obj);
}


static inline void
	_mulle_objc_universe_remove_rootobject( struct _mulle_objc_universe *universe,
													    void *obj)
{
   _mulle_objc_universe_lockedcall1_universefoundationinfo( universe,
   		_mulle_objc_universefoundationinfo_remove_rootobject,
   		obj);
}


static inline void
	_mulle_objc_universe_release_rootobjects( struct _mulle_objc_universe *universe)
{
   _mulle_objc_universe_lockedcall_universefoundationinfo( universe,
   		_mulle_objc_universefoundationinfo_release_rootobjects);
}


static inline void
	_mulle_objc_universe_add_threadobject( struct _mulle_objc_universe *universe,
														void *obj)
{
   if( universe->debug.trace.thread)
      mulle_objc_universe_trace( universe, "add threadObject %p", obj);

   _mulle_objc_universe_lockedcall1_universefoundationinfo( universe,
   		_mulle_objc_universefoundationinfo_add_threadobject,
   		obj);
}


static inline void
	_mulle_objc_universe_remove_threadobject( struct _mulle_objc_universe *universe,
															void *obj)
{
   if( universe->debug.trace.thread)
      mulle_objc_universe_trace( universe, "remove threadObject %p", obj);

   _mulle_objc_universe_lockedcall1_universefoundationinfo( universe,
   	 _mulle_objc_universefoundationinfo_remove_threadobject,
   	 obj);
}


static inline struct _mulle_objc_exceptionhandlertable *
   mulle_objc_universe_get_foundationexceptionhandlertable( struct _mulle_objc_universe *universe)
{
   // use proper exceptions, only when not in crunch
   if( ! _mulle_objc_universe_is_initialized( universe))
      return( NULL);
   return( universe ? &_mulle_objc_universe_get_universefoundationinfo( universe)->exception.vectors : NULL);
}


# pragma mark - string conveniences

// foundation can substitute this with a proper type
#ifndef MULLE_OBJC_STRING_CLASS_P
# define MULLE_OBJC_STRING_CLASS_P id
#endif

static inline MULLE_OBJC_STRING_CLASS_P
	_mulle_objc_universe_string( struct _mulle_objc_universe *universe, char *s)
{
   struct _mulle_objc_universefoundationinfo   *config;
   MULLE_OBJC_STRING_CLASS_P                   obj;

   if( ! s)
      return( NULL);

   config = _mulle_objc_universe_get_universefoundationinfo( universe);
   obj    = config->string.objectfromchars( s);
   return( obj);
}


static inline char   *
	_mulle_objc_universe_characters( struct _mulle_objc_universe *universe,
												MULLE_OBJC_STRING_CLASS_P obj)
{
   struct _mulle_objc_universefoundationinfo   *config;

   if( ! obj)
      return( "*nil*");

   config = _mulle_objc_universe_get_universefoundationinfo( universe);
   return( config->string.charsfromobject( obj));
}

#endif
