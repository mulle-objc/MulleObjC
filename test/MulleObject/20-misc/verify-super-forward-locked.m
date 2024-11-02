#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>


@interface A : MulleObject < MulleAutolockingObjectProtocols>
@end


@implementation A

+ (void) test:(id) obj
{
   if( [obj tryLock])
      mulle_printf( "Object should have been locked by a different thread. Iz not. Dis bad!\n");
   else
      mulle_printf( "OK\n");
}


- (void *) forward:(void *) param
{
   NSThread   *thread;

   thread = [[NSThread instantiate] initWithTarget:[A class]
                                          selector:@selector( test:)
                                            object:self];
   [thread mulleStart];
   [thread mulleJoin];
   return( NULL);
}

@end


@interface B : A 

- (void) verify;

@end



@implementation B

- (void) verify
{
   [super verify];
}

@end


int  main( int argc, char *argv[])
{
   B   *b;

   b = [B object];
   [b verify];

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
