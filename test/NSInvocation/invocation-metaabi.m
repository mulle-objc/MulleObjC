#import <MulleObjC/MulleObjC.h>
#include <stdio.h>

// Tests @invocation syntax across all MetaABI types and forms.
// rType: VoidPointer(0)=id/ptr/scalar, Void(1)=void, ParameterBlock(2)=struct/double
// pType: VoidPointer(0)=single ptr arg, Void(1)=no args, ParameterBlock(2)=multi args

struct Point { int x; int y; };

@interface Foo : NSObject
{
   int _x;
   int _y;
}
// rType=1 (void), pType=1 (no args)
- (void) printHello;
// rType=0 (id), pType=0 (single id arg)
- (id) identity:(id) obj;
// rType=0 (int fits void*), pType=2 (multi args)
- (int) add:(int) a to:(int) b;
// rType=2 (double), pType=2 (multi args)
- (double) sumDouble:(double) x andDouble:(double) y;
// rType=1 (void), pType=2 (multi args)
- (void) setX:(int) x y:(int) y;
// rType=0 (char*), pType=1 (no args)
- (char *) greeting;
// rType=0 (float promoted to void*), pType=1 (no args)
- (float) pi;
// rType=2 (struct), pType=1 (no args)
- (struct Point) origin;
// rType=2 (struct), pType=2 (multi args)
- (struct Point) makeX:(int) x y:(int) y;
// rType=0 (char), pType=0 (single id arg)
- (char) firstChar:(id) str;
@end

@implementation Foo

- (void) printHello                              { printf( "hello\n"); }
- (id) identity:(id) obj                         { return( obj); }
- (int) add:(int) a to:(int) b                   { return( a + b); }
- (double) sumDouble:(double) x andDouble:(double) y { return( x + y); }
- (void) setX:(int) x y:(int) y                  { _x = x; _y = y; printf( "x=%d y=%d\n", _x, _y); }
- (char *) greeting                              { return( "hi"); }
- (float) pi                                     { return( 3.14f); }
- (struct Point) origin                          { struct Point p = {0, 0}; return( p); }
- (struct Point) makeX:(int) x y:(int) y         { struct Point p = {x, y}; return( p); }
- (char) firstChar:(id) str                      { return( 'A'); }

@end


int   main( void)
{
   Foo *foo = [Foo new];

   // --- prototype form ---

   // void/void
   NSInvocation *inv = @invocation( foo, - (void) printHello);
   printf( "void/void: %s\n", inv ? "ok" : "null");
   [inv invoke];

   // id/id
   inv = @invocation( foo, - (id) identity:(id) obj, foo);
   printf( "id/id: %s\n", inv ? "ok" : "null");
   [inv invoke];
   id r_id = nil;
   [inv getReturnValue:&r_id];
   printf( "identity: %s\n", r_id == foo ? "ok" : "wrong");

   // int/multi
   inv = @invocation( foo, - (int) add:(int) a to:(int) b, 3, 4);
   printf( "int/multi: %s\n", inv ? "ok" : "null");
   [inv invoke];
   int r_int = 0;
   [inv getReturnValue:&r_int];
   printf( "add: %d\n", r_int);

   // double/multi
   inv = @invocation( foo, - (double) sumDouble:(double) x andDouble:(double) y, 1.5, 2.5);
   printf( "double/multi: %s\n", inv ? "ok" : "null");
   [inv invoke];
   double r_double = 0.0;
   [inv getReturnValue:&r_double];
   printf( "sum: %.1f\n", r_double);

   // void/multi
   inv = @invocation( foo, - (void) setX:(int) x y:(int) y, 42, 99);
   printf( "void/multi: %s\n", inv ? "ok" : "null");
   [inv invoke];

   // char*/void
   inv = @invocation( foo, - (char *) greeting);
   printf( "charptr/void: %s\n", inv ? "ok" : "null");
   [inv invoke];
   char *r_str = NULL;
   [inv getReturnValue:&r_str];
   printf( "greeting: %s\n", r_str ? r_str : "null");

   // float/void
   inv = @invocation( foo, - (float) pi);
   printf( "float/void: %s\n", inv ? "ok" : "null");
   [inv invoke];
   float r_float = 0.0f;
   [inv getReturnValue:&r_float];
   printf( "pi: %.2f\n", r_float);

   // struct/void
   inv = @invocation( foo, - (struct Point) origin);
   printf( "struct/void: %s\n", inv ? "ok" : "null");
   [inv invoke];
   struct Point r_pt = {-1, -1};
   [inv getReturnValue:&r_pt];
   printf( "origin: %d,%d\n", r_pt.x, r_pt.y);

   // struct/multi
   inv = @invocation( foo, - (struct Point) makeX:(int) x y:(int) y, 7, 8);
   printf( "struct/multi: %s\n", inv ? "ok" : "null");
   [inv invoke];
   struct Point r_pt2 = {-1, -1};
   [inv getReturnValue:&r_pt2];
   printf( "point: %d,%d\n", r_pt2.x, r_pt2.y);

   // --- explicit static form ---
   inv = @invocation( foo,
       @selector( add:to:),
       @signature( - (int) add:(int) a to:(int) b),
       10, 20);
   printf( "explicit static: %s\n", inv ? "ok" : "null");
   [inv invoke];
   r_int = 0;
   [inv getReturnValue:&r_int];
   printf( "add: %d\n", r_int);

   // --- dynamic form ---
   SEL sel = @selector( add:to:);
   NSMethodSignature *sig = nil;
   inv = @invocation( foo, sel, sig, 5, 6);
   printf( "dynamic nil-sig: %s\n", inv ? "ok" : "null");
   [inv invoke];
   r_int = 0;
   [inv getReturnValue:&r_int];
   printf( "add: %d\n", r_int);

   // --- nil cases ---
   inv = @invocation( nil, - (int) add:(int) a to:(int) b, 1, 2);
   printf( "nil target: %s\n", inv ? "ok" : "null");

   SEL nilsel = (SEL) 0;
   inv = @invocation( foo, nilsel, nil);
   printf( "nil sel: %s\n", inv ? "ok" : "null");

   [foo release];
   return( 0);
}
