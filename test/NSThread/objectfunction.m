#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo

- (char *) UTF8String
{
   return( "Foo");
}

@end

static int   threadFunction( NSThread *thread, id obj)
{
   mulle_printf( "%@\n", obj);
   return( 0);
}


int   main( void)
{
   NSThread   *thread;
   Foo        *obj;

   obj    = [Foo object];

   threadFunction( nil, obj);

   thread = [[NSThread alloc] mulleInitWithObjectFunction:threadFunction
                                                   object:obj];
   [thread mulleStart];
   [thread mulleJoin];
   [thread release];

   threadFunction( nil, obj);

   return( 0);
}
