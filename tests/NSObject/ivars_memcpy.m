#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
{
   BOOL        _b;
   short       _s;
   int         _i;
   long        _l;   
   long long   _q;   
   id          _obj;   
   char        *_string;
   void        *_pointer;
   NSRange     _range;
}
@end

static char  *s1848 = "1848";

@implementation Foo

- (void) set
{
   _b              = YES;
   _s              = 1847;
   _i              = INT_MIN;
   _l              = LONG_MAX;
   _q              = LLONG_MIN;
   _obj            = (void *) 1848;
   _string         = s1848;
   _pointer        = (void *) 1849;
   _range.location = 1850;
   _range.length   = 100;
}


- (BOOL) verify
{
   return( _b              == YES &&
           _s              == 1847 &&
           _i              == INT_MIN &&
           _l              == LONG_MAX &&
           _q              == LLONG_MIN &&
           _obj            == (void *) 1848 &&
           _string         == s1848 &&
           _pointer        == (void *) 1849 &&
           _range.location == 1850 &&
           _range.length   == 100);
}


- (void) copyFrom:(Foo *) other
{
   _MulleObjCGetIvar( other, @selector( _b),       &_b, sizeof( _b));
   _MulleObjCGetIvar( other, @selector( _s),       &_s, sizeof( _s));
   _MulleObjCGetIvar( other, @selector( _i),       &_i, sizeof( _i));
   _MulleObjCGetIvar( other, @selector( _l),       &_l, sizeof( _l));
   _MulleObjCGetIvar( other, @selector( _q),       &_q, sizeof( _q));
   _MulleObjCGetIvar( other, @selector( _obj),     &_obj, sizeof( _obj));
   _MulleObjCGetIvar( other, @selector( _pointer), &_pointer, sizeof( _pointer));
   _MulleObjCGetIvar( other, @selector( _range),   &_range, sizeof( _range));
   _MulleObjCGetIvar( other, @selector( _string),  &_string, sizeof( _string));
}

- (void) copyTo:(Foo *) other
{
   _MulleObjCSetIvar( other, @selector( _b),       &_b, sizeof( _b));
   _MulleObjCSetIvar( other, @selector( _s),       &_s, sizeof( _s));
   _MulleObjCSetIvar( other, @selector( _i),       &_i, sizeof( _i));
   _MulleObjCSetIvar( other, @selector( _l),       &_l, sizeof( _l));
   _MulleObjCSetIvar( other, @selector( _q),       &_q, sizeof( _q));
   _MulleObjCSetIvar( other, @selector( _obj),     &_obj, sizeof( _obj));
   _MulleObjCSetIvar( other, @selector( _pointer), &_pointer, sizeof( _pointer));
   _MulleObjCSetIvar( other, @selector( _string),  &_string, sizeof( _string));
   _MulleObjCSetIvar( other, @selector( _range),   &_range, sizeof( _range));
}


@end



int   main( void)
{
   Foo   *foo1, *foo2, *foo3;

   foo1 = [Foo new];
   foo2 = [Foo new];
   foo3 = [Foo new];

   [foo1 set];
   [foo1 copyTo:foo2];
   [foo3 copyFrom:foo2];

   if( ! [foo3 verify])
      return( 1);

   [foo3 release];
   [foo2 release];
   [foo1 release];
   printf( "Passed\n");
   return( 0);
}
