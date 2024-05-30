#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>


@interface A : MulleObject < MulleAutolockingObjectProtocols>

- (void) print;

@end



@implementation A

- (void) print
{
   mulle_printf( "VfL Bochum 1848\n");
}

@end


@interface B : A

@property( retain) A  *other;

@end


@implementation B

- (void *) forward:(void *) param
{
   assert( _other); 
   return( mulle_objc_object_call_variable_inline( _other,
                                                   @selector( print),
                                                   param));
}

@end


int  main( int argc, char *argv[])
{
   A              *a;
   B              *b;

   a = [A object];
   b = [B object];
   [b setOther:a];
   [b printOther];

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
