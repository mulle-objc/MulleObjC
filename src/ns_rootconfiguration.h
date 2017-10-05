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
#ifndef ns_rootconfiguration__h__
#define ns_rootconfiguration__h__


#define MULLE_OBJC_VERSION    ((0 << 20) | (12 << 8) | 1)


#include "ns_objc_include.h"
#include "ns_objc_type.h"
#include "ns_int_type.h"
#include "_ns_exception.h"


#pragma mark - per thread universe configuration

struct _ns_objectconfiguration
{
   struct mulle_set         *roots;

   // single out some known classes into their own sets
   struct mulle_set         *placeholders;
   struct mulle_set         *singletons;
   struct mulle_set         *threads;

   unsigned char            debugenabled;
   unsigned char            zombieenabled;
   unsigned char            deallocatezombies;
   unsigned char            unused;
};


struct _ns_threadconfiguration
{
   volatile BOOL             is_multi_threaded;
   mulle_atomic_pointer_t    n_threads;
};


struct _ns_stringconfiguration
{
   void   *(*objectfromchars)( char *s);
   char   *(*charsfromobject)( void *obj);
};


struct _ns_exceptionconfiguration
{
   struct _ns_exceptionhandlertable   vectors;
};


struct _ns_autoreleasepool
{
   mulle_thread_tss_t   config_key;
   Class                pool_class;
};


//
// rename this to foundationconfiguration or so...
// this is part of the universe structure..
//
#define _NS_ROOTCONFIGURATION_N_STRINGSUBCLASSES  8
#define _NS_ROOTCONFIGURATION_N_NUMBERSUBCLASSES  8

struct _ns_rootconfiguration
{
   struct _ns_objectconfiguration     object;  // for easy access to allocator keep this up here

   struct _ns_exceptionconfiguration  exception;
   struct _ns_stringconfiguration     string;
   struct _ns_threadconfiguration     thread;
   struct _ns_autoreleasepool         pool;
   struct _mulle_objc_universe        *universe;

   // stuff used by the MulleStandardOSFoundation
   Class   stringsubclasses[ _NS_ROOTCONFIGURATION_N_STRINGSUBCLASSES];
   Class   numbersubclasses[ _NS_ROOTCONFIGURATION_N_NUMBERSUBCLASSES];
};


#pragma mark - inital config setup

struct _ns_root_universeconfig
{
   struct mulle_allocator                     *allocator;
   mulle_objc_universefriend_versionassert_t   *versionassert;
   struct _mulle_objc_method                  *forward;
   void                                       (*uncaughtexception)( void *exception) MULLE_C_NO_RETURN;
};


struct _ns_root_foundationconfig
{
   size_t                             configurationsize;
   struct mulle_allocator             *objectallocator;
   struct _ns_exceptionhandlertable   exceptiontable;
};


struct _ns_setup_callbacks
{
   void  (*setup)( struct _mulle_objc_universe *universe, void *config);
   void  (*tear_down)( void);
   void  (*post_create)( struct _mulle_objc_universe *universe);
};


struct _ns_root_setupconfig
{
   struct _ns_root_universeconfig     universe;
   struct _ns_root_foundationconfig   foundation;
   struct _ns_setup_callbacks         callbacks;
};


struct _ns_rootconfiguration   *__mulle_objc_root_setup( struct _mulle_objc_universe *universe,
                                                         struct _ns_root_setupconfig *config);

// this also sets up exception vectors
void   _ns_root_setup( struct _mulle_objc_universe *universe,
                       struct _ns_root_setupconfig *config);

__attribute__((const, returns_nonnull))  // always returns same value (in same thread)
static inline struct _ns_rootconfiguration   *_ns_get_rootconfiguration( void)
{
   struct _mulle_objc_universe     *universe;

   universe = mulle_objc_inlined_get_universe();
   return( _mulle_objc_universe_get_foundationdata( universe));
}


//
// check how much faster this is in thread local configuration
// so far unused!
//
__attribute__((const, returns_nonnull))  // always returns same value (in same thread)
static inline struct _ns_rootconfiguration   *_ns_object_get_rootconfiguration( void *obj)
{
   struct _mulle_objc_universe     *universe;

   universe = _mulle_objc_object_get_universe( obj);
   return( _mulle_objc_universe_get_foundationdata( universe));
}



// these functions do not retain/release
// currently these functions use locking, that could change in the future
//
void   _ns_rootconfiguration_add_root( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_remove_root( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_release_roots( struct _ns_rootconfiguration *config);

void   _ns_rootconfiguration_add_placeholder( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_release_placeholders( struct _ns_rootconfiguration *config);

void   _ns_rootconfiguration_add_singleton( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_release_singletons( struct _ns_rootconfiguration *config);

void   _ns_rootconfiguration_add_thread( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_remove_thread( struct _ns_rootconfiguration *config, void *obj);


void  _ns_rootconfiguration_locked_call( void (*f)( struct _ns_rootconfiguration*));
void  _ns_rootconfiguration_locked_call1( void (*f)( struct _ns_rootconfiguration*, void *),
                                          void *obj);

int   _ns_rootconfiguration_is_debug_enabled( void);

# pragma mark - root object conveniences

static inline void  _ns_add_root( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_add_root, obj);
}

static inline void  _ns_remove_root( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_remove_root, obj);
}

static inline void  _ns_release_roots( void)
{
   _ns_rootconfiguration_locked_call( _ns_rootconfiguration_release_roots);
}


static inline void  _ns_add_placeholder( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_add_placeholder, obj);
}

static inline void  _ns_release_placeholders( void)
{
   _ns_rootconfiguration_locked_call( _ns_rootconfiguration_release_placeholders);
}


static inline void  _ns_add_singleton( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_add_singleton, obj);
}

static inline void  _ns_release_singletons( void)
{
   _ns_rootconfiguration_locked_call( _ns_rootconfiguration_release_singletons);
}


static inline void  _ns_add_thread( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_add_thread, obj);
}

static inline void  _ns_remove_thread( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_remove_thread, obj);
}


static inline struct _ns_exceptionhandlertable   *_ns_get_exceptionhandlertable( void)
{
   return( &_ns_get_rootconfiguration()->exception.vectors);
}


# pragma mark - string conveniences

// foundation can substitute this with a proper type
#ifndef MULLE_OBJC_STRING_CLASS_P
# define MULLE_OBJC_STRING_CLASS_P id
#endif

static inline MULLE_OBJC_STRING_CLASS_P   _ns_string( char *s)
{
   struct _ns_rootconfiguration   *config;

   if( ! s)
      return( NULL);

   config = _ns_get_rootconfiguration();
   return( config->string.objectfromchars( s));
}


static inline char   *_ns_characters( MULLE_OBJC_STRING_CLASS_P obj)
{
   struct _ns_rootconfiguration   *config;

   if( ! obj)
      return( "*nil*");

   config = _ns_get_rootconfiguration();
   return( config->string.charsfromobject( obj));
}

#endif
