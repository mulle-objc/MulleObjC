#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
{
   char   _mulleNameUTF8String[ 32];
}

@property( dynamic, assign) char   *mulleNameUTF8String  MULLE_OBJC_THREADSAFE_PROPERTY;

@end



@implementation NSInvocation( Squelch)

- (char *) mulleNameUTF8String  MULLE_OBJC_THREADSAFE_PROPERTY
{
   return( "unnamed");
}

@end



@implementation Foo

+ (instancetype) objectWithNameUTF8String:(char *) s
{
   Foo  *obj;

   obj = [Foo alloc];
   obj = [obj init];
   strncpy( obj->_mulleNameUTF8String, s ? s : "", sizeof( obj->_mulleNameUTF8String) - 1);
   obj = [obj autorelease];
   return( obj);
}



- (char *) mulleNameUTF8String
{
   if( ! _mulleNameUTF8String[ 0])
      mulle_snprintf( _mulleNameUTF8String, sizeof( _mulleNameUTF8String), "<Foo %p>", self);
   return( &_mulleNameUTF8String[ 0]);
}


- (void) mulleSetNameUTF8String:(char *) s
{
   strncpy( _mulleNameUTF8String, s ? s : "", sizeof( _mulleNameUTF8String) - 1);
}


@end



static int   test( NSThread *thread, id unused)
{
   Foo  *b;

   [[NSAutoreleasePool mulleDefaultAutoreleasePool] mulleSetNameUTF8String:"thread root"];
   b = [Foo objectWithNameUTF8String:"b"];  // place an object there

   @autoreleasepool
   {
      // place b also here again, twice
      [[b retain] autorelease];
      [[b retain] autorelease];

      [[NSAutoreleasePool mulleDefaultAutoreleasePool] mulleSetNameUTF8String:"thread inner"];
      [Foo objectWithNameUTF8String:"c"];  // place an object there

      // now dump all to standard out
      MulleObjCDumpAutoreleasePoolsToFILEWithOptions( stdout, 0x1);
   }
   return( 0);
}



int  main()
{
   NSThread   *thread;
   Class      cls;

   [[NSAutoreleasePool mulleDefaultAutoreleasePool] mulleSetNameUTF8String:"main root"];
   [Foo objectWithNameUTF8String:"a"];  // place an object there

   cls    = [Foo class];
   thread = [NSThread instantiate];
   thread = [thread mulleInitWithObjectFunction:test
                                         object:nil];
   [thread mulleSetNameUTF8String:"test-thread"];
   [thread mulleStart];
   [thread mulleJoin];

   return( 0);
}
