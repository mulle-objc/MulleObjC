#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>
#import <MulleObjC/NSLock-Private.h>
#import <MulleObjC/NSRecursiveLock-Private.h>


@interface A : MulleObject < MulleAutolockingObjectProtocols>

- (void) x  MULLE_OBJC_THREADSAFE_METHOD;
- (void) y;

@end



@implementation A

- (void) x 
{   
   mulle_printf( "%s: Locking depth %td\n", __FUNCTION__, _MulleObjCRecursiveLockGetLockingDepth( self->__lock));
}


- (void) y
{   
   mulle_printf( "%s: Locking depth %td\n", __FUNCTION__, _MulleObjCRecursiveLockGetLockingDepth( self->__lock));
}

@end



int  main( int argc, char *argv[])
{
   A   *a;

   a = [A instance];
   [a x];
   [a x];

   [a y];
   [a y];

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
