#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif


struct key_value
{
   char   *key;
   char   *value;
};


@interface Foo : NSObject
@end

@implementation Foo

- (void) noReturnNoParam                       { printf( "passed\n");}
- (void) noReturnIntParam:(int) param          { printf( "%s\n", param == 1848 ? "passed" : "failed"); }
- (void) noReturnPointerParam:(void *) param   { printf( "%s\n", param == (void *) 1848 ? "passed" : "failed"); }
- (void) noReturnDoubleParam:(double) param    { printf( "%s\n", param == 1848.0 ? "passed" : "failed"); }
- (void) noReturnStructParam:(NSRange) param   { printf( "%s\n", NSEqualRanges( param, NSRangeMake( 18, 48)) ? "passed" : "failed"); }
- (void) noReturnKVParam:(struct key_value) param
{
   printf( "%s\n", (! strcmp( param.key, "VfL") && ! strcmp( param.value, "Bochum"))
                   ? "passed"
                   : "failed");
}

- (int) intReturnNoParam                       { return( 1848); }
- (int) intReturnIntParam:(int) param          { return( param + 1); }
- (int) intReturnPointerParam:(void *) param   { return( (int) (intptr_t) param + 1); }
- (int) intReturnDoubleParam:(double) param    { return( (int) param + 1); }
- (int) intReturnStructParam:(NSRange) param   { return( (int) ((param.location + 1) * 100 + param.length + 1)); }

- (void *) pointerReturnNoParam                      { return( (void *) 1848); }
- (void *) pointerReturnIntParam:(int) param         { return( (void *) (intptr_t) (param + 1)); }
- (void *) pointerReturnPointerParam:(void *) param  { return( (void *) ((char *) param + 1)); }
- (void *) pointerReturnDoubleParam:(double) param   { return( (void *) ((uintptr_t) param + 1)); }
- (void *) pointerReturnStructParam:(NSRange) param  { return( (void *) ((param.location + 1) * 100 + param.length + 1)); }

- (double) doubleReturnNoParam                       { return( 1848); }
- (double) doubleReturnIntParam:(int) param          { return( param + 1); }
- (double) doubleReturnPointerParam:(void *) param   { return( (uintptr_t) param + 1); }
- (double) doubleReturnDoubleParam:(double) param    { return( param + 1); }
- (double) doubleReturnStructParam:(NSRange) param   { return( (double) ((param.location + 1) * 100 + param.length + 1)); }

- (NSRange) structReturnNoParam                      { return( NSRangeMake( 18, 48)); }
- (NSRange) structReturnIntParam:(int) param         { return( NSRangeMake( param + 1, param - 1)); }
- (NSRange) structReturnPointerParam:(void *) param  { return( NSRangeMake( (NSUInteger) param + 1, (NSUInteger) param - 1)); }
- (NSRange) structReturnDoubleParam:(double) param   { return( NSRangeMake( (NSUInteger) param + 1, (NSUInteger) param - 1)); }
- (NSRange) structReturnStructParam:(NSRange) param  { return( NSRangeMake( param.location + 1, param.location - 1)); }

@end


static void  test_void_param_void_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   [invocation _setMetaABIFrame:NULL];
   [invocation invokeWithTarget:foo];
}



static void  test_int_param_void_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   int                      value;

   foo         = [[Foo new] autorelease];
   signature   = [foo methodSignatureForSelector:sel];
   invocation  = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   // no METAABI param block involved
   value = 1848;
   [invocation setArgument:&value
                   atIndex:2];
   [invocation invokeWithTarget:foo];
}


static void  test_pointer_param_void_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   void                     *value;

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   // no METAABI param block involved
   value = (void *) 1848;
   [invocation setArgument:&value
                   atIndex:2];
   [invocation invokeWithTarget:foo];
}

static void  test_double_param_void_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   mulle_metaabi_union_void_return( struct { double value;})  param;

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   param.p.value = 1848.0;
   [invocation _setMetaABIFrame:&param];
   [invocation invokeWithTarget:foo];
}


static void  test_key_value_param_void_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   mulle_metaabi_union_void_return( struct { struct key_value kv;})  param;

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   param.p.kv.key   = "VfL";
   param.p.kv.value = "Bochum";
   [invocation _setMetaABIFrame:&param];
   [invocation invokeWithTarget:foo];
}


#if 0
static void  test_range_param_void_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   NSRange                  value;

   value = NSRangeMake( 18, 48);

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   [invocation setArgument:&value
                   atIndex:2];
   [invocation invokeWithTarget:foo];
}


