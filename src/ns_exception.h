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
   return( &_ns_get_rootconfiguration()->exception.vectors);
}


__attribute__ ((noreturn))
static inline void   MulleObjCThrowAllocationException( size_t bytes)
{
   MulleObjCExceptionHandlersGetTable()->allocation_error( bytes);
}


__attribute__ ((noreturn))
static inline void   MulleObjCThrowInvalidArgumentException( id format, ...)
{
   va_list  args;
   
   va_start( args, format);
   MulleObjCExceptionHandlersGetTable()->invalid_argument( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
static inline void   MulleObjCThrowInvalidIndexException( NSUInteger index)
{
   MulleObjCExceptionHandlersGetTable()->invalid_index( index);
}


__attribute__ ((noreturn))
static inline void   MulleObjCThrowInternalInconsistencyException( id format, ...)
{
   va_list   args;
   
   va_start( args, format);
   MulleObjCExceptionHandlersGetTable()->internal_inconsistency( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
static inline void   MulleObjCThrowInvalidRangeException( NSRange range)
{
   MulleObjCExceptionHandlersGetTable()->invalid_range( range);
}


__attribute__ ((noreturn))
static inline void   MulleObjCThrowErrnoException( char *s)
{
   MulleObjCExceptionHandlersGetTable()->errno_error( s);
}

#endif
