#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif

struct key_value
{
   char    *key;
   id      value;
   struct
   {
      char  *keys[ 2];
      id    values[ 2];
   } inner;
};


@interface Foo : NSObject
@end


@implementation Foo

- (void) foo:(struct key_value) x
{
   unsigned int  i;

   mulle_printf( "%s %@\n", x.key, x.value);
   for( i = 0; i < 2; i++)
      mulle_printf( "\t%s %@\n", x.inner.keys[ i], x.inner.values[ i]);
}

@end


@interface Value : NSObject

@property char  *UTF8String;

@end


@implementation Value

+ (instancetype) valueWithUTF8String:(char *) s
{
   Value   *obj;

   obj = [self object];
   [obj setUTF8String:s];
   return( obj);
}

@end



int   main( void)
{
   NSInvocation       *invocation;
   Foo                *foo;
   Value              *value;
   struct key_value   x;

   x.key              = strdup( "VfL");
   x.value            = [Value valueWithUTF8String:"Bochum"];
   x.inner.keys[ 0]   = strdup( "1848");
   x.inner.keys[ 1]   = strdup( "Harpener"); // Harpener Heide 2. 44805 Bochum.
   x.inner.values[ 0] = [Value valueWithUTF8String:"Heide"];
   x.inner.values[ 1] = [Value valueWithUTF8String:"2"];

   foo        = [Foo object];
   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                              selector:@selector( foo:), x];
#if 1 // 0 to produce expected result
   [invocation retainArguments];

   // if retain fails, these changes will modify the invocation
   x.key[ 0]            = 'X';
   x.inner.keys[ 0][ 0] = 'X';
   x.inner.keys[ 1][ 0] = 'X';
#endif

   [invocation invoke];

   free( x.key);
   free( x.inner.keys[ 0]);
   free( x.inner.keys[ 1]);

   return( 0);
}


