/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  _NSException.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef ns_exception__h__
#define ns_exception__h__

// the "C" interface to NSException
// by default these all just call abort

#include "ns_type.h"
#include "ns_range.h"

#include "ns_rootconfiguration.h"


static inline struct _ns_exceptionhandlertable   *_NSExceptionHandlersGetTable( void)
{
   return( &_ns_rootconfiguration()->exceptions);
}



static inline _NSExceptionHandler   *_NSExceptionHandlerWithIndex( unsigned int index)
{
   struct _ns_exceptionhandlertable   *table;
   
   table   = _NSExceptionHandlersGetTable();
   return( table->handlers[ index]);
}



static inline void   __NSThrowAllocationException( size_t bytes)
{
   (*(*_NSExceptionHandlersGetTable)()->handlers[ _NSExceptionAllocationErrorHandlerIndex])( (void *) bytes, NULL);
}


static inline void   __NSThrowInvalidArgumentException( void *format, ...)
{
   va_list  args;
   
   va_start( args, format);
   (*_NSExceptionHandlerWithIndex( _NSExceptionInvalidArgumentHandlerIndex))( format, args);
   va_end( args);
}



// improve this later on
static inline void   __NSThrowInvalidIndexException( NSUInteger i)
{
   (*_NSExceptionHandlerWithIndex( _NSExceptionInvalidIndexHandlerIndex))( (void *) i, NULL);
}



static inline void   __NSThrowInternalInconsistencyException( char *format, ...)
{
   va_list   args;
   
   va_start( args, format);
   (*_NSExceptionHandlerWithIndex( _NSExceptionInternalInconsistencyHandlerIndex))( format, args);
   va_end( args);
}


static inline void   __NSThrowRangeException( NSRange range, ...)
{
   va_list   args;
   
   va_start( args, range);
   (*_NSExceptionHandlerWithIndex( _NSExceptionRangeHandlerIndex))( &range, args);
   va_end( args);
}


static inline void   __NSThrowErrnoException( char *s)
{
   (*_NSExceptionHandlerWithIndex( _NSExceptionErrnoHandlerIndex))( s, NULL);
}


static inline void   __NSThrowMathException( void *sel, ...)
{
   va_list   args;
   
   va_start( args, sel);
   (*_NSExceptionHandlerWithIndex( _NSExceptionMathHandlerIndex))( sel, args);
   va_end( args);
}


static inline void   __NSThrowCharacterConversionException( int c)
{
   (*_NSExceptionHandlerWithIndex( _NSExceptionCharacterConversionHandlerIndex))( (void *) (long) c, NULL);
}

#endif
