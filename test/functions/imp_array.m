#import <MulleObjC/MulleObjC.h>

// Protocol classes
@class P;
@protocol P
@end
@interface P < P>
@end

@class Q;
@protocol Q
@end
@interface Q < Q>
@end

@interface Foo
@end

@interface Foo( X)
@end

@interface Foo( Y)
@end

@interface Bar : Foo < P, Q>
@end

@interface Bar( X)
@end

@interface Bar( Y)
@end

@implementation Foo
+ (id) new
{
   return( (id) _mulle_objc_infraclass_alloc_instance( (struct _mulle_objc_infraclass *) self));
}

+ (Class) class
{
   return( self);
}

- (Class) class
{
   return( _mulle_objc_object_get_infraclass( self));
}

- (void) dealloc
{
   _mulle_objc_instance_free( self);
}

- (void) method
{
   mulle_printf( "Foo:method\n");
}

- (void) init_method
{
   mulle_printf( "Foo:init_method\n");
}

- (void) dealloc_method
{
   mulle_printf( "Foo:dealloc_method\n");
}
@end


@implementation P
- (void) method
{
   mulle_printf( "P:method\n");
}

- (void) init_method
{
   mulle_printf( "P:init_method\n");
}

- (void) dealloc_method
{
   mulle_printf( "P:dealloc_method\n");
}
@end


@implementation Q
- (void) method
{
   mulle_printf( "Q:method\n");
}

- (void) init_method
{
   mulle_printf( "Q:init_method\n");
}

- (void) dealloc_method
{
   mulle_printf( "Q:dealloc_method\n");
}
@end


@implementation Bar
- (void) method
{
   mulle_printf( "Bar:method\n");
}

- (void) init_method
{
   mulle_printf( "Bar:init_method\n");
}

- (void) dealloc_method
{
   mulle_printf( "Bar:dealloc_method\n");
}
@end


@implementation Foo( X)
- (void) method
{
   mulle_printf( "Foo(X):method\n");
}

- (void) init_method
{
   mulle_printf( "Foo(X):init_method\n");
}

- (void) dealloc_method
{
   mulle_printf( "Foo(X):dealloc_method\n");
}
@end


@implementation Foo( Y)
MULLE_OBJC_DEPENDS_ON_CATEGORY( Foo, X);

- (void) method
{
   mulle_printf( "Foo(Y):method\n");
}

- (void) init_method
{
   mulle_printf( "Foo(Y):init_method\n");
}

- (void) dealloc_method
{
   mulle_printf( "Foo(Y):dealloc_method\n");
}
@end


@implementation Bar( X)
- (void) method
{
   mulle_printf( "Bar(X):method\n");
}

- (void) init_method
{
   mulle_printf( "Bar(X):init_method\n");
}

- (void) dealloc_method
{
   mulle_printf( "Bar(X):dealloc_method\n");
}
@end


@implementation Bar( Y)
MULLE_OBJC_DEPENDS_ON_CATEGORY( Bar, X);

- (void) method
{
   mulle_printf( "Bar(Y):method\n");
}

- (void) init_method
{
   mulle_printf( "Bar(Y):init_method\n");
}

- (void) dealloc_method
{
   mulle_printf( "Bar(Y):dealloc_method\n");
}
@end


static void test_imp_array(id obj, SEL sel, Class stopCls, unsigned int flags, char *description)
{
   struct MulleObjCIMPArray   imps;
   unsigned int               count;

   mulle_printf("=== Testing with %s (%s) - %s ===\n",
               MulleObjCObjectGetClassNameUTF8String(obj),
               MulleObjCSelectorUTF8String(sel),
               description);

   // Initialize with the fixed API, including stopCls parameter
   MulleObjCIMPArrayInit(&imps, [obj class], stopCls, sel, flags, NULL);

   // Check array contents
   count = mulle_pointerarray_get_count(&imps.imps);
   mulle_printf("Collected %u IMPs\n", count);

   if (count == 0) {
      mulle_printf("No IMPs collected, skipping call tests\n\n");
      MulleObjCIMPArrayDone(&imps);
      return;
   }

   // Call IMPs in normal order (good for dealloc chain)
   mulle_printf("Calling IMPs in normal order (dealloc style):\n");
   MulleObjCIMPArrayCall(&imps, obj, obj);

   // Call IMPs in reverse order (good for init chain)
   mulle_printf("Calling IMPs in reverse order (init style):\n");
   MulleObjCIMPArrayCallReverse(&imps, obj, obj);

   // Clean up
   MulleObjCIMPArrayDone(&imps);
   mulle_printf("\n");
}


static void test_category_only(id obj, SEL sel, char *description)
{
   struct MulleObjCIMPArray   imps;
   unsigned int               count;

   mulle_printf("=== Testing MulleObjCIMPArrayInitCategoryOnly with %s (%s) - %s ===\n",
               MulleObjCObjectGetClassNameUTF8String(obj),
               MulleObjCSelectorUTF8String(sel),
               description);

   // Use the convenience function for categories only
   MulleObjCIMPArrayInitCategoryOnly(&imps, [obj class], sel, NULL);

   // Check array contents
   count = mulle_pointerarray_get_count(&imps.imps);
   mulle_printf("Collected %u IMPs\n", count);

   if (count == 0) {
      mulle_printf("No IMPs collected, skipping call tests\n\n");
      MulleObjCIMPArrayDone(&imps);
      return;
   }

   // Call IMPs in normal order
   mulle_printf("Calling IMPs in normal order (dealloc style):\n");
   MulleObjCIMPArrayCall(&imps, obj, obj);

   // Call IMPs in reverse order
   mulle_printf("Calling IMPs in reverse order (init style):\n");
   MulleObjCIMPArrayCallReverse(&imps, obj, obj);

   // Clean up
   MulleObjCIMPArrayDone(&imps);
   mulle_printf("\n");
}


int main(void)
{
   Foo *foo;
   Bar *bar;

   foo = [Foo new];
   bar = [Bar new];

   // Define flag constants
   unsigned int categories_only = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
                                | MULLE_OBJC_CLASS_DONT_INHERIT_CLASS
                                | MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS
                                | MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS_INHERITANCE;

   unsigned int with_class = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
                           | MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS
                           | MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS_INHERITANCE;

   // Test full inheritance (no stop class)
   test_imp_array(foo, @selector(method), Nil, 0, "full inheritance");
   test_imp_array(bar, @selector(method), Nil, 0, "full inheritance");

   // Test with flags for categories only
   test_imp_array(foo, @selector(method), Nil, categories_only, "categories only flags");
   test_imp_array(bar, @selector(method), Nil, categories_only, "categories only flags");

   // Test with flags that include the class but not protocols
   test_imp_array(foo, @selector(method), Nil, with_class, "class implementations");
   test_imp_array(bar, @selector(method), Nil, with_class, "class implementations");

   // Test with stop class - only collecting methods up to that class
   test_imp_array(bar, @selector(method), [Foo class], 0, "stop at Foo");

   // Test the convenience function for categories only
   test_category_only(foo, @selector(method), "direct API");
   test_category_only(bar, @selector(method), "direct API");

   // Test init and dealloc methods with different configurations
   test_imp_array(foo, @selector(init_method), Nil, 0, "full inheritance");
   test_imp_array(bar, @selector(dealloc_method), Nil, 0, "full inheritance");

   test_category_only(foo, @selector(init_method), "categories only");
   test_category_only(bar, @selector(dealloc_method), "categories only");

   [foo dealloc];
   [bar dealloc];

   return 0;
}