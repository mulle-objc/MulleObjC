#import <MulleObjC/MulleObjC.h>


static inline char  *curr_thread_name( void)
{
   NSThread  *thread;
   char      *name;

   thread = MulleThreadGetCurrentThread();
   name   = thread ? [thread mulleNameUTF8String] : "#?";
   return( name ? name : "??");
}


#define __THREAD_NAME__    curr_thread_name()

#ifndef TEST_TRACE_FRAME
# define TEST_TRACE_FRAME  0
#endif

#ifndef TEST_PROTOCOLS
# define TEST_PROTOCOLS
#endif

//
// with -O1 and up this wont hit -retain/-release anymore
// And you can't avoid it with default.CFLAGS because the libraries are
// compiled -O3 or better. So property accessors will not care.
//
#ifndef TRACE_RETAIN_RELEASE
# define TRACE_RETAIN_RELEASE  1
#endif


static void   dump_trace_text( unsigned long nr, char *format, va_list args)
{
   auto char   buf[ 19 + 32 + 4 + 1];
   FILE        *fp;

   mulle_snprintf( buf, sizeof( buf), "NSAutoreleasePools_%06d.txt", nr);
   fp = fopen( buf, "w");
   if( ! fp)
   {
      perror( "fopen:");
      return;
   }

   mulle_vfprintf( fp, format, args);
   fclose( fp);
}


static void   dump_trace_stack( unsigned long nr)
{
   auto char   buf[ 19 + 32 + 4 + 1];
   FILE        *fp;

   mulle_snprintf( buf, sizeof( buf), "NSAutoreleasePools_%06d.trc", nr);
   fp = fopen( buf, "w");
   if( ! fp)
   {
      perror( "fopen:");
      return;
   }

   _mulle_stacktrace( NULL, 3, mulle_stacktrace_csv, fp);

   fclose( fp);
}


static void   test_trace( char *format, ...)
{
   va_list   args;

   va_start( args, format);
   mulle_vprintf( format, args);
   va_end( args);

#if TEST_TRACE_FRAME
   {
      unsigned long   nr;

      nr = MulleObjCDumpAutoreleasePoolsFrame();
      va_start( args, format);
      dump_trace_text( nr, format, args);
      dump_trace_stack( nr);
      va_end( args);
   }
#endif

}



@interface Foo : NSObject  TEST_PROTOCOLS
@end


@implementation Foo

- (MulleObjCTAOStrategy) mulleTAOStrategy MULLE_OBJC_THREADSAFE_METHOD
{
   return( TEST_TAO_STRATEGY);
}


- (void) release
{
#if TRACE_RETAIN_RELEASE
   test_trace( "%s - ->: %s %td -> %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount], [self retainCount] - 1);
#endif
   [super release];
}


- (id) retain
{
   self = [super retain];

#if TRACE_RETAIN_RELEASE
   test_trace( "%s - +<: %s %td -> %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount], [self retainCount] + 1);
#endif
   return( self);
}


- (id) autorelease
{
   self = [super autorelease];
#if TRACE_RETAIN_RELEASE
   test_trace( "%s - a<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
#endif
   return( self);
}



- (void) dealloc
{
   test_trace( "%s - d>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
   [super dealloc];
}


- (void) mulleGainAccess
{
   test_trace( "%s - g>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
   [super mulleGainAccess];
   test_trace( "%s - g<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
}


- (void) mulleRelinquishAccess
{
   test_trace( "%s - q>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
   [super mulleRelinquishAccess];
   test_trace( "%s - q<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
}

@end


static int   thread_function( NSThread *thread, id obj)
{
   test_trace( "%s - 3*: %s %td\n", __THREAD_NAME__, __FUNCTION__, [obj retainCount]);
   return( 0);
}



@implementation NSInvocation( Debug)

- (void) release
{
#if TRACE_RETAIN_RELEASE
   test_trace( "%s - ->: %s %td -> %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount], [self retainCount] - 1);
#endif
   MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);
}


- (id) retain
{
   self = MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);

#if TRACE_RETAIN_RELEASE
   test_trace( "%s - +<: %s %td -> %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount], [self retainCount] + 1);
#endif
   return( self);
}


- (id) autorelease
{
   self = MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);

#if TRACE_RETAIN_RELEASE
   test_trace( "%s - a<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
#endif
   return( self);
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdealloc-in-category"
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"

- (void) dealloc
{
   test_trace( "%s - d>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
   MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);
}
#pragma clang diagnostic pop


- (void) mulleGainAccess
{
   test_trace( "%s - g>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
   MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);
   test_trace( "%s - g<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
}


- (void) mulleRelinquishAccess
{
   test_trace( "%s - q>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
   MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);
   test_trace( "%s - q<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
}

@end



@implementation NSThread( Debug)

- (void) release
{
#if TRACE_RETAIN_RELEASE
   test_trace( "%s - ->: %s %td -> %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [self retainCount], [self retainCount] - 1);
#endif
   MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);
}


- (id) retain
{
   self = MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);

#if TRACE_RETAIN_RELEASE
   test_trace( "%s - +<: %s %td -> %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [self retainCount], [self retainCount] + 1);
#endif
   return( self);
}


- (void) _autoreleaseInvocation
{
#if TRACE_RETAIN_RELEASE
   test_trace( "%s - f>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
#endif
   MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);

   test_trace( "%s - f<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
}


- (void) _releaseInvocation
{
#if TRACE_RETAIN_RELEASE
   test_trace( "%s - f>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
#endif
   MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);

   test_trace( "%s - f<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
}


- (void) finalize
{
#if TRACE_RETAIN_RELEASE
   test_trace( "%s - f>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
#endif
   MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);

   test_trace( "%s - f<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
}



- (id) autorelease
{
   self = MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);

#if TRACE_RETAIN_RELEASE
   test_trace( "%s - a<: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
#endif
   return( self);
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdealloc-in-category"
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"

- (void) dealloc
{
   test_trace( "%s - d>: %s %td\n", __THREAD_NAME__, __FUNCTION__, [self retainCount]);
   MulleObjCIMPCall0( MulleObjCOverriddenIMP, self, _cmd);
}
#pragma clang diagnostic pop


@end

