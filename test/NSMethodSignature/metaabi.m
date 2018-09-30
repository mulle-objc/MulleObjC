#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end

@implementation Foo

- (void) noReturnNoParam                       {}
- (void) noReturnIntParam:(int) param          {}
- (void) noReturnPointerParam:(void *) param   {}
- (void) noReturnDoubleParam:(double) param    {}
- (void) noReturnStructParam:(NSRange) param   {}

- (int) intReturnNoParam                       { return( 0); }
- (int) intReturnIntParam:(int) param          { return( 0); }
- (int) intReturnPointerParam:(void *) param   { return( 0); }
- (int) intReturnDoubleParam:(double) param    { return( 0); }
- (int) intReturnStructParam:(NSRange) param   { return( 0); }

- (void *) pointerReturnNoParam                     { return( 0); }
- (void *) pointerReturnIntParam:(int) param        { return( 0); }
- (void *) pointerReturnPointerParam:(void *) param { return( 0); }
- (void *) pointerReturnDoubleParam:(double) param  { return( 0); }
- (void *) pointerReturnStructParam:(NSRange) param  { return( 0); }

- (double) doubleReturnNoParam                      { return( 0); }
- (double) doubleReturnIntParam:(int) param         { return( 0); }
- (double) doubleReturnPointerParam:(void *) param  { return( 0); }
- (double) doubleReturnDoubleParam:(double) param   { return( 0); }
- (double) doubleReturnStructParam:(NSRange) param    { return( 0); }

- (NSRange) structReturnNoParam                      { return( NSMakeRange( 0, 0)); }
- (NSRange) structReturnIntParam:(int) param         { return( NSMakeRange( 0, 0)); }
- (NSRange) structReturnPointerParam:(void *) param  { return( NSMakeRange( 0, 0)); }
- (NSRange) structReturnDoubleParam:(double) param   { return( NSMakeRange( 0, 0)); }
- (NSRange) structReturnStructParam:(NSRange) param  { return( NSMakeRange( 0, 0)); }

@end



static void  test_param( SEL sel, MulleObjCMetaABIType expect)
{
   NSMethodSignature       *signature;
   MulleObjCMetaABIType     type;

   signature = [Foo instanceMethodSignatureForSelector:sel];
   assert( signature);
   type = [signature _methodMetaABIParameterType];
   if( type != expect)
   {
      printf( "%s failed with %d (expect %d)\n", mulle_objc_global_lookup_methodname( 0, sel), type, expect);
      abort();
   }
}


static void  test_void_param( SEL sel)
{
   test_param( sel, MulleObjCMetaABITypeVoid);
}


static void  test_pointer_param( SEL sel)
{
   test_param( sel, MulleObjCMetaABITypeVoidPointer);
}


static void  test_struct_param( SEL sel)
{
   test_param( sel, MulleObjCMetaABITypeParameterBlock);
}


static void  test_rval( SEL sel, MulleObjCMetaABIType expect)
{
   NSMethodSignature       *signature;
   MulleObjCMetaABIType     type;

   signature = [Foo instanceMethodSignatureForSelector:sel];
   assert( signature);
   type = [signature _methodMetaABIReturnType];
   if( type != expect) //  != )
   {
      printf( "%s failed with %d (expect %d)\n",  mulle_objc_global_lookup_methodname( 0, sel), type, expect);
      abort();
   }
}


static void  test_void_rval( SEL sel)
{
   test_rval( sel, MulleObjCMetaABITypeVoid);
}


static void  test_pointer_rval( SEL sel)
{
   test_rval( sel, MulleObjCMetaABITypeVoidPointer);
}


static void  test_struct_rval( SEL sel)
{
   test_rval( sel, MulleObjCMetaABITypeParameterBlock);
}



static void  test_no_return()
{
   test_void_param( @selector( noReturnNoParam));
   test_void_rval( @selector( noReturnNoParam));

   test_pointer_param( @selector( noReturnIntParam:));
   test_void_rval( @selector( noReturnIntParam:));

   test_pointer_param( @selector( noReturnPointerParam:));
   test_void_rval( @selector( noReturnPointerParam:));

   test_struct_param( @selector( noReturnDoubleParam:));
   test_void_rval( @selector( noReturnDoubleParam:));

   test_struct_param( @selector( noReturnStructParam:));
   test_void_rval( @selector( noReturnStructParam:));
}


static void  test_int_return()
{
   test_void_param( @selector( intReturnNoParam));
   test_pointer_rval( @selector( intReturnNoParam));

   test_pointer_param( @selector( intReturnIntParam:));
   test_pointer_rval( @selector( intReturnIntParam:));

   test_pointer_param( @selector( intReturnPointerParam:));
   test_pointer_rval( @selector( intReturnPointerParam:));

   test_struct_param( @selector( intReturnDoubleParam:));
   test_pointer_rval( @selector( intReturnDoubleParam:));

   test_struct_param( @selector( intReturnStructParam:));
   test_pointer_rval( @selector( intReturnStructParam:));
}


static void  test_pointer_return()
{
   test_void_param( @selector( pointerReturnNoParam));
   test_pointer_rval( @selector( pointerReturnNoParam));

   test_pointer_param( @selector( pointerReturnIntParam:));
   test_pointer_rval( @selector( pointerReturnIntParam:));

   test_pointer_param( @selector( pointerReturnPointerParam:));
   test_pointer_rval( @selector( pointerReturnPointerParam:));

   test_struct_param( @selector( pointerReturnDoubleParam:));
   test_pointer_rval( @selector( pointerReturnDoubleParam:));

   test_struct_param( @selector( pointerReturnStructParam:));
   test_pointer_rval( @selector( pointerReturnStructParam:));
}


static void  test_double_return()
{
   test_void_param( @selector( doubleReturnNoParam));
   test_struct_rval( @selector( doubleReturnNoParam));

   test_struct_param( @selector( doubleReturnIntParam:));
   test_struct_rval( @selector( doubleReturnIntParam:));

   test_struct_param( @selector( doubleReturnPointerParam:));
   test_struct_rval( @selector( doubleReturnPointerParam:));

   test_struct_param( @selector( doubleReturnDoubleParam:));
   test_struct_rval( @selector( doubleReturnDoubleParam:));

   test_struct_param( @selector( doubleReturnStructParam:));
   test_struct_rval( @selector( doubleReturnStructParam:));
}



static void  test_struct_return()
{
   test_void_param( @selector( structReturnNoParam));
   test_struct_rval( @selector( structReturnNoParam));

   test_struct_param( @selector( structReturnIntParam:));
   test_struct_rval( @selector( structReturnIntParam:));

   test_struct_param( @selector( structReturnPointerParam:));
   test_struct_rval( @selector( structReturnPointerParam:));

   test_struct_param( @selector( structReturnDoubleParam:));
   test_struct_rval( @selector( structReturnDoubleParam:));

   test_struct_param( @selector( structReturnStructParam:));
   test_struct_rval( @selector( structReturnStructParam:));
}


main()
{
   test_no_return();
   test_int_return();
   test_pointer_return();
   test_double_return();
   test_struct_return();

   return( 0);
}
