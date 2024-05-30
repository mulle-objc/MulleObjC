#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>



@interface Foo : MulleObject < MulleAutolockingObjectProtocols>
@end



@implementation Foo

- (NSRecursiveLock *) sharedLock
{
   return( __lock);
}

@end



// TODO: check cache growth

int  main( int argc, char *argv[])
{
   Foo   *a, *b, *c, *d;

   a = [Foo object];
   b = [Foo object];
   c = [Foo object];
   d = [Foo object];

   [b shareLockOfObject:a];
   [c shareLockOfObject:b];
   [d shareLockOfObject:b];

   if( [a sharedLock] != [b sharedLock] ||
       [b sharedLock] != [c sharedLock] ||
       [c sharedLock] != [d sharedLock])
   {
      mulle_printf( "a: %p\n", [a sharedLock]);
      mulle_printf( "b: %p\n", [b sharedLock]);
      mulle_printf( "c: %p\n", [c sharedLock]);
      mulle_printf( "d: %p\n", [d sharedLock]);
      return( 1);
   }

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
