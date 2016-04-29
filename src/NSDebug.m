/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSDebug.c is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSDebug.h"

#import "NSObject.h"
#include "ns_type.h"


@interface NSObject ( Future)

- (char *) debugMallocedCString;

@end


@interface NSObject( NSDebug)

- (void) __checkReferenceCount;

@end



@implementation NSObject( NSDebug)

- (void) __checkReferenceCount
{
}

@end


char   *_NSPrintForDebugger( id a)
{
   IMP                         imp;
   char                        *aux;
   char                        *spacer;
   char                        buf[ 256];
   struct _mulle_objc_class    *cls;
   struct _mulle_objc_method   *m;
   
   if( ! a)
      return( strdup( "*nil*"));
   
   m   = 0;
   cls = _mulle_objc_object_get_isa( a);
   if( ! cls)
      return( strdup( "*not an object (anymore ?)*"));
   
   // typical "released" isa values
   if( cls == (void *) (intptr_t) 0xDEADDEADDEADDEAD || // our scribble
       cls == (void *) (intptr_t) 0xAAAAAAAAAAAAAAAA)   // malloc scribble
   {
      sprintf( buf, "<%p dealloced,(%p)>", a, cls);
      return( strdup( buf));  // hmm hmm, what's the interface here anyway ?
   }

   imp = (IMP) _mulle_objc_class_lookup_or_search_methodimplementation_no_forward( cls, @selector( debugDescription));
   if( imp)
   {
      void   *s;
      
      s = (*imp)( a, @selector( debugDescription), NULL);
      return( _ns_characters( s));
   }

   spacer = "";
   aux    = "";
   imp    = (IMP) _mulle_objc_class_lookup_or_search_methodimplementation_no_forward( cls, @selector( description));
   if( imp)
   {
      void   *s;
      
      s = (*imp)( a, @selector( description), NULL);
      if( s)
      {
         aux = _ns_characters( s);
         if( strlen( aux))
            spacer=" ";
      }
   }
  
   sprintf( buf, "<%p %.100s%s%.100s>", a, _mulle_objc_class_get_name( cls), spacer, aux);
   return( strdup( buf));  // hmm hmm, what's the interface here anyway ?
}



@interface _MulleObjCZombie
{
}
@end


@implementation _MulleObjCZombie

static char   zombie_format[] = "A deallocated object %p of %sclass \"%s\" was sent a \"%s\" message\n";

+ (void) initialize
{
#if DEBUG_INITIALIZE
   printf( "+[%s initialize] handled by %s\n", _mulle_objc_class_get_name( self), __PRETTY_FUNCTION__);
#endif
}


- (char *) _originalClassName
{
   return( _mulle_objc_class_get_name( _mulle_objc_object_get_isa( self)) + 11);
}


- (void) forward:(SEL) sel :(void *) _params
{
   int    isMeta;
   
   // possibly bullshit ;)
   isMeta = _mulle_objc_class_is_metaclass( _mulle_objc_object_get_isa( self));
   
   fprintf( stderr, zombie_format, self, isMeta ? "meta" : "", [self _originalClassName], mulle_objc_search_debughashname( sel));
   abort();
}


- (BOOL) respondsToSelector:(SEL) sel
{
   // for po basically
   return( sel == @selector( forward::));
}

@end


#define MULLE_ZOMBIE_HASH              0x057fc0af  // _MulleObjCZombie
#define MULLE_OBJC_LARGE_ZOMBIE_HASH   0xafb92130  // _MulleObjCLargeZombie


@interface _MulleObjCLargeZombie : _MulleObjCZombie
{
   Class   _originalClass;
}
@end



@implementation _MulleObjCLargeZombie

- (char *) _originalClassName
{
   return( _mulle_objc_class_get_name( _originalClass));
}

   
static void   zombifyLargeObject( id obj)
{
   _MulleObjCLargeZombie   *zombie;
   Class            cls;
   
   zombie = obj;
   zombie->_originalClass = _mulle_objc_object_get_isa( obj);

   cls = mulle_objc_unfailing_lookup_class( MULLE_OBJC_CLASSID( MULLE_OBJC_LARGE_ZOMBIE_HASH));
   _mulle_objc_object_set_isa( obj, cls);
}

@end


static void   zombifyObject( id obj)
{
   mulle_objc_classid_t           classid;
   static char                    buf[ 1024];
   struct _mulle_objc_classpair   *pair;
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_class       *super_class;
   struct _mulle_objc_runtime     *runtime;
   
   if( ! obj)
      return;
   
   cls     = _mulle_objc_object_get_isa( obj);
   runtime = _mulle_objc_class_get_runtime( cls);
   
   sprintf( buf, "_MulleObjCZombieOf%.1000s", _mulle_objc_class_get_name( cls));
   
   classid = mulle_objc_classid_from_string( buf);
   cls      = _mulle_objc_runtime_lookup_class( runtime, classid);
   
   if( ! cls)
   {
      super_class = _mulle_objc_runtime_lookup_class( runtime, MULLE_OBJC_CLASSID( MULLE_ZOMBIE_HASH));
      
      pair = mulle_objc_unfailing_new_classpair( classid, buf, sizeof( id), super_class);
      cls  = mulle_objc_classpair_get_class( pair);
      
      mulle_objc_class_unfailing_add_methodlist( cls, NULL);
      mulle_objc_class_unfailing_add_methodlist( _mulle_objc_class_get_metaclass( cls), NULL);
      mulle_objc_runtime_add_class( runtime, cls);
   }
   _mulle_objc_object_set_isa( obj, cls);
}


void   MulleObjCZombifyObject( id obj)
{
   struct _mulle_objc_class    *cls;
   size_t                      size;
   
   cls  = _mulle_objc_object_get_isa( obj);
   size = _mulle_objc_class_get_instance_size( cls);
   if( size >= sizeof( Class)) // sizeof( _MulleObjCLargeZombie)
   {
      zombifyLargeObject( obj);
      return;
   }
      
   zombifyObject( obj);
}

