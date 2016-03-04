/*
 *  MulleFoundation - A tiny Foundation replacement
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
#ifndef ns_exception__h__
#define ns_exception__h__

// the "C" interface to NSException
// by default these all just call abort

#include "ns_type.h"
#include "ns_range.h"

#include "ns_rootconfiguration.h"


static inline struct _ns_exceptionhandlertable   *MulleObjCExceptionHandlersGetTable( void)
{
   return( &_ns_rootconfiguration()->exception.vectors);
}



static inline MulleObjCExceptionHandler   *MulleObjCExceptionHandlerWithIndex( unsigned int index)
{
   struct _ns_exceptionhandlertable   *table;
   
   table   = MulleObjCExceptionHandlersGetTable();
   return( table->handlers[ index]);
}



static inline void   __NSThrowAllocationException( size_t bytes)
{
   (*(*MulleObjCExceptionHandlersGetTable)()->handlers[ MulleObjCExceptionAllocationErrorHandlerIndex])( (void *) bytes, NULL);
}


static inline void   __NSThrowInvalidArgumentException( void *format, ...)
{
   va_list  args;
   
   va_start( args, format);
   (*MulleObjCExceptionHandlerWithIndex( MulleObjCExceptionInvalidArgumentHandlerIndex))( format, args);
   va_end( args);
}



// improve this later on
static inline void   __NSThrowInvalidIndexException( NSUInteger i)
{
   (*MulleObjCExceptionHandlerWithIndex( MulleObjCExceptionInvalidIndexHandlerIndex))( (void *) i, NULL);
}



static inline void   __NSThrowInternalInconsistencyException( char *format, ...)
{
   va_list   args;
   
   va_start( args, format);
   (*MulleObjCExceptionHandlerWithIndex( MulleObjCExceptionInternalInconsistencyHandlerIndex))( format, args);
   va_end( args);
}


static inline void   __NSThrowRangeException( NSRange range, ...)
{
   va_list   args;
   
   va_start( args, range);
   (*MulleObjCExceptionHandlerWithIndex( MulleObjCExceptionRangeHandlerIndex))( &range, args);
   va_end( args);
}


static inline void   __NSThrowErrnoException( char *s)
{
   (*MulleObjCExceptionHandlerWithIndex( MulleObjCExceptionErrnoHandlerIndex))( s, NULL);
}


static inline void   __NSThrowMathException( void *sel, ...)
{
   va_list   args;
   
   va_start( args, sel);
   (*MulleObjCExceptionHandlerWithIndex( MulleObjCExceptionMathHandlerIndex))( sel, args);
   va_end( args);
}


static inline void   __NSThrowCharacterConversionException( int c)
{
   (*MulleObjCExceptionHandlerWithIndex( MulleObjCExceptionCharacterConversionHandlerIndex))( (void *) (long) c, NULL);
}

#endif
