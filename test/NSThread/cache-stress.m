#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
# import <MulleObjC/NSDebug.h>
#endif

#include <stdlib.h>
#include <time.h>


// The point of this test is to get the method cache to grow. One of the
// threads will then operate for a small time on the old cache and the other
// on the fresh cache. If there were problems with that we would get a
// wrong method call and therefore also a wrong output sequence.
// Or maybe even a crash.

//#define RANDOMIZE
#define MULTI_THREADED
#define FP   stdout


mulle_atomic_pointer_t     common_counter;

void   wait_for_other_thread( char *name)
{
   uintptr_t   value;

   value = (uintptr_t) _mulle_atomic_pointer_read( &common_counter);
   while( (uintptr_t) _mulle_atomic_pointer_increment( &common_counter) == value)
      value++;
}


#define test_body( sel)                                                            \
   if( _cmd != @selector( sel))                                                    \
   {                                                                               \
      fprintf( stderr, "%p: %s received value %08tx instead of %08tx\n",           \
                           (void *) mulle_thread_self(),                           \
                           #sel, (NSUInteger) _cmd, (NSUInteger) @selector( sel)); \
      MulleObjCHTMLDumpUniverse();                                                 \
      abort();                                                                     \
   }                                                                               \
   return( @selector( sel));


@interface Foo : NSObject
@end

@implementation Foo


+ (SEL) yg9hottp { test_body( yg9hottp); } // fb2c6ff1
+ (SEL) n4q7tdv6 { test_body( n4q7tdv6); } // 1cd40bfe
+ (SEL) nb2xn532 { test_body( nb2xn532); } // c9df3af2
+ (SEL) fgip8ark { test_body( fgip8ark); } // 77030ff5
+ (SEL) yy_0iraf { test_body( yy_0iraf); } // 2d982e03
+ (SEL) wmqieqe9 { test_body( wmqieqe9); } // 0192d3f4
+ (SEL) x90n2ant { test_body( x90n2ant); } // 26f593fd
+ (SEL) d77ssip3 { test_body( d77ssip3); } // 129407fe
+ (SEL) m0e6lueb { test_body( m0e6lueb); } // f2f3e9f8
+ (SEL) oc7qv3bg { test_body( oc7qv3bg); } // dffedaf4
+ (SEL) z7mp6dah { test_body( z7mp6dah); } // 98d08207
+ (SEL) vne1p54e { test_body( vne1p54e); } // 37e34df5
+ (SEL) m4bckb_v { test_body( m4bckb_v); } // b988f8fb
+ (SEL) bd1gom1n { test_body( bd1gom1n); } // fe7e2701
+ (SEL) z_te501r { test_body( z_te501r); } // df35c9f3
+ (SEL) ain0w1jd { test_body( ain0w1jd); } // 594401f0
+ (SEL) slfvk2t4 { test_body( slfvk2t4); } // 858dfafb
+ (SEL) t75zbfsq { test_body( t75zbfsq); } // 4cdf29fa
+ (SEL) x2hkt472 { test_body( x2hkt472); } // 9b1892fc
+ (SEL) p3p7m5dp { test_body( p3p7m5dp); } // ba053efb
+ (SEL) pek0ew_s { test_body( pek0ew_s); } // 7822f6f3
+ (SEL) wl8mydys { test_body( wl8mydys); } // 6d963003
+ (SEL) _x7txegb { test_body( _x7txegb); } // a0106ffd
+ (SEL) oqdd1rqy { test_body( oqdd1rqy); } // 0858aa03
+ (SEL) ypgtywpm { test_body( ypgtywpm); } // f15a350b
+ (SEL) vx9kttly { test_body( vx9kttly); } // a3fe1d0c
+ (SEL) k0p35ux_ { test_body( k0p35ux_); } // 1eb8be0b
+ (SEL) era4e59a { test_body( era4e59a); } // 2d7e55fa
+ (SEL) hadxhf1w { test_body( hadxhf1w); } // 3162530f
+ (SEL) njnhl07a { test_body( njnhl07a); } // 867facfe
+ (SEL) tjuyt7bc { test_body( tjuyt7bc); } // f72dcff3
+ (SEL) jxfp6ew0 { test_body( jxfp6ew0); } // 1210affd
+ (SEL) end52y5n { test_body( end52y5n); } // 3cca9dfb
+ (SEL) hklf26__ { test_body( hklf26__); } // ed576c09
+ (SEL) zt5cw20f { test_body( zt5cw20f); } // e1d4a20d
+ (SEL) kmon25rd { test_body( kmon25rd); } // 881915f1
+ (SEL) fqnrz8nd { test_body( fqnrz8nd); } // 6379f10c
+ (SEL) ysgz76qq { test_body( ysgz76qq); } // 403c7eff
+ (SEL) icb75u8d { test_body( icb75u8d); } // 1c5aa503
+ (SEL) ngrthiek { test_body( ngrthiek); } // ae3febff
+ (SEL) rfo9gzvo { test_body( rfo9gzvo); } // 0148a2f9
+ (SEL) c_qb6wwh { test_body( c_qb6wwh); } // 2134f304
+ (SEL) c63sye8t { test_body( c63sye8t); } // fe2b0302
+ (SEL) kwa63wqx { test_body( kwa63wqx); } // 80f92ef1
+ (SEL) j_uuili8 { test_body( j_uuili8); } // 6da99b09
+ (SEL) zj61aisj { test_body( zj61aisj); } // 5f6323f6
+ (SEL) zh3z0_h1 { test_body( zh3z0_h1); } // 71eb6f07
+ (SEL) y4fvuw79 { test_body( y4fvuw79); } // f8ea9507
+ (SEL) v1hmnmy1 { test_body( v1hmnmy1); } // e7a9750b
+ (SEL) x0g07kmv { test_body( x0g07kmv); } // 3c413cf1
+ (SEL) s0ubktl6 { test_body( s0ubktl6); } // 038d3c03
+ (SEL) ec997yzg { test_body( ec997yzg); } // 95090801
+ (SEL) jkrngp2e { test_body( jkrngp2e); } // 18b96201
+ (SEL) uid2zu9k { test_body( uid2zu9k); } // 847cab05
+ (SEL) xr72x7zo { test_body( xr72x7zo); } // dc46160d
+ (SEL) pij8wvkv { test_body( pij8wvkv); } // 4b7df708
+ (SEL) sarb06j2 { test_body( sarb06j2); } // ebbcb2fb
+ (SEL) b0x8ut60 { test_body( b0x8ut60); } // 86705507
+ (SEL) x74s7jrz { test_body( x74s7jrz); } // 4f5dc009
+ (SEL) oy1jvsil { test_body( oy1jvsil); } // 7f59d10d
+ (SEL) gqvjz4zg { test_body( gqvjz4zg); } // 696fde0d
+ (SEL) t6yluvdj { test_body( t6yluvdj); } // 90cc1efb
+ (SEL) ggrzvbnf { test_body( ggrzvbnf); } // e68c1ff0
+ (SEL) a116dl17 { test_body( a116dl17); } // 7992db06
+ (SEL) vo8n70ph { test_body( vo8n70ph); } // 6c45a1fd
+ (SEL) mr42h5h1 { test_body( mr42h5h1); } // 2b5c5408
+ (SEL) zpk5g277 { test_body( zpk5g277); } // 55769005
+ (SEL) x0338x4m { test_body( x0338x4m); } // 6e5b040d
+ (SEL) ew_7y_7t { test_body( ew_7y_7t); } // d90aa407
+ (SEL) pqnhyv4m { test_body( pqnhyv4m); } // 2f13a80c
+ (SEL) mvsiln0u { test_body( mvsiln0u); } // db7d45fe
+ (SEL) cpmxoqvv { test_body( cpmxoqvv); } // cfc41cfd
+ (SEL) h93673pk { test_body( h93673pk); } // 9c80b50d
+ (SEL) duga5gi0 { test_body( duga5gi0); } // a1b747ff
+ (SEL) jogxwpc_ { test_body( jogxwpc_); } // f1802f09
+ (SEL) kof1zi0m { test_body( kof1zi0m); } // 97340100
+ (SEL) osjm8s5g { test_body( osjm8s5g); } // e0c204f5
+ (SEL) iost9lvo { test_body( iost9lvo); } // 04dc640b
+ (SEL) xmfiro4e { test_body( xmfiro4e); } // 37e8e5fc
+ (SEL) wv872zue { test_body( wv872zue); } // 04624ff7
+ (SEL) c2ktt9eb { test_body( c2ktt9eb); } // a1ed3df2
+ (SEL) f9ce4tjw { test_body( f9ce4tjw); } // 91b698fb
+ (SEL) rhqdbjj9 { test_body( rhqdbjj9); } // fe21a8f4
+ (SEL) odjjdwir { test_body( odjjdwir); } // f2dad609
+ (SEL) mt2gqe_v { test_body( mt2gqe_v); } // 03f2b30f
+ (SEL) jywrq08p { test_body( jywrq08p); } // d827c80f
+ (SEL) px4s8fpn { test_body( px4s8fpn); } // 3b6a4009
+ (SEL) lsfkoec5 { test_body( lsfkoec5); } // b079e2fb
+ (SEL) iqbmnrq0 { test_body( iqbmnrq0); } // d56ab6f6
+ (SEL) tax94t83 { test_body( tax94t83); } // 4cf54e0f
+ (SEL) u2_ddd4k { test_body( u2_ddd4k); } // e62a8602
+ (SEL) uybjkdjz { test_body( uybjkdjz); } // 8e335706
+ (SEL) b6p_n6oh { test_body( b6p_n6oh); } // fed5d9f6
+ (SEL) tt4zf3l0 { test_body( tt4zf3l0); } // 38ddc502
+ (SEL) s9i6dymi { test_body( s9i6dymi); } // b45485f3
+ (SEL) ac0ete68 { test_body( ac0ete68); } // 483997f3
+ (SEL) g6g2k_7h { test_body( g6g2k_7h); } // ba53dc0e
+ (SEL) d1c3p01z { test_body( d1c3p01z); } // e056a4fd
+ (SEL) o7zyapvv { test_body( o7zyapvv); } // d38dd1f5
+ (SEL) dzpov7tg { test_body( dzpov7tg); } // 465bcd0f
+ (SEL) f5ce7apt { test_body( f5ce7apt); } // f714ed07
+ (SEL) zauvd0q6 { test_body( zauvd0q6); } // 9b3f4306
+ (SEL) m31hc2db { test_body( m31hc2db); } // 9fb2c8fd
+ (SEL) gto7q3tp { test_body( gto7q3tp); } // 29a82f02
+ (SEL) ul_560o_ { test_body( ul_560o_); } // 7d165904
+ (SEL) qt3c81qp { test_body( qt3c81qp); } // f0b17003
+ (SEL) w3yxtq3_ { test_body( w3yxtq3_); } // 15c2a8f8
+ (SEL) k_l43od7 { test_body( k_l43od7); } // 1c1ee103
+ (SEL) l8tihhv4 { test_body( l8tihhv4); } // 9ca4980c
+ (SEL) tfav4qx1 { test_body( tfav4qx1); } // eb2c5a00
+ (SEL) cmldgzlx { test_body( cmldgzlx); } // ad5aba01
+ (SEL) oboj3jfs { test_body( oboj3jfs); } // a160b0f1
+ (SEL) agt7idjm { test_body( agt7idjm); } // 76bcdb07
+ (SEL) tk07w84w { test_body( tk07w84w); } // 4e7503f3
+ (SEL) n1c_cbgl { test_body( n1c_cbgl); } // 655d0b08
+ (SEL) jqr35mkr { test_body( jqr35mkr); } // 93a31f01
+ (SEL) in_8amsy { test_body( in_8amsy); } // 01e8a5f3
+ (SEL) mn5al64r { test_body( mn5al64r); } // ce9e100a
+ (SEL) t4hv_ali { test_body( t4hv_ali); } // b5f8930b
+ (SEL) r0x7d_dm { test_body( r0x7d_dm); } // 2a7ca100
+ (SEL) suz1j5gn { test_body( suz1j5gn); } // f790ef09
+ (SEL) dtljhmot { test_body( dtljhmot); } // a85c6dff
+ (SEL) mcsgd45w { test_body( mcsgd45w); } // d6c38afd
+ (SEL) tpy2fk0s { test_body( tpy2fk0s); } // 4a5df60e
+ (SEL) pw5ev71l { test_body( pw5ev71l); } // b494b30e
+ (SEL) zmwobfw3 { test_body( zmwobfw3); } // 6a98ab0a
+ (SEL) ap207y5q { test_body( ap207y5q); } // 2a63ed02
+ (SEL) w5couvq7 { test_body( w5couvq7); } // 06322f0d


#define test_assert( self, sel)                                                   \
   for( mulle_objc_methodid_t val = [self sel]; val != @selector( sel);)          \
   {                                                                              \
      fprintf( stderr, "%p: %s returned value %08tx instead of %08tx\n",          \
                           (void *) mulle_thread_self(),                          \
                           #sel, (NSUInteger) val, (NSUInteger) @selector( sel)); \
      MulleObjCHTMLDumpUniverse();                                                \
      abort();                                                                    \
   }


+ (void) run:(id) unused
{
   char  *name;
   int   i;

#ifdef MULTI_THREADED
   name = [NSThread mainThread] == [NSThread currentThread] ? "a" : "b";

   wait_for_other_thread( name);
#endif

//   MulleObjCHTMLDumpUniverse();

   for( i = 0; i < 128; i++)
#ifdef RANDOMIZE
      switch( rand() % 128)
#else
      switch( i)
#endif
      {
      case   0 : test_assert( self, yg9hottp); break;
      case   1 : test_assert( self, n4q7tdv6); break;
      case   2 : test_assert( self, nb2xn532); break;
      case   3 : test_assert( self, fgip8ark); break;
      case   4 : test_assert( self, yy_0iraf); break;
      case   5 : test_assert( self, wmqieqe9); break;
      case   6 : test_assert( self, x90n2ant); break;
      case   7 : test_assert( self, d77ssip3); break;
      case   8 : test_assert( self, m0e6lueb); break;
      case   9 : test_assert( self, oc7qv3bg); break;
      case  10 : test_assert( self, z7mp6dah); break;
      case  11 : test_assert( self, vne1p54e); break;
      case  12 : test_assert( self, m4bckb_v); break;
      case  13 : test_assert( self, bd1gom1n); break;
      case  14 : test_assert( self, z_te501r); break;
      case  15 : test_assert( self, ain0w1jd); break;
      case  16 : test_assert( self, slfvk2t4); break;
      case  17 : test_assert( self, t75zbfsq); break;
      case  18 : test_assert( self, x2hkt472); break;
      case  19 : test_assert( self, p3p7m5dp); break;
      case  20 : test_assert( self, pek0ew_s); break;
      case  21 : test_assert( self, wl8mydys); break;
      case  22 : test_assert( self, _x7txegb); break;
      case  23 : test_assert( self, oqdd1rqy); break;
      case  24 : test_assert( self, ypgtywpm); break;
      case  25 : test_assert( self, vx9kttly); break;
      case  26 : test_assert( self, k0p35ux_); break;
      case  27 : test_assert( self, era4e59a); break;
      case  28 : test_assert( self, hadxhf1w); break;
      case  29 : test_assert( self, njnhl07a); break;
      case  30 : test_assert( self, tjuyt7bc); break;
      case  31 : test_assert( self, jxfp6ew0); break;
      case  32 : test_assert( self, end52y5n); break;
      case  33 : test_assert( self, hklf26__); break;
      case  34 : test_assert( self, zt5cw20f); break;
      case  35 : test_assert( self, kmon25rd); break;
      case  36 : test_assert( self, fqnrz8nd); break;
      case  37 : test_assert( self, ysgz76qq); break;
      case  38 : test_assert( self, icb75u8d); break;
      case  39 : test_assert( self, ngrthiek); break;
      case  40 : test_assert( self, rfo9gzvo); break;
      case  41 : test_assert( self, c_qb6wwh); break;
      case  42 : test_assert( self, c63sye8t); break;
      case  43 : test_assert( self, kwa63wqx); break;
      case  44 : test_assert( self, j_uuili8); break;
      case  45 : test_assert( self, zj61aisj); break;
      case  46 : test_assert( self, zh3z0_h1); break;
      case  47 : test_assert( self, y4fvuw79); break;
      case  48 : test_assert( self, v1hmnmy1); break;
      case  49 : test_assert( self, x0g07kmv); break;
      case  50 : test_assert( self, s0ubktl6); break;
      case  51 : test_assert( self, ec997yzg); break;
      case  52 : test_assert( self, jkrngp2e); break;
      case  53 : test_assert( self, uid2zu9k); break;
      case  54 : test_assert( self, xr72x7zo); break;
      case  55 : test_assert( self, pij8wvkv); break;
      case  56 : test_assert( self, sarb06j2); break;
      case  57 : test_assert( self, b0x8ut60); break;
      case  58 : test_assert( self, x74s7jrz); break;
      case  59 : test_assert( self, oy1jvsil); break;
      case  60 : test_assert( self, gqvjz4zg); break;
      case  61 : test_assert( self, t6yluvdj); break;
      case  62 : test_assert( self, ggrzvbnf); break;
      case  63 : test_assert( self, a116dl17); break;
      case  64 : test_assert( self, vo8n70ph); break;
      case  65 : test_assert( self, mr42h5h1); break;
      case  66 : test_assert( self, zpk5g277); break;
      case  67 : test_assert( self, x0338x4m); break;
      case  68 : test_assert( self, ew_7y_7t); break;
      case  69 : test_assert( self, pqnhyv4m); break;
      case  70 : test_assert( self, mvsiln0u); break;
      case  71 : test_assert( self, cpmxoqvv); break;
      case  72 : test_assert( self, h93673pk); break;
      case  73 : test_assert( self, duga5gi0); break;
      case  74 : test_assert( self, jogxwpc_); break;
      case  75 : test_assert( self, kof1zi0m); break;
      case  76 : test_assert( self, osjm8s5g); break;
      case  77 : test_assert( self, iost9lvo); break;
      case  78 : test_assert( self, xmfiro4e); break;
      case  79 : test_assert( self, wv872zue); break;
      case  80 : test_assert( self, c2ktt9eb); break;
      case  81 : test_assert( self, f9ce4tjw); break;
      case  82 : test_assert( self, rhqdbjj9); break;
      case  83 : test_assert( self, odjjdwir); break;
      case  84 : test_assert( self, mt2gqe_v); break;
      case  85 : test_assert( self, jywrq08p); break;
      case  86 : test_assert( self, px4s8fpn); break;
      case  87 : test_assert( self, lsfkoec5); break;
      case  88 : test_assert( self, iqbmnrq0); break;
      case  89 : test_assert( self, tax94t83); break;
      case  90 : test_assert( self, u2_ddd4k); break;
      case  91 : test_assert( self, uybjkdjz); break;
      case  92 : test_assert( self, b6p_n6oh); break;
      case  93 : test_assert( self, tt4zf3l0); break;
      case  94 : test_assert( self, s9i6dymi); break;
      case  95 : test_assert( self, ac0ete68); break;
      case  96 : test_assert( self, g6g2k_7h); break;
      case  97 : test_assert( self, d1c3p01z); break;
      case  98 : test_assert( self, o7zyapvv); break;
      case  99 : test_assert( self, dzpov7tg); break;
      case 100 : test_assert( self, f5ce7apt); break;
      case 101 : test_assert( self, zauvd0q6); break;
      case 102 : test_assert( self, m31hc2db); break;
      case 103 : test_assert( self, gto7q3tp); break;
      case 104 : test_assert( self, ul_560o_); break;
      case 105 : test_assert( self, qt3c81qp); break;
      case 106 : test_assert( self, w3yxtq3_); break;
      case 107 : test_assert( self, k_l43od7); break;
      case 108 : test_assert( self, l8tihhv4); break;
      case 109 : test_assert( self, tfav4qx1); break;
      case 110 : test_assert( self, cmldgzlx); break;
      case 111 : test_assert( self, oboj3jfs); break;
      case 112 : test_assert( self, agt7idjm); break;
      case 113 : test_assert( self, tk07w84w); break;
      case 114 : test_assert( self, n1c_cbgl); break;
      case 115 : test_assert( self, jqr35mkr); break;
      case 116 : test_assert( self, in_8amsy); break;
      case 117 : test_assert( self, mn5al64r); break;
      case 118 : test_assert( self, t4hv_ali); break;
      case 119 : test_assert( self, r0x7d_dm); break;
      case 120 : test_assert( self, suz1j5gn); break;
      case 121 : test_assert( self, dtljhmot); break;
      case 122 : test_assert( self, mcsgd45w); break;
      case 123 : test_assert( self, tpy2fk0s); break;
      case 124 : test_assert( self, pw5ev71l); break;
      case 125 : test_assert( self, zmwobfw3); break;
      case 126 : test_assert( self, ap207y5q); break;
      case 127 : test_assert( self, w5couvq7); break;
   }
}
@end



int main( void)
{
   NSThread    *thread;

#ifdef RANDOMIZE
   srand( time( NULL));
#endif
#ifdef MULTI_THREADED
   thread = [[[NSThread alloc] initWithTarget:[Foo class]
                                     selector:@selector( run:)
                                       object:nil] autorelease];
   [thread mulleStart];
#endif
   [Foo run:nil];
#ifdef MULTI_THREADED
   [thread mulleJoin];
#endif
   // mulle_objc_class_htmldump_to_directory( [Foo class], ".");
   return( 0);
}
