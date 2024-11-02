#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>


@interface A : MulleObject < MulleAutolockingObjectProtocols>

- (void) verify;

@end


#define testmethod( name)                                                        \
+ (BOOL) name:(id) a                                                             \
{                                                                                \
   if( [a tryLock])                                                              \
   {                                                                             \
      mulle_printf( "`a` could be locked from a different thread. Dis bad!\n");  \
      return( NO);                                                               \
   }                                                                             \
   return( YES);                                                                 \
}



@implementation A

testmethod( test0)
testmethod( test1)
testmethod( test2)
testmethod( test3)
testmethod( test4)
testmethod( test5)
testmethod( test6)
testmethod( test7)
testmethod( test8)
testmethod( test9)
testmethod( test10)
testmethod( test11)
testmethod( test12)
testmethod( test13)
testmethod( test14)
testmethod( test15)


+ (void) test:(id) a
{
   assert( MULLE_OBJC_MIN_CACHE_SIZE < 16);

   if( [self test0:a]
       && [self test1:a]
       && [self test2:a]
       && [self test3:a]
       && [self test4:a]
       && [self test5:a]
       && [self test6:a]
       && [self test7:a]
       && [self test8:a]
       && [self test9:a]
       && [self test10:a]
       && [self test11:a]
       && [self test12:a]
       && [self test13:a]
       && [self test14:a]
       && [self test15:a])
   {
      printf( "OK\n");
   }
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
