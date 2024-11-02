#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Bar : NSObject
@end

@implementation Bar

- (void) noReturnNoParam                       { printf( "passed\n");}
- (void) noReturnIntParam:(int) param          { printf( "%s\n", param == 1848 ? "passed" : "failed"); }
- (void) noReturnPointerParam:(void *) param   { printf( "%s\n", param == (void *) 1848 ? "passed" : "failed"); }
- (void) noReturnDoubleParam:(double) param    { printf( "%s\n", param == 1848.0 ? "passed" : "failed"); }
- (void) noReturnStructParam:(NSRange) param   { printf( "%s\n", NSEqualRanges( param, NSRangeMake( 18, 48)) ? "passed" : "failed"); }

- (BOOL) boolReturnNoParam                       { return( YES); }
- (BOOL) boolReturnIntParam:(int) param          { return( param + 1 == 1848); }
- (BOOL) boolReturnPointerParam:(void *) param   { return( (intptr_t) param + 1 == 1848); }
- (BOOL) boolReturnDoubleParam:(double) param    { return( param + 1.0 == 1848.0); }
- (BOOL) boolReturnStructParam:(NSRange) param   { return( param.location == 17 && param.length == 49); }

- (int) intReturnNoParam                       { return( 1848); }
- (int) intReturnIntParam:(int) param          { return( param + 1); }
- (int) intReturnPointerParam:(void *) param   { return( (int) param + 1); }
- (int) intReturnDoubleParam:(double) param    { return( (int) param + 1); }
- (int) intReturnStructParam:(NSRange) param   { return( (int) ((param.location + 1) * 100 + param.length + 1)); }

- (void *) pointerReturnNoParam                      { return( (void *) 1848); }
- (void *) pointerReturnIntParam:(int) param         { return( (void *) (intptr_t) (param + 1)); }
- (void *) pointerReturnPointerParam:(void *) param  { return( (void *) ((char *) param + 1)); }
- (void *) pointerReturnDoubleParam:(double) param   { return( (void *) ((uintptr_t) param + 1)); }
- (void *) pointerReturnStructParam:(NSRange) param  { return( (void *) ((param.location + 1) * 100 + param.length + 1)); }

- (float) floatReturnNoParam                         { return( 1848); }
- (float) floatReturnIntParam:(int) param            { return( param + 1); }
- (float) floatReturnPointerParam:(void *) param     { return( (float) ((uintptr_t) param + 1)); }
- (float) floatReturnDoubleParam:(double) param      { return( param + 1); }
- (float) floatReturnStructParam:(NSRange) param     { return( (float) ((param.location + 1) * 100 + param.length + 1)); }

- (double) doubleReturnNoParam                       { return( 1848); }
- (double) doubleReturnIntParam:(int) param          { return( param + 1); }
- (double) doubleReturnPointerParam:(void *) param   { return( (uintptr_t) param + 1); }
- (double) doubleReturnDoubleParam:(double) param    { return( param + 1); }
- (double) doubleReturnStructParam:(NSRange) param   { return( (double) ((param.location + 1) * 100 + param.length + 1)); }

- (NSRange) structReturnNoParam                      { return( NSRangeMake( 18, 48)); }
- (NSRange) structReturnIntParam:(int) param         { return( NSRangeMake( param + 1, param - 1)); }
- (NSRange) structReturnPointerParam:(void *) param  { return( NSRangeMake( (NSUInteger) param + 1, (NSUInteger) param - 1)); }
- (NSRange) structReturnDoubleParam:(double) param   { return( NSRangeMake( (NSUInteger) param + 1, (NSUInteger) param - 1)); }
- (NSRange) structReturnStructParam:(NSRange) param  { return( NSRangeMake( param.location + 1, param.length - 1)); }

@end


@interface Foo: NSObject

- (void) noReturnNoParam;
- (void) noReturnIntParam:(int) param;
- (void) noReturnPointerParam:(void *) param;
- (void) noReturnDoubleParam:(double) param;
- (void) noReturnStructParam:(NSRange) param;

- (BOOL) boolReturnNoParam;
- (BOOL) boolReturnIntParam:(int) param;
- (BOOL) boolReturnPointerParam:(void *) param;
- (BOOL) boolReturnDoubleParam:(double) param;
- (BOOL) boolReturnStructParam:(NSRange) param;

- (int) intReturnNoParam;
- (int) intReturnIntParam:(int) param;
- (int) intReturnPointerParam:(void *) param;
- (int) intReturnDoubleParam:(double) param;
- (int) intReturnStructParam:(NSRange) param;

