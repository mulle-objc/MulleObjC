#import <MulleObjC/MulleObjC.h>
#include <stdio.h>

//
// this test is supposed to prove, that you adorn the function in the
// header or in the implementation to add the threadsafe bit to the
// method descriptor
//
@protocol Color

- (void) red MULLE_OBJC_THREADSAFE_METHOD;

@end


@interface Foo : NSObject

- (void) foo MULLE_OBJC_THREADSAFE_METHOD;
- (void) bar MULLE_OBJC_THREADSAFE_METHOD;
- (void) baz;
- (void) qux;

@end



@implementation Foo

- (void) foo MULLE_OBJC_THREADSAFE_METHOD {}
- (void) bar {}
- (void) baz MULLE_OBJC_THREADSAFE_METHOD {}
- (void) qux {}

@end



@interface Foo( Forward) < Color>

- (void) fooForward MULLE_OBJC_THREADSAFE_METHOD;
- (void) barForward MULLE_OBJC_THREADSAFE_METHOD;
- (void) bazForward;
- (void) quxForward;

@end


@implementation Foo( Forward)

- (void) fooForward MULLE_OBJC_THREADSAFE_METHOD {}
- (void) barForward {}
- (void) bazForward MULLE_OBJC_THREADSAFE_METHOD {}
- (void) quxForward {}

- (void) red {}

@end


static BOOL  isThreadSafe( Class cls, SEL sel)
{
   struct _mulle_objc_searcharguments    args;
   struct _mulle_objc_method             *method;
   struct _mulle_objc_descriptor         *desc;

   args   = mulle_objc_searcharguments_make_default( sel);
   method = mulle_objc_class_search_method( (void *) cls, &args, 0, NULL);
   desc   = _mulle_objc_method_get_descriptor( method);
   return( _mulle_objc_descriptor_is_threadaffine( desc) ? NO : YES);
}


static void  printMethod( Class cls, SEL sel)
{
   printf( "-[%s %s]%s;\n", MulleObjCClassGetNameUTF8String( cls),
                            MulleObjCSelectorGetNameUTF8String( sel),
                            isThreadSafe( cls, sel) ? " MULLE_OBJC_THREADSAFE_METHOD" : "");
}


int   main( int argc, const char * argv[])
{
   Class   cls;

   cls = [Foo class];

   printMethod( cls, @selector( foo));
   printMethod( cls, @selector( bar));
   printMethod( cls, @selector( baz));
   printMethod( cls, @selector( qux));

   printMethod( cls, @selector( fooForward));
   printMethod( cls, @selector( barForward));
   printMethod( cls, @selector( bazForward));
   printMethod( cls, @selector( quxForward));

   printMethod( cls, @selector( red));

   return( 0);
}
