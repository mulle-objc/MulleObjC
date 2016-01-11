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
#include "ns_objc_include.h"


@interface NSObject ( Debug)

- (char *) debugMallocedCString;

@end


char   *_NSPrintForDebugger( id a)
{
   IMP                         imp;
   char                        *s;
   char                        buf[ 128];
   struct _mulle_objc_class    *cls;
   struct _mulle_objc_method   *m;
   
   if( ! a)
      return( strdup( "*nil*"));
   
   m   = 0;
   cls = _mulle_objc_object_get_class( a);
   
   imp = (IMP) _mulle_objc_object_get_or_lookup_implementation_no_forward( a, @selector( debugMallocedCString));
   if( imp)
   {
      s = mulle_objc_object_call( a, @selector( debugMallocedCString), NULL);
      return( s);
   }
      
   sprintf( buf, "<%p %.100s>", a, _mulle_objc_object_get_class_name( cls));
   return( strdup( buf));  // hmm hmm, what's the interface here anyway ?
}



@interface _NSZombie
{
}
@end


@implementation _NSZombie

static char   zombie_format[] = "A deallocated object %p of %sclass \"%s\" was sent a \"%s\" message\n";

+ (void) initialize
{
#if DEBUG_INITIALIZE
   printf( "+[%s initialize] handled by %s\n",_NSObjCGetClassName( self), __PRETTY_FUNCTION__);
#endif
}


- (char *) _originalClassName
{
   return( _mulle_objc_object_get_class_name( self) + 11);
}


- (void) forward:(SEL) sel :(void *) _params
{
   int    isMeta;
   
   // possibly bullshit ;)
   isMeta = _mulle_objc_class_is_metaclass( _mulle_objc_object_get_class( self));
   
   fprintf( stderr, zombie_format, self, isMeta ? "meta" : "", [self _originalClassName], "_NSObjCGetSelectorName( sel)");
   abort();
}


- (BOOL) respondsToSelector:(SEL) sel
{
   // for po basically
   return( sel == @selector( forward::));
}

@end


#define _NS_LARGE_ZOMBIE_CLASSID  MULLE_OBJC_CLASSID( 0x10fc739ffc89f239)
#define _NS_ZOMBIE_CLASSID        MULLE_OBJC_CLASSID( 0xdb94f0a3bb1d8018)


@interface _NSLargeZombie : _NSZombie
{
   Class   _originalClass;
}
@end



@implementation _NSLargeZombie

- (char *) _originalClassName
{
   return( _mulle_objc_class_get_name( _originalClass));
}

   
static void   zombifyLargeObject( id obj)
{
   _NSLargeZombie   *zombie;
   Class            cls;
   
   zombie = obj;
   zombie->_originalClass = _mulle_objc_object_get_class( obj);

   cls = mulle_objc_unfailing_lookup_class( _NS_LARGE_ZOMBIE_CLASSID);
   _mulle_objc_object_set_class( obj, cls);
}

@end


static void   zombifyObject( id obj)
{
   mulle_objc_classid_t       classid;
   static char                 buf[ 1024];
   struct _mulle_objc_class    *cls;
   struct _mulle_objc_class    *super_class;
   struct _mulle_objc_runtime  *runtime;
   
   if( ! obj)
      return;
   
   cls     = _mulle_objc_object_get_class( obj);
   runtime = _mulle_objc_class_get_runtime( cls);
   
   sprintf( buf, "_NSZombieOf%.1000s", _mulle_objc_class_get_name( cls));
   
   classid = mulle_objc_classid_from_string( buf);
   cls      = _mulle_objc_runtime_lookup_class( runtime, classid);
   
   if( ! cls)
   {
      super_class = _mulle_objc_runtime_lookup_class( runtime, _NS_ZOMBIE_CLASSID);
      
      cls = mulle_objc_unfailing_new_class_pair( classid, buf, sizeof( id), super_class);
      mulle_objc_class_unfailing_add_methodlist( cls, NULL);
      mulle_objc_class_unfailing_add_methodlist( _mulle_objc_class_get_metaclass( cls), NULL);
      mulle_objc_runtime_add_class( runtime, cls);
   }
   _mulle_objc_object_set_class( obj, cls);
}


void   NSZombifyObject( id obj)
{
   struct _mulle_objc_class    *cls;
   size_t                      size;
   
   cls  = _mulle_objc_object_get_class( obj);
   size = _mulle_objc_class_get_instance_size( cls);
   if( size >= sizeof( Class)) // sizeof( _NSLargeZombie)
   {
      zombifyLargeObject( obj);
      return;
   }
      
   zombifyObject( obj);
}

