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
   _NSExceptionCharacterConversionHandlerIndex
};


struct _mulle_objc_exception_handler_table
{
   _NSExceptionHandler   *handlers[ 8];
};
