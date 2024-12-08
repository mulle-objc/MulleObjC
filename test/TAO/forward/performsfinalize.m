#define TEST_TAO_STRATEGY   MulleObjCTAOReceiverPerformsFinalize
#define TEST_TRACE_FRAME

#include "TAOStrategyTest.inc"


int   main( int argc, const char * argv[])
{
   NSThread    *thread;
   Foo         *obj;

#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) != mulle_objc_universe_is_ok)
      return( 1);
#endif

   [NSThread mulleSetMainThreadWaitsAtExit:YES];
   [[NSThread currentThread] mulleSetNameUTF8String:"#1"];

   @autoreleasepool
   {
      obj    = [Foo object];
      test_trace( "%s - 1*: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [obj retainCount]);

      thread = [NSThread alloc];
      [thread mulleSetNameUTF8String:"#2"];
      thread = [thread mulleInitWithObjectFunction:thread_function
                                            object:obj];
      thread = [thread autorelease];

      test_trace( "%s - 2*: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [obj retainCount]);
      [thread start];
      mulle_relativetime_sleep( 0.5);  // wait for thread before autoreleasepool clean up for nicer log
      test_trace( "%s - 3*: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [obj retainCount]);
   }
   return( 0);
}
