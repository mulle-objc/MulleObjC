#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject

@property( assign) char  *nameUTF8String;
@end


@implementation Foo

+ (id) objectWithNameUTF8String:(char *) s
{
   Foo   *obj;

   obj = [Foo object];
   obj->_nameUTF8String = s;
   return( obj);
}


- (void) finalize
{
   mulle_printf( "%s: %s\n", __FUNCTION__, _nameUTF8String);
   [super finalize];
}


+ (void) method:(id) arg
{
   Foo        *foo = arg;
   Foo        *bar;
   Foo        *before;
   Foo        *after;
   NSThread   *currentThread;

   currentThread = [NSThread currentThread];
   [currentThread mulleAddFinalizer:foo];

   before = [Foo objectWithNameUTF8String:"before"];

   bar = [Foo objectWithNameUTF8String:"bar"];
   [currentThread mulleAddFinalizer:bar];

   // this one is not finalized, but placed into the autoreleasepool
   // before bar, means it will get reaped earlier than "bar"
   // but it has no finalizer
   after = [Foo objectWithNameUTF8String:"after"];
}

@end


int main( void)
{
   Foo   *foo;

   [NSThread mulleSetMainThreadWaitsAtExit:YES];  // ensure

   @autoreleasepool
   {
      foo = [Foo objectWithNameUTF8String:"foo"]; // create an object for leak test

      [NSThread detachNewThreadSelector:@selector( method:)
                               toTarget:[Foo class]
                             withObject:foo];
   }
   return( 0);
}