- (void *) pointerReturnNoParam;
- (void *) pointerReturnIntParam:(int) param;
- (void *) pointerReturnPointerParam:(void *) param;
- (void *) pointerReturnDoubleParam:(double) param;
- (void *) pointerReturnStructParam:(NSRange) param;

- (float) floatReturnNoParam;
- (float) floatReturnIntParam:(int) param;
- (float) floatReturnPointerParam:(void *) param;
- (float) floatReturnDoubleParam:(double) param;
- (float) floatReturnStructParam:(NSRange) param;

- (double) doubleReturnNoParam;
- (double) doubleReturnIntParam:(int) param;
- (double) doubleReturnPointerParam:(void *) param;
- (double) doubleReturnDoubleParam:(double) param;
- (double) doubleReturnStructParam:(NSRange) param;

- (NSRange) structReturnNoParam;
- (NSRange) structReturnIntParam:(int) param;
- (NSRange) structReturnPointerParam:(void *) param;
- (NSRange) structReturnDoubleParam:(double) param;
- (NSRange) structReturnStructParam:(NSRange) param;

@end

@implementation Foo

- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   return( [Bar instanceMethodSignatureForSelector:sel]);
}

- (void) forwardInvocation:(NSInvocation *) invocation
{
   Bar    *bar;

   bar = [[Bar new] autorelease];
   [invocation invokeWithTarget:bar];
}

@end



static void  test_no_return( void)
{
   Foo   *foo;

   foo = [[Foo new] autorelease];
   [foo noReturnNoParam];
   [foo noReturnIntParam:1848];
   [foo noReturnPointerParam:(void *) 1848];
   [foo noReturnDoubleParam:1848.0];
   [foo noReturnStructParam:NSRangeMake( 18, 48)];
}


static void  test_bool_return( void)
{
   Foo   *foo;

   foo = [[Foo new] autorelease];
   printf( "%d\n", [foo boolReturnNoParam]);
   printf( "%d\n", [foo boolReturnIntParam:1847]);
   printf( "%d\n", [foo boolReturnPointerParam:(void *) 1847]);
   printf( "%d\n", [foo boolReturnDoubleParam:1847.0]);
   printf( "%d\n", [foo boolReturnStructParam:NSRangeMake( 17, 49)]);
}


static void  test_int_return( void)
{
   Foo   *foo;

   foo = [[Foo new] autorelease];
   printf( "%d\n", [foo intReturnNoParam]);
   printf( "%d\n", [foo intReturnIntParam:1847]);
   printf( "%d\n", [foo intReturnPointerParam:(void *) 1847]);
   printf( "%d\n", [foo intReturnDoubleParam:1847.0]);
   printf( "%d\n", [foo intReturnStructParam:NSRangeMake( 17, 47)]);
}


// this is the same as int really
static void  test_pointer_return( void)
{
   Foo   *foo;

   foo = [[Foo new] autorelease];
   printf( "%p\n", [foo pointerReturnNoParam]);
   printf( "%p\n", [foo pointerReturnPointerParam:(void *) 1847]);
}


// this is the same as range really
static void  test_float_return( void)
{
   Foo   *foo;

   foo = [[Foo new] autorelease];

   printf( "%.2f\n", [foo floatReturnNoParam]);
   printf( "%.2f\n", [foo floatReturnPointerParam:(void *) 1847]);
   printf( "%.2f\n", [foo floatReturnStructParam:NSRangeMake( 17, 47)]);
}



// this is the same as float really
static void  test_double_return( void)
{
   Foo   *foo;

   foo = [[Foo new] autorelease];

   printf( "%.2f\n", [foo doubleReturnNoParam]);
   printf( "%.2f\n", [foo doubleReturnPointerParam:(void *) 1847]);
   printf( "%.2f\n", [foo doubleReturnStructParam:NSRangeMake( 17, 47)]);
}


static void  test_struct_return( void)
{
   Foo      *foo;
   NSRange   value;

   foo = [[Foo new] autorelease];

   value = [foo structReturnNoParam];
   printf( "%ld.%ld\n", (long) value.location, (long) value.length);

   value = [foo structReturnStructParam:NSRangeMake( 17, 49)];
   printf( "%ld.%ld\n", (long) value.location, (long) value.length);
}


int   main( void)
{
   test_no_return();
   test_bool_return();
   test_int_return();
   test_pointer_return();
   test_float_return();
   test_double_return();
   test_struct_return();
   return( 0);
}
