#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
extern void  *_objc_msgForward( id, SEL, ...);
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif


@implementation NSObject ( Category)

// 16 methods make this a bsearch methodlist
- (void) f0 { printf( "-f0\n"); }
- (void) f1 { printf( "-f1\n"); }
- (void) f2 { printf( "-f2\n"); }
- (void) f3 { printf( "-f3\n"); }
- (void) f4 { printf( "-f4\n"); }
- (void) f5 { printf( "-f5\n"); }
- (void) f6 { printf( "-f6\n"); }
- (void) f7 { printf( "-f7\n"); }
- (void) f8 { printf( "-f8\n"); }
- (void) f9 { printf( "-f9\n"); }
- (void) fa { printf( "-fa\n"); }
- (void) fb { printf( "-fb\n"); }
- (void) fc { printf( "-fc\n"); }
- (void) fd { printf( "-fd\n"); }
- (void) fe { printf( "-fe\n"); }
- (void) ff { printf( "-ff\n"); }

@end


@interface Foo : NSObject
@end

@interface Bar : Foo


@end

@implementation Foo

- (void) foobar
{
}

+ (void) foo
{
   printf( "+foo\n");
}

- (void) foo
{
   printf( "-foo\n");
}

@end

@implementation Bar

+ (void) bar
{
   printf( "+bar\n");
}

- (void) bar
{
   printf( "-bar\n");
}

@end

static void   testInstanceMethodForSelector( id self, SEL sel)
{
   IMP   imp;
   id    obj;
   
   imp = [self instanceMethodForSelector:sel];
   if( _mulle_objc_class_is_forwardmethodimplementation( self, imp))
   {
      printf( "forward:\n");
      return;
   }

   assert( imp);
   
   obj = [self new];
   (*imp)( obj, sel, NULL);
   [obj release];
}


static void   testMethodForSelector( id self, SEL sel)
{
   IMP   imp;

   imp = [self methodForSelector:sel];
   if( _mulle_objc_class_is_forwardmethodimplementation( _mulle_objc_object_get_isa( self), imp))
   {
      printf( "forward:\n");
      return;
   }
   (*imp)( self, sel, NULL);
}


static void  test_instance( id self)
{
   testMethodForSelector( self, @selector( foo));
   testMethodForSelector( self, @selector( bar));
   testMethodForSelector( self, @selector( foobar));
   testMethodForSelector( self, @selector( f0));
   testMethodForSelector( self, @selector( f7));
   testMethodForSelector( self, @selector( ff));
}


static void  test_class( Class cls)
{
   id  obj;

   testInstanceMethodForSelector( cls, @selector( foo));
   testInstanceMethodForSelector( cls, @selector( bar));
   testInstanceMethodForSelector( cls, @selector( foobar));
   testInstanceMethodForSelector( cls, @selector( f0));
   testInstanceMethodForSelector( cls, @selector( f7));
   testInstanceMethodForSelector( cls, @selector( ff));

   test_instance( (id) cls);
   obj = [cls new];
   test_instance( obj);
   [obj release];
}


main()
{
   test_class( [NSObject class]);
   test_class( [Foo class]);
   test_class( [Bar class]);
}
