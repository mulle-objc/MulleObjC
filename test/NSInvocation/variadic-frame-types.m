//
// variadic-frame-types.m
//
// NSInvocationCreateWithMetaABIFrameAndLength lets the caller own the
// parameter block. The block is promoted where the compiler would promote,
// and natural for the named parameters. This test pushes every type class
// through that entry point, with varying cardinality, so that the layout
// assumptions are pinned down.
//
// The promoted rules, as the mulle-vararg reader implements them:
//
//   char, short, int, int32, unsigned char/short/int, uint32
//      -> int slot, 4 bytes, alignof( int)
//   long, long long, int64, uint64, unsigned long/long long
//      -> 8 bytes, alignof( long)
//   float, double -> double slot, 8 bytes, alignof( double)
//   pointers, function pointers -> 8 bytes, alignof( void *)
//   structs -> natural size and alignment
//
// Named parameters keep their natural layout, so a named parameter that
// would promote differently (float, char, short) is a special case: its
// variadic tail starts after the promoted slot, not after its natural size.
//
#import <MulleObjC/MulleObjC.h>

#include <mulle-vararg/mulle-vararg-builder.h>


struct XY
{
   int      a;
   double   b;
};


static int   calls;


static void   bump( void)
{
   ++calls;
}


@interface Foo : NSObject
@end


@implementation Foo

//
// vary cardinality from a single type: the first named parameter is an int
// and is also the count, so 0, 1, 2 or n arguments can be pushed
//
- (void) chars:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%d\n", (int) mulle_vararg_next_char( args));
   mulle_vararg_end( args);
}


- (void) shorts:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%d\n", (int) mulle_vararg_next_short( args));
   mulle_vararg_end( args);
}


- (void) ints:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%d\n", mulle_vararg_next_int( args));
   mulle_vararg_end( args);
}


- (void) unsignedchars:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%u\n", (unsigned int) mulle_vararg_next_unsignedchar( args));
   mulle_vararg_end( args);
}


- (void) unsignedshorts:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%u\n", (unsigned int) mulle_vararg_next_unsignedshort( args));
   mulle_vararg_end( args);
}


- (void) unsignedints:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%u\n", mulle_vararg_next_unsignedint( args));
   mulle_vararg_end( args);
}


- (void) longs:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%ld\n", mulle_vararg_next_long( args));
   mulle_vararg_end( args);
}


- (void) unsignedlongs:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%lu\n", mulle_vararg_next_unsignedlong( args));
   mulle_vararg_end( args);
}


- (void) longlongs:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%lld\n", mulle_vararg_next_longlong( args));
   mulle_vararg_end( args);
}


- (void) unsignedlonglongs:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%llu\n", mulle_vararg_next_unsignedlonglong( args));
   mulle_vararg_end( args);
}


- (void) int32s:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%lld\n", (long long) mulle_vararg_next_int32( args));
   mulle_vararg_end( args);
}


- (void) int64s:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%lld\n", (long long) mulle_vararg_next_int64( args));
   mulle_vararg_end( args);
}


- (void) uint32s:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%llu\n", (unsigned long long) mulle_vararg_next_uint32( args));
   mulle_vararg_end( args);
}


- (void) uint64s:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%llu\n", (unsigned long long) mulle_vararg_next_uint64( args));
   mulle_vararg_end( args);
}


- (void) floats:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%g\n", (double) mulle_vararg_next_float( args));
   mulle_vararg_end( args);
}


- (void) doubles:(int) n, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
      printf( "%g\n", mulle_vararg_next_double( args));
   mulle_vararg_end( args);
}


//
// the promotion classes mixed up, so that the padding between a 4 byte
// and an 8 byte slot is exercised in the middle of the block
//
- (void) mixed:(int) n, ...
{
   char                a;
   short               b;
   int                 c;
   long                d;
   long long           e;
   float               f;
   double              g;
   char                *h;
   char                *i;
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   a = mulle_vararg_next_char( args);
   b = mulle_vararg_next_short( args);
   c = mulle_vararg_next_int( args);
   d = mulle_vararg_next_long( args);
   e = mulle_vararg_next_longlong( args);
   f = mulle_vararg_next_float( args);
   g = mulle_vararg_next_double( args);
   h = mulle_vararg_next_pointer( args, char *);
   i = mulle_vararg_next_pointer( args, char *);
   mulle_vararg_end( args);

   printf( "%d %d %d %ld %lld %g %g %s %s\n", (int) a, (int) b, c, d, e,
                                               (double) f, g, h, i);
}


