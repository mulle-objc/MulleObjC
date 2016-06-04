/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  MulleObjCException.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef _ns_exception__h__
#define _ns_exception__h__

#include "ns_range.h"
#include "ns_type.h"

//
// these exceptions are kinda lazy shortcuts for the foundation
// user code just uses NSException and ignores this
//
struct _ns_exceptionhandlertable 
{
   void (*errno_error)( id format, va_list args)            __attribute__ ((noreturn));
   void (*allocation_error)( size_t bytes)                  __attribute__ ((noreturn));
   void (*internal_inconsistency)( id format, va_list args) __attribute__ ((noreturn));
   void (*invalid_argument)( id format, va_list args)       __attribute__ ((noreturn));
   void (*invalid_index)( NSUInteger i)                     __attribute__ ((noreturn));
   void (*invalid_range)( NSRange range)                    __attribute__ ((noreturn));
};

#endif
