#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>


@interface A : MulleObject < MulleAutolockingObjectProtocols>

- (void) verify;

@end



@implementation A

+ (void) test:(id) a
{
   if( [a tryLock])
      mulle_printf( "`a` could be locked from a different thread. Dis bad!\n");
   else
      mulle_printf( "OK\n");
}


- (void) verify
{
   NSThread   *thread;

   thread = [[NSThread instantiate] initWithTarget:[A class]
                                          selector:@selector( test:)
                                            object:self];
   [thread mulleStart];
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
