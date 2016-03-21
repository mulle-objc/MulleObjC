/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSObjectCArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#include "MulleObjCPerform.h"

#include <mulle_objc_runtime/mulle_objc_runtime.h>


void   MulleObjCMakeObjectsPerformSelector( id *objects, unsigned int n, SEL sel, id argument)
{
   mulle_objc_methodimplementation_t    lastSelIMP[ 16];
   struct _mulle_objc_class *lastIsa[ 16];
   struct _mulle_objc_class *          thisIsa;
   unsigned int   i;
   id             p;
   id             *sentinel;
   mulle_objc_methodimplementation_t   (*lookup)( struct _mulle_objc_object *, mulle_objc_methodid_t);
   mulle_objc_methodimplementation_t    imp;
   
   memset( lastIsa, 0, sizeof( lastIsa));
   
   lookup   = _mulle_objc_object_lookup_or_search_methodimplementation_no_forward;
   sentinel = &objects[ n];
   
   while( objects < sentinel)
   {
      p = *objects++;
      assert( p);
      
      // our IMP cacheing thing
      thisIsa = _mulle_objc_object_get_isa( p);
      i       = ((uintptr_t) thisIsa >> 4) & 15;
      
      if( lastIsa[ i] != thisIsa)
      {
         imp = (*lookup)( thisIsa, sel);
         if( ! imp)
            imp = mulle_objc_object_call;
         
         lastIsa[ i]    = thisIsa;
         lastSelIMP[ i] = imp;
      }
      
      (*lastSelIMP[ i])( p, sel, argument);
   }
}


void   MulleObjCMakeObjectsPerformSelector2( id *objects, unsigned int n, SEL sel, id argument, id argument2)
{
   IMP            lastSelIMP[ 16];
   Class          lastIsa[ 16];
   Class          thisIsa;
   unsigned int   i;
   id             p;
   id             *sentinel;
   mulle_objc_methodimplementation_t   (*lookup)( struct _mulle_objc_object *, mulle_objc_methodid_t);
   mulle_objc_methodimplementation_t    imp;
   struct { id a; id b; }  _param = { .a = argument, .b = argument2 };
   
   memset( lastIsa, 0, sizeof( lastIsa));
   
   // assume compiler can do unrolling
   lookup   = _mulle_objc_object_lookup_or_search_methodimplementation_no_forward;
   sentinel = &objects[ n];
   
   while( objects < sentinel)
   {
      p = *objects++;
      assert( p);
      
      // our IMP cacheing thing
      thisIsa = _mulle_objc_object_get_isa( p);
      i       = ((uintptr_t) thisIsa >> 4) & 15;
      
      if( lastIsa[ i] != thisIsa)
      {
         imp = (*lookup)( thisIsa, sel);
         if( ! imp)
            imp = mulle_objc_object_call;
         
         lastIsa[ i]    = thisIsa;
         lastSelIMP[ i] = imp;
      }
      
      (*lastSelIMP[ i])( p, sel, &_param);
   }
}

