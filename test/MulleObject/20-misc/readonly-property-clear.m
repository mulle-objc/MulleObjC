#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>


//
// A readonly 'copy' C string has no setter, so it can only be cleared through
// its ivar. MulleObject's -finalize walks the readonly properties for that
// reason (and does not, to stay compatible with Apple, for a plain NSObject).
//
// A readonly 'retain' object property is cleared the same way. Before, a
// class whose properties were all readonly was not marked as having clearable
// properties, so none of them were cleared at all.
//

@interface Foo : NSObject
@end


@implementation Foo
@end


@interface Bar : MulleObject
{
   Foo    *_foo;
   char   *_cstr;
}

@property( retain, readonly) Foo   *foo;
@property( copy, readonly)   char  *cstr;

@end


@implementation Bar

@synthesize foo  = _foo;
@synthesize cstr = _cstr;


- (id) init
{
   self = [super init];
   if( self)
   {
      _foo = [Foo new];

      // a readonly property is set by the class itself, so use the instance
      // allocator, which is also the one that frees the string again
      _cstr = MulleObjCInstanceDuplicateUTF8String( self, "hello");
   }
   return( self);
}

@end


//
// A '_Nonnull' 'copy' C string has a setter, but no setterclear bit, as a NULL
// can not be passed into it. It must be cleared through its ivar as well.
//
@interface Baz : NSObject
{
   char   *_cstr;
}

@property( copy) char   *_Nonnull cstr;

@end


@implementation Baz

@synthesize cstr = _cstr;

@end


int   main( void)
{
   Bar   *bar;
   Baz   *baz;

   bar = [Bar new];
   mulle_printf( "bar cstr: %s\n", [bar cstr]);
   mulle_printf( "bar foo : %s\n", [bar foo] ? "set" : "NULL");

   [bar finalize];
   mulle_printf( "bar cstr: %s\n", [bar cstr] ? [bar cstr] : "(null)");
   mulle_printf( "bar foo : %s\n", [bar foo] ? "set" : "NULL");
   [bar release];

   baz = [Baz new];
   [baz setCstr:"hello"];
   mulle_printf( "baz cstr: %s\n", [baz cstr]);

   [baz finalize];
   mulle_printf( "baz cstr: %s\n", [baz cstr] ? [baz cstr] : "(null)");
   [baz release];

   return( 0);
}