- (void) pointers:(int) n, ...
{
   char                *s;
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
   {
      s = mulle_vararg_next_pointer( args, char *);
      printf( "%s\n", s);
   }
   mulle_vararg_end( args);
}


- (void) objects:(int) n, ...
{
   id                  obj;
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
   {
      obj = mulle_vararg_next_pointer( args, id);
      printf( "%s\n", obj == self ? "self" : "other");
   }
   mulle_vararg_end( args);
}


- (void) structs:(int) n, ...
{
   struct XY           value;
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
   {
      value = mulle_vararg_next_struct( args, struct XY);
      printf( "%d %g\n", value.a, value.b);
   }
   mulle_vararg_end( args);
}


- (void) functionpointers:(int) n, ...
{
   void                ( *f)( void);
   mulle_vararg_list   args;

   mulle_vararg_start( args, n);
   while( n--)
   {
      f = mulle_vararg_next_pointer( args, void (*)( void));
      ( *f)();
   }
   mulle_vararg_end( args);
}


//
// named parameters of every promotable width, followed by a promoted tail.
//
// Named parameters are NOT promoted: a named char takes one byte, a named
// short two, a named float four. Only the tail is promoted. So the frame is
// laid out like a struct of the named parameters, followed by the promoted
// tail - which is what the compiler emits for a direct call. Using the
// promoted push macro for a named parameter would lay the frame out wrong.
//
// The tail starts at the offset mulle_vararg_start computes from the last
// named parameter, and each tail element is then aligned to its promoted
// alignment by the reader, exactly like struct layout would.
//
- (void) namedChar:(char) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "char %d %d %d\n", (int) a, x, y);
}


- (void) namedShort:(short) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "short %d %d %d\n", (int) a, x, y);
}


- (void) namedInt:(int) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "int %d %d %d\n", a, x, y);
}


- (void) namedLong:(long) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "long %ld %d %d\n", a, x, y);
}


- (void) namedLongLong:(long long) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "longlong %lld %d %d\n", a, x, y);
}


- (void) namedFloat:(float) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "float %g %d %d\n", (double) a, x, y);
}


- (void) namedDouble:(double) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "double %g %d %d\n", a, x, y);
}


- (void) namedPointer:(char *) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "pointer %s %d %d\n", a, x, y);
}


- (void) namedObject:(id) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "object %s %d %d\n", a == self ? "self" : "other", x, y);
}


- (void) namedStruct:(struct XY) a, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, a);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "struct %d %g %d %d\n", a.a, a.b, x, y);
}


//
// The parameter block is a struct of the named parameters, so these are at
// 0, 4 and 8 and the tail starts at 16. Note that a named parameter which
// is narrower than int and not the first one (a short at offset 2 say) is
// out of scope here: mulle_vararg_start then overshoots, even for a direct
// call, so that is not a frame length problem.
//
- (void) threeMixed:(char) a
                 flt:(float) b
                 dbl:(double) c, ...
{
   int                 x, y;
   mulle_vararg_list   args;

   mulle_vararg_start( args, c);
   x = mulle_vararg_next_int( args);
   y = mulle_vararg_next_int( args);
   mulle_vararg_end( args);
   printf( "threeMixed %d %g %g %d %d\n", (int) a, (double) b, c, x, y);
}


- (int) sumInts:(int) n, ...
{
   int                 sum;
   int                 value;
   mulle_vararg_list   args;

   sum = 0;
   mulle_vararg_start( args, n);
   while( n--)
   {
      value = mulle_vararg_next_int( args);
      sum  += value;
   }
   mulle_vararg_end( args);
   return( sum);
}

@end


//
// what mulle_vararg_push_struct does, but with a type based alignof, so
// that it does not warn about the GNU extension of alignof( <expression>)
//
static void   pushStruct( mulle_vararg_list *p, struct XY value)
{
   p->p = mulle_pointer_align( p->p, alignof( struct XY));
   memcpy( p->p, &value, sizeof( value));
   p->p = &((char *) p->p)[ sizeof( value)];
}


static void   invoke( Foo *foo, char *label, SEL sel, void *frame,
                      size_t frameLength)
{
   NSInvocation   *invocation;

   invocation = NSInvocationCreateWithMetaABIFrameAndLength( [foo methodSignatureForSelector:sel],
                                                             foo,
                                                             sel,
                                                             frame,
                                                             frameLength,
                                                             0);
   if( ! invocation)
   {
      printf( "%s: nil\n", label);
      return;
   }

   printf( "%s:\n", label);
   [invocation invoke];
}


