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
#ifndef _ns_exception__h__
#define _ns_exception__h__

typedef __attribute__ ((noreturn))  void  MulleObjCExceptionHandler( void *, va_list);


enum
{
   MulleObjCExceptionAllocationErrorHandlerIndex = 0,
   MulleObjCExceptionInternalInconsistencyHandlerIndex,
   MulleObjCExceptionInvalidArgumentHandlerIndex,
   MulleObjCExceptionErrnoHandlerIndex,
   MulleObjCExceptionInvalidIndexHandlerIndex,
   MulleObjCExceptionRangeHandlerIndex,
   MulleObjCExceptionMathHandlerIndex,
   MulleObjCExceptionCharacterConversionHandlerIndex,
   MulleObjCExceptionHandlerTableSize
};


struct _ns_exceptionhandlertable 
{
   MulleObjCExceptionHandler   *handlers[ MulleObjCExceptionHandlerTableSize];
};

#endif
