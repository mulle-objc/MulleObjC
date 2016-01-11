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
#ifndef _ns_exception__h__
#define _ns_exception__h__

typedef void   _NSExceptionHandler( void *, va_list);


enum
{
   _NSExceptionAllocationErrorHandlerIndex = 0,
   _NSExceptionInternalInconsistencyHandlerIndex,
   _NSExceptionInvalidArgumentHandlerIndex,
   _NSExceptionErrnoHandlerIndex,
   _NSExceptionInvalidIndexHandlerIndex,
   _NSExceptionRangeHandlerIndex,
   _NSExceptionMathHandlerIndex,
   _NSExceptionCharacterConversionHandlerIndex,
   _NSExceptionHandlerTableSize
};


struct _ns_exceptionhandlertable 
{
   _NSExceptionHandler   *handlers[ _NSExceptionHandlerTableSize];
};

#endif
