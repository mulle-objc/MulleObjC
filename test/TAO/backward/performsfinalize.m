#define TEST_TAO_STRATEGY   MulleObjCTAOReceiverPerformsFinalize

#include "TAOStrategyTest2.inc"


int   main( int argc, const char * argv[])
{
   NSThread       *thread;
   Foo            *obj;
   NSInvocation   *invocation;

#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) != mulle_objc_universe_is_ok)
      return( 1);
#endif

   [[NSThread currentThread] mulleSetNameUTF8String:"#1"];

   @autoreleasepool
   {
      thread = [NSThread alloc];
      [thread mulleSetNameUTF8String:"#2"];
      thread = [thread initWithTarget:[Receiver class]
                          selector:@selector( foo:)
                          object:nil];
      thread = [thread autorelease];

      mulle_printf( "%s - 1: %s\n", __THREAD_NAME__, __PRETTY_FUNCTION__);
      [thread mulleStart];
      mulle_relativetime_sleep( 0.2); // just get sequencing nicer for test output
      mulle_printf( "%s - 3: %s\n", __THREAD_NAME__, __PRETTY_FUNCTION__);
      invocation = [thread mulleJoin];
      [invocation getReturnValue:&obj];
      mulle_printf( "%s - 4: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [obj retainCount]);
   }
   return( 0);
}
