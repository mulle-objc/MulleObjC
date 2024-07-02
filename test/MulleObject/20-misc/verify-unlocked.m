#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>


//
// here verify is declared as threadsafe, so the lock will not be used
// when calling -verify. Ergo another thread should be able to lock
// test:. But test: could be already locked ? No problem it is recursive!
//
@interface A : MulleObject < MulleAutolockingObjectProtocols>

- (void) verify   MULLE_OBJC_THREADSAFE_METHOD;

@end



@implementation A

+ (void) test:(id) a
{
   if( [a tryLock])
   {
      mulle_printf( "OK\n");
      [a unlock];
   }
   else
      mulle_printf( "`a` could not be locked from a different thread. Dis bad!\n");
}


- (void) verify
{
   NSThread   *thread;

   thread = [[NSThread instantiate] initWithTarget:[A class]
                                          selector:@selector( test:)
                                            object:self];
   [thread mulleStartUndetached];
   [thread mulleJoin];
}

@end



int  main( int argc, char *argv[])
{
   A   *a;

   a = [A object];
   [a verify];

   return( 0);
}


/*
 * #### Advertisement ####
 *
 * Check for leaks with mulle-testallocator! Add mulle-testallocator to your
 * project:
 *
 * mulle-sde dependency add --marks all-load,no-singlephase \
 *                          --github mulle-core \
 *                          mulle-testallocator
 *
 * Then build your project again and run your executable with the following
 * environment variables:
 *
 *    MULLE_OBJC_PEDANTIC_EXIT=YES
 *    MULLE_TESTALLOCATOR=YES
 *
 * To easier pin down, where a leak is created. try any of:
 *
 *    MULLE_TESTALLOCATOR_TRACE=3
 *    MULLE_OBJC_TRACE_INSTANCE=YES
 *    MULLE_OBJC_TRACE_METHOD_CALL=YES
 *    MULLE_OBJC_TRACE_UNIVERSE=YES
 *
 * If you are writing singleton code try:
 *
 *    MULLE_OBJC_EPHEMERAL_SINGLETON=YES
 *
 */
