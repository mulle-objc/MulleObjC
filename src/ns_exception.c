//
//  ns_exception.c
//  MulleObjC
//
//  Created by Nat! on 18.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include "ns_exception.h"


__attribute__ ((noreturn))
void   MulleObjCThrowAllocationException( size_t bytes)
{
   MulleObjCExceptionHandlersGetTable()->allocation_error( bytes);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_allocation_exception( size_t bytes)
{
   MulleObjCExceptionHandlersGetTable()->allocation_error( bytes);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInvalidArgumentException( id format, ...)
{
   va_list  args;
   
   va_start( args, format);
   MulleObjCExceptionHandlersGetTable()->invalid_argument( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_argument_exception( char *format, ...)
{
   va_list  args;
   id       s;
   
   va_start( args, format);
   s = _ns_string( format);
   MulleObjCExceptionHandlersGetTable()->invalid_argument( s, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInvalidIndexException( NSUInteger index)
{
   MulleObjCExceptionHandlersGetTable()->invalid_index( index);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_index_exception( NSUInteger index)
{
   MulleObjCExceptionHandlersGetTable()->invalid_index( index);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInternalInconsistencyException( id format, ...)
{
   va_list   args;
   
   va_start( args, format);
   MulleObjCExceptionHandlersGetTable()->internal_inconsistency( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_internal_inconsistency_exception( char *format, ...)
{
   va_list   args;
   id        s;
   
   va_start( args, format);
   s = _ns_string( format);
   MulleObjCExceptionHandlersGetTable()->internal_inconsistency( s, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInvalidRangeException( NSRange range)
{
   MulleObjCExceptionHandlersGetTable()->invalid_range( range);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_range_exception( NSRange range)
{
   MulleObjCExceptionHandlersGetTable()->invalid_range( range);
}


__attribute__ ((noreturn))
void   MulleObjCThrowErrnoException( id format, ...)
{
   va_list  args;

   va_start( args, format);

   MulleObjCExceptionHandlersGetTable()->errno_error( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   mulle_objc_throw_errno_exception( char *format, ...)
{
   va_list  args;
   id       s;
   
   va_start( args, format);
   s = _ns_string( format);
   MulleObjCExceptionHandlersGetTable()->errno_error( s, args);
   va_end( args);
}


#pragma mark -
#pragma mark Uncaught Exceptions

NSUncaughtExceptionHandler   *NSGetUncaughtExceptionHandler( void)
{
   struct _mulle_objc_runtime      *runtime;
   
   runtime    = mulle_objc_get_runtime();
   return( (NSUncaughtExceptionHandler *) runtime->failures.uncaughtexception);
}


void   NSSetUncaughtExceptionHandler( NSUncaughtExceptionHandler *handler)
{
   struct _mulle_objc_runtime      *runtime;
   
   runtime  = mulle_objc_get_runtime();
   runtime->failures.uncaughtexception = (void (*)()) handler;
}


