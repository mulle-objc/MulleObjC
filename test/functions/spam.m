#import <MulleObjC/MulleObjC.h>


@interface A
@end

// @protocolclass P
@class P;
@protocol P
@end
@interface P < P>
@end

// @protocolclass Q
@class Q;
@protocol Q
@end
@interface Q < Q>
@end

@interface B : A < P, Q>
@end


@interface A( X)
@end
@interface A( Y)
@end


@interface B( X)
@end
@interface B( Y)
@end


@implementation A
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
- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
- (char *) UTF8String
{
   return( MulleObjCClassGetNameUTF8String( [self class]));
}
@end


@implementation P
- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
@end

@implementation Q
- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
@end

@implementation B
- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
@end
@implementation B( C)
- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
@end


@implementation A( X)
- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
@end
@implementation A( Y)

MULLE_OBJC_DEPENDS_ON_CATEGORY( A, X);

- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
@end

@implementation B( X)
- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
@end
@implementation B( Y)

MULLE_OBJC_DEPENDS_ON_CATEGORY( B, X);

- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
@end



static void   test_spam( id obj,
                         SEL methodsel,
                         unsigned int inheritance,
                         Class cls)
{
   struct MulleObjCCollectionInfo   info;
   mulle_objc_implementation_t      imp;

   mulle_pointerarray_do( imps)
   {
      info = MulleObjCCollectionInfoMake( cls, methodsel, inheritance);
      MulleObjCClassCollectImplementations( [obj class], &info, imps);

      mulle_pointerarray_for( imps, imp)
      {
         mulle_objc_implementation_invoke( imp, obj, methodsel, obj);
      }
      mulle_printf( "\n");
   }

}

#define CATEGORIES_ONLY  MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS \
                         | MULLE_OBJC_CLASS_DONT_INHERIT_CLASS   \
                         | MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS_INHERITANCE


static void   test_spam_object_inheritance_class( id obj, unsigned int inheritance, Class cls)
{
   mulle_printf( "--- obj=%@ inheritance=0x%x class=%s\n",
                           obj,
                           inheritance,
                           MulleObjCClassGetNameUTF8String( cls));
   test_spam( obj, @selector( foo), inheritance, cls);
   mulle_printf( "\n");
}


static void   test_spam_class_inheritance( unsigned int inheritance, Class cls)
{
   A   *a;
   B   *b;

   a = [A new];
   test_spam_object_inheritance_class( a, inheritance, cls);
   [a dealloc];

   b = [B new];
   test_spam_object_inheritance_class( b, inheritance, cls);
   [b dealloc];
}


static void   test_spam_class( Class cls)
{
   test_spam_class_inheritance( 0, cls);
   test_spam_class_inheritance( CATEGORIES_ONLY, cls);
}



int   main()
{
   test_spam_class( Nil);
   test_spam_class( [A class]);
   test_spam_class( [B class]);
   return( 0);
}