#define RUN( label, sel)                                  \
   do                                                     \
   {                                                      \
      invoke( foo, label, sel, frame,                     \
              (size_t) ((char *) p.p - (char *) frame));  \
      p = mulle_vararg_list_make( frame);                 \
   }                                                      \
   while( 0)


int   main( void)
{
   Foo                          *foo;
   Foo                          *other;
   NSInvocation                 *invocation;
   NSMethodSignature            *signature;
   int                          sum;
   struct XY                    xy;
   size_t                       frameLength;
   unsigned int                 i;
   mulle_vararg_builderbuffer_t  frame[ 512];
   mulle_vararg_list             p;

   foo   = [Foo new];
   other = [Foo new];

   memset( frame, 0, sizeof( frame));
   p = mulle_vararg_list_make( frame);

   // cardinality 0, 1, 2 and 3 of the cheapest promotion
   mulle_vararg_push_int( p, 0);
   RUN( "ints/0", @selector( ints:));

   mulle_vararg_push_int( p, 1);
   mulle_vararg_push_int( p, 1);
   RUN( "ints/1", @selector( ints:));

   mulle_vararg_push_int( p, 2);
   mulle_vararg_push_int( p, 1);
   mulle_vararg_push_int( p, 2);
   RUN( "ints/2", @selector( ints:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_int( p, 1);
   mulle_vararg_push_int( p, 2);
   mulle_vararg_push_int( p, 3);
   RUN( "ints/3", @selector( ints:));

   // a longer block, to catch a frameLength that stops at the signature
   mulle_vararg_push_int( p, 16);
   for( i = 1; i <= 16; ++i)
      mulle_vararg_push_int( p, (int) i);
   RUN( "ints/16", @selector( ints:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_char( p, 'A');
   mulle_vararg_push_char( p, 'B');
   mulle_vararg_push_char( p, 'C');
   RUN( "chars", @selector( chars:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_short( p, -1);
   mulle_vararg_push_short( p, 2);
   mulle_vararg_push_short( p, -3);
   RUN( "shorts", @selector( shorts:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_unsignedchar( p, 200);
   mulle_vararg_push_unsignedchar( p, 255);
   mulle_vararg_push_unsignedchar( p, 0);
   RUN( "unsignedchars", @selector( unsignedchars:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_unsignedshort( p, 40000);
   mulle_vararg_push_unsignedshort( p, 65535);
   mulle_vararg_push_unsignedshort( p, 1);
   RUN( "unsignedshorts", @selector( unsignedshorts:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_unsignedint( p, 3000000000U);
   mulle_vararg_push_unsignedint( p, 1);
   mulle_vararg_push_unsignedint( p, 2);
   RUN( "unsignedints", @selector( unsignedints:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_int32( p, -2000000000);
   mulle_vararg_push_int32( p, 2000000000);
   mulle_vararg_push_int32( p, 0);
   RUN( "int32s", @selector( int32s:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_uint32( p, 4000000000U);
   mulle_vararg_push_uint32( p, 1);
   mulle_vararg_push_uint32( p, 2);
   RUN( "uint32s", @selector( uint32s:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_long( p, 1000000000L);
   mulle_vararg_push_long( p, -1L);
   mulle_vararg_push_long( p, 42L);
   RUN( "longs", @selector( longs:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_unsignedlong( p, 10000000000UL);
   mulle_vararg_push_unsignedlong( p, 1UL);
   mulle_vararg_push_unsignedlong( p, 2UL);
   RUN( "unsignedlongs", @selector( unsignedlongs:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_longlong( p, 5000000000LL);
   mulle_vararg_push_longlong( p, -5000000000LL);
   mulle_vararg_push_longlong( p, 0LL);
   RUN( "longlongs", @selector( longlongs:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_unsignedlonglong( p, 5000000000000000000ULL);
   mulle_vararg_push_unsignedlonglong( p, 1ULL);
   mulle_vararg_push_unsignedlonglong( p, 2ULL);
   RUN( "unsignedlonglongs", @selector( unsignedlonglongs:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_int64( p, -5000000000LL);
   mulle_vararg_push_int64( p, 5000000000LL);
   mulle_vararg_push_int64( p, 0LL);
   RUN( "int64s", @selector( int64s:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_uint64( p, 10000000000000000000ULL);
   mulle_vararg_push_uint64( p, 1ULL);
   mulle_vararg_push_uint64( p, 2ULL);
   RUN( "uint64s", @selector( uint64s:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_float( p, 1.5f);
   mulle_vararg_push_float( p, -0.25f);
   mulle_vararg_push_float( p, 3.5f);
   RUN( "floats", @selector( floats:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_double( p, 1.5);
   mulle_vararg_push_double( p, -0.25);
   mulle_vararg_push_double( p, 3.5);
   RUN( "doubles", @selector( doubles:));

   // a 4 byte slot, then a run of 8 byte slots: exercises the padding
   mulle_vararg_push_int( p, 9);
   mulle_vararg_push_char( p, 'A');
   mulle_vararg_push_short( p, -2);
   mulle_vararg_push_int( p, 1000);
   mulle_vararg_push_long( p, 100000L);
   mulle_vararg_push_longlong( p, 5000000000LL);
   mulle_vararg_push_float( p, 1.5f);
   mulle_vararg_push_double( p, 2.5);
   mulle_vararg_push_pointer( p, (void *) "mixed");
   mulle_vararg_push_pointer( p, (void *) "again");
   RUN( "mixed", @selector( mixed:));

   mulle_vararg_push_int( p, 2);
   mulle_vararg_push_pointer( p, (void *) "VfL Bochum 1848");
   mulle_vararg_push_pointer( p, (void *) "1848");
   RUN( "pointers", @selector( pointers:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_pointer( p, (void *) foo);
   mulle_vararg_push_pointer( p, (void *) other);
   mulle_vararg_push_pointer( p, (void *) foo);
   RUN( "objects", @selector( objects:));

   mulle_vararg_push_int( p, 2);
   xy.a = 1848;
   xy.b = 2.5;
   pushStruct( &p, xy);
   xy.a = -1848;
   xy.b = -2.5;
   pushStruct( &p, xy);
   RUN( "structs", @selector( structs:));

   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_functionpointer( p, bump);
   mulle_vararg_push_functionpointer( p, bump);
   mulle_vararg_push_functionpointer( p, bump);
   RUN( "functionpointers", @selector( functionpointers:));
   printf( "calls: %d\n", calls);

   _mulle_vararg_push( p, char, 'A');
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedChar", @selector( namedChar:));

   _mulle_vararg_push( p, short, -123);
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedShort", @selector( namedShort:));

   mulle_vararg_push_int( p, 123);
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedInt", @selector( namedInt:));

   mulle_vararg_push_long( p, 1234567890L);
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedLong", @selector( namedLong:));

   mulle_vararg_push_longlong( p, 1234567890123LL);
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedLongLong", @selector( namedLongLong:));

   _mulle_vararg_push( p, float, 1.5f);
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedFloat", @selector( namedFloat:));

   mulle_vararg_push_double( p, 2.5);
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedDouble", @selector( namedDouble:));

   mulle_vararg_push_pointer( p, (void *) "named");
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedPointer", @selector( namedPointer:));

   mulle_vararg_push_pointer( p, (void *) foo);
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedObject", @selector( namedObject:));

   xy.a = 1848;
   xy.b = 2.5;
   pushStruct( &p, xy);
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "namedStruct", @selector( namedStruct:));

   _mulle_vararg_push( p, char, 'B');
   _mulle_vararg_push( p, float, 1.5f);
   mulle_vararg_push_double( p, 2.5);
   mulle_vararg_push_int( p, 7);
   mulle_vararg_push_int( p, 8);
   RUN( "threeMixed", @selector( threeMixed:flt:dbl:));

   // a return value through a variadic invocation
   mulle_vararg_push_int( p, 4);
   mulle_vararg_push_int( p, 1);
   mulle_vararg_push_int( p, 2);
   mulle_vararg_push_int( p, 3);
   mulle_vararg_push_int( p, 4);

   signature   = [foo methodSignatureForSelector:@selector( sumInts:)];
   frameLength = (size_t) ((char *) p.p - (char *) frame);
   invocation  = NSInvocationCreateWithMetaABIFrameAndLength( signature,
                                                             foo,
                                                             @selector( sumInts:),
                                                             frame,
                                                             frameLength,
                                                             0);
   sum = -1;
   if( invocation)
   {
      [invocation invoke];
      [invocation getReturnValue:&sum];
   }
   printf( "sum: %d\n", sum);

   [other release];
   [foo release];
   return( 0);
}
