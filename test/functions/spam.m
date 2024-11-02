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
- (void) dealloc
{
   _mulle_objc_instance_free( self);
}
- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
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
- (void) foo
{
   mulle_printf( "%s\n", __FUNCTION__);
}
@end



static void   test_spam( id obj,
                         SEL methodsel,
                         Class cls)
{
   MulleObjCObjectSpamAncestorToInheritor( obj, methodsel, obj, cls);
   mulle_printf( "\n");
   MulleObjCObjectSpamInheritorToAncestor( obj, methodsel, obj, cls);
   mulle_printf( "\n");
   mulle_printf( "---\n");
}


int   main()
{
   B   *b;

   b = [B new];

   test_spam( b, @selector( foo), [A class]);

   test_spam( b, @selector( foo), Nil);

   [b dealloc];
}