#define TEST_TAO_STRATEGY   MulleObjCTAOKnownThreadSafe
#define TEST_PROTOCOLS      < MulleObjCThreadSafe>

#include "TAOStrategyTest.inc"


int   main( int argc, const char * argv[])
{
   NSThread    *thread;
   Foo         *obj;

#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) != mulle_objc_universe_is_ok)
      return( 1);
#endif

   [[NSThread currentThread] mulleSetNameUTF8String:"#1"];

   @autoreleasepool
   {
      obj    = [Foo object];
      mulle_printf( "%s - 1: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [obj retainCount]);

      thread = [NSThread alloc];
      [thread mulleSetNameUTF8String:"#2"];
      thread = [thread mulleInitWithObjectFunction:thread_function
                                            object:obj];
      thread = [thread autorelease];

      mulle_printf( "%s - 2: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [obj retainCount]);
      [thread mulleStart];
      mulle_relativetime_sleep( 0.2); // just get sequencing nicer for test output
      mulle_printf( "%s - 4: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [obj retainCount]);
      [thread mulleJoin];
      mulle_printf( "%s - 5: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [obj retainCount]);
   }
   return( 0);
}
