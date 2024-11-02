#ifdef __MULLE_OBJC__
# import <MulleObjC/MulleObjC.h>
#else
# import <Foundation/Foundation.h>
#endif

#include <assert.h>

// INTERPOSING
//
// You have a class hierarcy Foobar : Bar and you want at runtime to wedge
// another class "Poser" inbetween, effectively turning Foobar : Bar
// into Foobar : Poser (where Poser : Bar)
//
// This works as long a no new classes are loaded (via NSBundle for example)
// You would then have to rerun the interposing code again.
//
#define SQUELCH_ADDRESS


#ifdef SQUELCH_ADDRESS
# define _trace( self)                                                       \
   mulle_printf( "      %s: <%s>\n", __PRETTY_FUNCTION__,                    \
                               MulleObjCObjectGetClassNameUTF8String( self))
#else
# define _trace( self)                                                       \
   mulle_printf( "      %s: <%s %p>\n", __PRETTY_FUNCTION__,                 \
                               MulleObjCObjectGetClassNameUTF8String( self), \
                               self)
#endif

@interface NSObject( Trace)

+ (void) trace;
- (void) trace;

@end

@implementation NSObject( Trace)

+ (void) trace { _trace( self); }
- (void) trace { _trace( self); }

@end

@interface Foo : NSObject
@end


@implementation Foo

+ (void) trace { [super trace]; _trace( self); }
- (void) trace { [super trace]; _trace( self); }

@end


@interface Bar : Foo

@property( assign) int   v1;

@end


@implementation Bar

- (instancetype) init
{
   [super init];
   _v1 = -0x1848;
   return( self);
}


+ (void) trace { [super trace]; _trace( self); }
- (void) trace { assert( _v1 == -0x1848); [super trace]; _trace( self); }

@end



@interface FooBar : Bar

@property( assign) int   v2;

@end


@implementation FooBar

- (instancetype) init
{
   [super init];
   _v2 = 1848;
   return( self);
}

+ (void) trace { [super trace]; _trace( self); }
- (void) trace { assert( _v1 == -0x1848); assert( _v2 == 1848); [super trace]; _trace( self); }

@end


@interface Poser : Bar
@end


@implementation Poser : Bar

+ (void) trace { [super trace]; _trace( self); }
- (void) trace { assert( _v1 == -0x1848); [super trace]; _trace( self); }

@end


static char  *names[ 8] =
{
   "Foo class",
   "Foo instance",
   "Bar class",
   "Bar instance",
   "FooBar class",
   "FooBar instance",
   "Poser class",
   "Poser instance"
};


#define FOO_CLASS_INDEX        0
#define FOO_INSTANCE_INDEX     1
#define BAR_CLASS_INDEX        2
#define BAR_INSTANCE_INDEX     3
#define FOOBAR_CLASS_INDEX     4
#define FOOBAR_INSTANCE_INDEX  5
#define POSER_CLASS_INDEX      6
#define POSER_INSTANCE_INDEX   7


static void   create( id obj[ 8])
{
   obj[ 0] = [Foo class];
   obj[ 1] = [Foo object];
   obj[ 2] = [Bar class];
   obj[ 3] = [Bar object];
   obj[ 4] = [FooBar class];
   obj[ 5] = [FooBar object];
   obj[ 6] = [Poser class];
   obj[ 7] = [Poser object];
}


static void   trace( id obj[ 8])
{
   unsigned int  i;

   for( i = 0; i < 8; i++)
   {
      mulle_printf( "   %s\n", names[ i]);
      [obj[ i] trace];
      mulle_printf( "\n");
   }
}


int   main( int argc, char *argv[])
{
   id   before[ 8];
   id   after[ 8];

   create( before);
   mulle_printf( "before posing objects:\n");
   trace( before);

   [Poser mulleInterposeBeforeClass:[FooBar class]];

   mulle_printf( "after posing same objects:\n");
   trace( before);

   create( after);
   mulle_printf( "after posing new objects:\n");
   trace( after);

   return( 0);
}
