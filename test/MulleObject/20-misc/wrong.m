#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>


@interface A : MulleObject

- (void) print;

@end

@interface B : A

- (void) print;

@end


@implementation A

- (void) print
{
   mulle_printf( "VfL Bochum");
}

@end


@implementation B

- (void) print
{
   [super print];
   mulle_printf( " %lu\n", 1848L);
}

@end




// TODO: check cache growth

int  main( int argc, char *argv[])
{
   A              *a;
   B              *b;
   Class          aClass;
   BOOL           flag;
   NSInvocation   *invocation;
#if defined( DEBUG) && defined( __MULLE_OBJC__)
   mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__);
#endif
   a = [A object];
   [a print];
   printf("\n");

   b = [B object];
   [b print];

   aClass = [A class];
   flag   = [b isKindOfClass:aClass];
   mulle_printf( "[b isKindOfClass:aClass] : %btd\n", flag);

   flag   = [b mulleIsThreadSafe];
   mulle_printf( "[b mulleIsThreadSafe]    : %btd\n", flag);

   invocation = [NSInvocation mulleInvocationWithTarget:b 
                                               selector:@selector( print)];
   [invocation invoke];

//  MulleObjCHTMLDumpUniverse();
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
