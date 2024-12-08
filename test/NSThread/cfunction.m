#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


static int   threadFunction( NSThread *thread, void *text)
{
   mulle_printf( "%s\n", text);
   return( 0);
}


int   main( void)
{
   NSThread   *thread;

   threadFunction( nil, "a");

   thread = [[NSThread alloc] mulleInitWithFunction:threadFunction
                                           argument:"b"];
   [thread mulleStart];
   [thread mulleJoin];
   [thread release];

   threadFunction( nil, "c");

   return( 0);
}