static void  test_int_param_int_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   int                      value;

   value = 1847;

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   [invocation setArgument:&value
                   atIndex:2];
   [invocation invokeWithTarget:foo];
   [invocation getReturnValue:&value];

   if( value == 1848)
      printf( "passed\n");
   else
      printf( "failed\n");
}


static void  test_pointer_param_int_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   int                      rval;
   void                     *value;

   value = (void *) 1847;

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   [invocation setArgument:&value
                   atIndex:2];
   [invocation invokeWithTarget:foo];
   [invocation getReturnValue:&rval];

   if( rval == 1848)
      printf( "passed\n");
   else
      printf( "failed\n");
}


static void  test_double_param_int_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   int                      rval;
   double                   value;

   value = 1847.0;

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   [invocation setArgument:&value
                   atIndex:2];
   [invocation invokeWithTarget:foo];
   [invocation getReturnValue:&rval];

   if( rval == 1848)
      printf( "passed\n");
   else
      printf( "failed\n");
}


static void  test_range_param_int_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   int                      rval;
   NSRange                  value;

   value = NSRangeMake( 17, 47);

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   [invocation setArgument:&value
                   atIndex:2];
   [invocation invokeWithTarget:foo];
   [invocation getReturnValue:&rval];

   if( rval == 1848)
      printf( "passed\n");
   else
      printf( "failed\n");
}


static void  test_pointer_param_double_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   double                   rval;
   void                     *value;

   value = (void *) 1847;

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   [invocation setArgument:&value
                   atIndex:2];
   [invocation invokeWithTarget:foo];
   [invocation getReturnValue:&rval];

   if( rval == 1848.0)
      printf( "passed\n");
   else
      printf( "failed\n");
}


static void  test_range_param_double_rval( SEL sel)
{
   NSInvocation             *invocation;
   NSMethodSignature        *signature;
   Foo                      *foo;
   double                   rval;
   NSRange                  value;

   value = NSRangeMake( 17, 47);

   foo        = [[Foo new] autorelease];
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:sel];
   [invocation setArgument:&value
                   atIndex:2];
   [invocation invokeWithTarget:foo];
   [invocation getReturnValue:&rval];

   if( rval == 1848.0)
      printf( "passed\n");
   else
      printf( "failed (%f)\n", rval);
}
#endif


static void  test_no_return()
{
   test_void_param_void_rval( @selector( noReturnNoParam));
   test_int_param_void_rval( @selector( noReturnIntParam:));
   test_pointer_param_void_rval( @selector( noReturnPointerParam:));
   test_double_param_void_rval( @selector( noReturnDoubleParam:));
   test_key_value_param_void_rval( @selector( noReturnKVParam:));
//   test_range_param_void_rval( @selector( noReturnStructParam:));
}

#if 0

static void  test_int_return()
{
   test_void_param_int_rval( @selector( intReturnNoParam));
   test_int_param_int_rval( @selector( intReturnIntParam:));
   test_pointer_param_int_rval( @selector( intReturnPointerParam:));
   test_double_param_int_rval( @selector( intReturnDoubleParam:));
   test_range_param_int_rval( @selector( intReturnStructParam:));
}


// this is the same as int really
static void  test_pointer_return()
{
   test_void_param_pointer_rval( @selector( pointerReturnNoParam));
   // test_struct_param_pointer_rval( @selector( pointerReturnIntParam:));
   // test_struct_param_pointer_rval( @selector( pointerReturnPointerParam:));
   // test_struct_param_pointer_rval( @selector( pointerReturnDoubleParam:));
   // test_struct_param_pointer_rval( @selector( pointerReturnStructParam:));
}


// this is the same as range really
static void  test_double_return()
{
   test_void_param_double_rval( @selector( doubleReturnNoParam));
   // test_int_param_double_rval( @selector( doubleReturnIntParam:));
   test_pointer_param_double_rval( @selector( doubleReturnPointerParam:));
   // test_double_param_double_rval( @selector( doubleReturnDoubleParam:));
   test_range_param_double_rval( @selector( doubleReturnStructParam:));
}



static void  test_struct_return()
{
   test_void_param_range_rval( @selector( structReturnNoParam));
   // test_int_param_range_rval( @selector( structReturnIntParam:));
   // test_pointer_param_range_rval( @selector( structReturnPointerParam:));
   // test_double_param_range_rval( @selector( structReturnDoubleParam:));
   // test_range_param_range_rval( @selector( structReturnStructParam:));
}
#endif


int   main( void)
{
   test_no_return();
#if 0
   test_int_return();
   test_pointer_return();
   test_double_return();
   test_struct_return();
#endif
   return( 0);
}
