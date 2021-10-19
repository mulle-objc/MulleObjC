#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif

#include <stdlib.h>
#include <time.h>
// The point of this test is to get the method cache to grow. One of the
// threads will then operate for a small time on the old cache and the other
// on the fresh cache. If there were problems with that we would get a
// wront method call and therefore also a wrong output sequence.
// Or maybe even a crash.


#define FP   stdout


mulle_atomic_pointer_t     common_counter;

void   wait_for_other_thread( char *name)
{
   uintptr_t   value;

   value = (uintptr_t) _mulle_atomic_pointer_read( &common_counter);
   while( (uintptr_t) _mulle_atomic_pointer_increment( &common_counter) == value)
      value++;
}


@interface Foo : NSObject
@end

@implementation Foo


+ (SEL) yg9hottp { return( @selector( yg9hottp)); } // fb2c6ff1
+ (SEL) n4q7tdv6 { return( @selector( n4q7tdv6)); } // 1cd40bfe
+ (SEL) nb2xn532 { return( @selector( nb2xn532)); } // c9df3af2
+ (SEL) fgip8ark { return( @selector( fgip8ark)); } // 77030ff5
+ (SEL) yy_0iraf { return( @selector( yy_0iraf)); } // 2d982e03
+ (SEL) wmqieqe9 { return( @selector( wmqieqe9)); } // 0192d3f4
+ (SEL) x90n2ant { return( @selector( x90n2ant)); } // 26f593fd
+ (SEL) d77ssip3 { return( @selector( d77ssip3)); } // 129407fe
+ (SEL) m0e6lueb { return( @selector( m0e6lueb)); } // f2f3e9f8
+ (SEL) oc7qv3bg { return( @selector( oc7qv3bg)); } // dffedaf4
+ (SEL) z7mp6dah { return( @selector( z7mp6dah)); } // 98d08207
+ (SEL) vne1p54e { return( @selector( vne1p54e)); } // 37e34df5
+ (SEL) m4bckb_v { return( @selector( m4bckb_v)); } // b988f8fb
+ (SEL) bd1gom1n { return( @selector( bd1gom1n)); } // fe7e2701
+ (SEL) z_te501r { return( @selector( z_te501r)); } // df35c9f3
+ (SEL) ain0w1jd { return( @selector( ain0w1jd)); } // 594401f0
+ (SEL) slfvk2t4 { return( @selector( slfvk2t4)); } // 858dfafb
+ (SEL) t75zbfsq { return( @selector( t75zbfsq)); } // 4cdf29fa
+ (SEL) x2hkt472 { return( @selector( x2hkt472)); } // 9b1892fc
+ (SEL) p3p7m5dp { return( @selector( p3p7m5dp)); } // ba053efb
+ (SEL) pek0ew_s { return( @selector( pek0ew_s)); } // 7822f6f3
+ (SEL) wl8mydys { return( @selector( wl8mydys)); } // 6d963003
+ (SEL) _x7txegb { return( @selector( _x7txegb)); } // a0106ffd
+ (SEL) oqdd1rqy { return( @selector( oqdd1rqy)); } // 0858aa03
+ (SEL) ypgtywpm { return( @selector( ypgtywpm)); } // f15a350b
+ (SEL) vx9kttly { return( @selector( vx9kttly)); } // a3fe1d0c
+ (SEL) k0p35ux_ { return( @selector( k0p35ux_)); } // 1eb8be0b
+ (SEL) era4e59a { return( @selector( era4e59a)); } // 2d7e55fa
+ (SEL) hadxhf1w { return( @selector( hadxhf1w)); } // 3162530f
+ (SEL) njnhl07a { return( @selector( njnhl07a)); } // 867facfe
+ (SEL) tjuyt7bc { return( @selector( tjuyt7bc)); } // f72dcff3
+ (SEL) jxfp6ew0 { return( @selector( jxfp6ew0)); } // 1210affd
+ (SEL) end52y5n { return( @selector( end52y5n)); } // 3cca9dfb
+ (SEL) hklf26__ { return( @selector( hklf26__)); } // ed576c09
+ (SEL) zt5cw20f { return( @selector( zt5cw20f)); } // e1d4a20d
+ (SEL) kmon25rd { return( @selector( kmon25rd)); } // 881915f1
+ (SEL) fqnrz8nd { return( @selector( fqnrz8nd)); } // 6379f10c
+ (SEL) ysgz76qq { return( @selector( ysgz76qq)); } // 403c7eff
+ (SEL) icb75u8d { return( @selector( icb75u8d)); } // 1c5aa503
+ (SEL) ngrthiek { return( @selector( ngrthiek)); } // ae3febff
+ (SEL) rfo9gzvo { return( @selector( rfo9gzvo)); } // 0148a2f9
+ (SEL) c_qb6wwh { return( @selector( c_qb6wwh)); } // 2134f304
+ (SEL) c63sye8t { return( @selector( c63sye8t)); } // fe2b0302
+ (SEL) kwa63wqx { return( @selector( kwa63wqx)); } // 80f92ef1
+ (SEL) j_uuili8 { return( @selector( j_uuili8)); } // 6da99b09
+ (SEL) zj61aisj { return( @selector( zj61aisj)); } // 5f6323f6
+ (SEL) zh3z0_h1 { return( @selector( zh3z0_h1)); } // 71eb6f07
+ (SEL) y4fvuw79 { return( @selector( y4fvuw79)); } // f8ea9507
+ (SEL) v1hmnmy1 { return( @selector( v1hmnmy1)); } // e7a9750b
+ (SEL) x0g07kmv { return( @selector( x0g07kmv)); } // 3c413cf1
+ (SEL) s0ubktl6 { return( @selector( s0ubktl6)); } // 038d3c03
+ (SEL) ec997yzg { return( @selector( ec997yzg)); } // 95090801
+ (SEL) jkrngp2e { return( @selector( jkrngp2e)); } // 18b96201
+ (SEL) uid2zu9k { return( @selector( uid2zu9k)); } // 847cab05
+ (SEL) xr72x7zo { return( @selector( xr72x7zo)); } // dc46160d
+ (SEL) pij8wvkv { return( @selector( pij8wvkv)); } // 4b7df708
+ (SEL) sarb06j2 { return( @selector( sarb06j2)); } // ebbcb2fb
+ (SEL) b0x8ut60 { return( @selector( b0x8ut60)); } // 86705507
+ (SEL) x74s7jrz { return( @selector( x74s7jrz)); } // 4f5dc009
+ (SEL) oy1jvsil { return( @selector( oy1jvsil)); } // 7f59d10d
+ (SEL) gqvjz4zg { return( @selector( gqvjz4zg)); } // 696fde0d
+ (SEL) t6yluvdj { return( @selector( t6yluvdj)); } // 90cc1efb
+ (SEL) ggrzvbnf { return( @selector( ggrzvbnf)); } // e68c1ff0
+ (SEL) a116dl17 { return( @selector( a116dl17)); } // 7992db06
+ (SEL) vo8n70ph { return( @selector( vo8n70ph)); } // 6c45a1fd
+ (SEL) mr42h5h1 { return( @selector( mr42h5h1)); } // 2b5c5408
+ (SEL) zpk5g277 { return( @selector( zpk5g277)); } // 55769005
+ (SEL) x0338x4m { return( @selector( x0338x4m)); } // 6e5b040d
+ (SEL) ew_7y_7t { return( @selector( ew_7y_7t)); } // d90aa407
+ (SEL) pqnhyv4m { return( @selector( pqnhyv4m)); } // 2f13a80c
+ (SEL) mvsiln0u { return( @selector( mvsiln0u)); } // db7d45fe
+ (SEL) cpmxoqvv { return( @selector( cpmxoqvv)); } // cfc41cfd
+ (SEL) h93673pk { return( @selector( h93673pk)); } // 9c80b50d
+ (SEL) duga5gi0 { return( @selector( duga5gi0)); } // a1b747ff
+ (SEL) jogxwpc_ { return( @selector( jogxwpc_)); } // f1802f09
+ (SEL) kof1zi0m { return( @selector( kof1zi0m)); } // 97340100
+ (SEL) osjm8s5g { return( @selector( osjm8s5g)); } // e0c204f5
+ (SEL) iost9lvo { return( @selector( iost9lvo)); } // 04dc640b
+ (SEL) xmfiro4e { return( @selector( xmfiro4e)); } // 37e8e5fc
+ (SEL) wv872zue { return( @selector( wv872zue)); } // 04624ff7
+ (SEL) c2ktt9eb { return( @selector( c2ktt9eb)); } // a1ed3df2
+ (SEL) f9ce4tjw { return( @selector( f9ce4tjw)); } // 91b698fb
+ (SEL) rhqdbjj9 { return( @selector( rhqdbjj9)); } // fe21a8f4
+ (SEL) odjjdwir { return( @selector( odjjdwir)); } // f2dad609
+ (SEL) mt2gqe_v { return( @selector( mt2gqe_v)); } // 03f2b30f
+ (SEL) jywrq08p { return( @selector( jywrq08p)); } // d827c80f
+ (SEL) px4s8fpn { return( @selector( px4s8fpn)); } // 3b6a4009
+ (SEL) lsfkoec5 { return( @selector( lsfkoec5)); } // b079e2fb
+ (SEL) iqbmnrq0 { return( @selector( iqbmnrq0)); } // d56ab6f6
+ (SEL) tax94t83 { return( @selector( tax94t83)); } // 4cf54e0f
+ (SEL) u2_ddd4k { return( @selector( u2_ddd4k)); } // e62a8602
+ (SEL) uybjkdjz { return( @selector( uybjkdjz)); } // 8e335706
+ (SEL) b6p_n6oh { return( @selector( b6p_n6oh)); } // fed5d9f6
+ (SEL) tt4zf3l0 { return( @selector( tt4zf3l0)); } // 38ddc502
+ (SEL) s9i6dymi { return( @selector( s9i6dymi)); } // b45485f3
+ (SEL) ac0ete68 { return( @selector( ac0ete68)); } // 483997f3
+ (SEL) g6g2k_7h { return( @selector( g6g2k_7h)); } // ba53dc0e
+ (SEL) d1c3p01z { return( @selector( d1c3p01z)); } // e056a4fd
+ (SEL) o7zyapvv { return( @selector( o7zyapvv)); } // d38dd1f5
+ (SEL) dzpov7tg { return( @selector( dzpov7tg)); } // 465bcd0f
+ (SEL) f5ce7apt { return( @selector( f5ce7apt)); } // f714ed07
+ (SEL) zauvd0q6 { return( @selector( zauvd0q6)); } // 9b3f4306
+ (SEL) m31hc2db { return( @selector( m31hc2db)); } // 9fb2c8fd
+ (SEL) gto7q3tp { return( @selector( gto7q3tp)); } // 29a82f02
+ (SEL) ul_560o_ { return( @selector( ul_560o_)); } // 7d165904
+ (SEL) qt3c81qp { return( @selector( qt3c81qp)); } // f0b17003
+ (SEL) w3yxtq3_ { return( @selector( w3yxtq3_)); } // 15c2a8f8
+ (SEL) k_l43od7 { return( @selector( k_l43od7)); } // 1c1ee103
+ (SEL) l8tihhv4 { return( @selector( l8tihhv4)); } // 9ca4980c
+ (SEL) tfav4qx1 { return( @selector( tfav4qx1)); } // eb2c5a00
+ (SEL) cmldgzlx { return( @selector( cmldgzlx)); } // ad5aba01
+ (SEL) oboj3jfs { return( @selector( oboj3jfs)); } // a160b0f1
+ (SEL) agt7idjm { return( @selector( agt7idjm)); } // 76bcdb07
+ (SEL) tk07w84w { return( @selector( tk07w84w)); } // 4e7503f3
+ (SEL) n1c_cbgl { return( @selector( n1c_cbgl)); } // 655d0b08
+ (SEL) jqr35mkr { return( @selector( jqr35mkr)); } // 93a31f01
+ (SEL) in_8amsy { return( @selector( in_8amsy)); } // 01e8a5f3
+ (SEL) mn5al64r { return( @selector( mn5al64r)); } // ce9e100a
+ (SEL) t4hv_ali { return( @selector( t4hv_ali)); } // b5f8930b
+ (SEL) r0x7d_dm { return( @selector( r0x7d_dm)); } // 2a7ca100
+ (SEL) suz1j5gn { return( @selector( suz1j5gn)); } // f790ef09
+ (SEL) dtljhmot { return( @selector( dtljhmot)); } // a85c6dff
+ (SEL) mcsgd45w { return( @selector( mcsgd45w)); } // d6c38afd
+ (SEL) tpy2fk0s { return( @selector( tpy2fk0s)); } // 4a5df60e
+ (SEL) pw5ev71l { return( @selector( pw5ev71l)); } // b494b30e
+ (SEL) zmwobfw3 { return( @selector( zmwobfw3)); } // 6a98ab0a
+ (SEL) ap207y5q { return( @selector( ap207y5q)); } // 2a63ed02
+ (SEL) w5couvq7 { return( @selector( w5couvq7)); } // 06322f0d


static void   test_assert( BOOL value)
{
   if( ! value)
      abort();
}


+ (void) run:(id) unused
{
   char  *name;
   int   i;

   name = [NSThread mainThread] == [NSThread currentThread] ? "a" : "b";

   wait_for_other_thread( name);

   for( i = 0; i < 128; i++)
      switch( rand() % 128)
      {
      case 0 : test_assert( [self yg9hottp] == @selector( yg9hottp)); break;
      case 1 : test_assert( [self n4q7tdv6] == @selector( n4q7tdv6)); break;
      case 2 : test_assert( [self nb2xn532] == @selector( nb2xn532)); break;
      case 3 : test_assert( [self fgip8ark] == @selector( fgip8ark)); break;
      case 4 : test_assert( [self yy_0iraf] == @selector( yy_0iraf)); break;
      case 5 : test_assert( [self wmqieqe9] == @selector( wmqieqe9)); break;
      case 6 : test_assert( [self x90n2ant] == @selector( x90n2ant)); break;
      case 7 : test_assert( [self d77ssip3] == @selector( d77ssip3)); break;
      case 8 : test_assert( [self m0e6lueb] == @selector( m0e6lueb)); break;
      case 9 : test_assert( [self oc7qv3bg] == @selector( oc7qv3bg)); break;
      case 10 : test_assert( [self z7mp6dah] == @selector( z7mp6dah)); break;
      case 11 : test_assert( [self vne1p54e] == @selector( vne1p54e)); break;
      case 12 : test_assert( [self m4bckb_v] == @selector( m4bckb_v)); break;
      case 13 : test_assert( [self bd1gom1n] == @selector( bd1gom1n)); break;
      case 14 : test_assert( [self z_te501r] == @selector( z_te501r)); break;
      case 15 : test_assert( [self ain0w1jd] == @selector( ain0w1jd)); break;
      case 16 : test_assert( [self slfvk2t4] == @selector( slfvk2t4)); break;
      case 17 : test_assert( [self t75zbfsq] == @selector( t75zbfsq)); break;
      case 18 : test_assert( [self x2hkt472] == @selector( x2hkt472)); break;
      case 19 : test_assert( [self p3p7m5dp] == @selector( p3p7m5dp)); break;
      case 20 : test_assert( [self pek0ew_s] == @selector( pek0ew_s)); break;
      case 21 : test_assert( [self wl8mydys] == @selector( wl8mydys)); break;
      case 22 : test_assert( [self _x7txegb] == @selector( _x7txegb)); break;
      case 23 : test_assert( [self oqdd1rqy] == @selector( oqdd1rqy)); break;
      case 24 : test_assert( [self ypgtywpm] == @selector( ypgtywpm)); break;
      case 25 : test_assert( [self vx9kttly] == @selector( vx9kttly)); break;
      case 26 : test_assert( [self k0p35ux_] == @selector( k0p35ux_)); break;
      case 27 : test_assert( [self era4e59a] == @selector( era4e59a)); break;
      case 28 : test_assert( [self hadxhf1w] == @selector( hadxhf1w)); break;
      case 29 : test_assert( [self njnhl07a] == @selector( njnhl07a)); break;
      case 30 : test_assert( [self tjuyt7bc] == @selector( tjuyt7bc)); break;
      case 31 : test_assert( [self jxfp6ew0] == @selector( jxfp6ew0)); break;
      case 32 : test_assert( [self end52y5n] == @selector( end52y5n)); break;
      case 33 : test_assert( [self hklf26__] == @selector( hklf26__)); break;
      case 34 : test_assert( [self zt5cw20f] == @selector( zt5cw20f)); break;
      case 35 : test_assert( [self kmon25rd] == @selector( kmon25rd)); break;
      case 36 : test_assert( [self fqnrz8nd] == @selector( fqnrz8nd)); break;
      case 37 : test_assert( [self ysgz76qq] == @selector( ysgz76qq)); break;
      case 38 : test_assert( [self icb75u8d] == @selector( icb75u8d)); break;
      case 39 : test_assert( [self ngrthiek] == @selector( ngrthiek)); break;
      case 40 : test_assert( [self rfo9gzvo] == @selector( rfo9gzvo)); break;
      case 41 : test_assert( [self c_qb6wwh] == @selector( c_qb6wwh)); break;
      case 42 : test_assert( [self c63sye8t] == @selector( c63sye8t)); break;
      case 43 : test_assert( [self kwa63wqx] == @selector( kwa63wqx)); break;
      case 44 : test_assert( [self j_uuili8] == @selector( j_uuili8)); break;
      case 45 : test_assert( [self zj61aisj] == @selector( zj61aisj)); break;
      case 46 : test_assert( [self zh3z0_h1] == @selector( zh3z0_h1)); break;
      case 47 : test_assert( [self y4fvuw79] == @selector( y4fvuw79)); break;
      case 48 : test_assert( [self v1hmnmy1] == @selector( v1hmnmy1)); break;
      case 49 : test_assert( [self x0g07kmv] == @selector( x0g07kmv)); break;
      case 50 : test_assert( [self s0ubktl6] == @selector( s0ubktl6)); break;
      case 51 : test_assert( [self ec997yzg] == @selector( ec997yzg)); break;
      case 52 : test_assert( [self jkrngp2e] == @selector( jkrngp2e)); break;
      case 53 : test_assert( [self uid2zu9k] == @selector( uid2zu9k)); break;
      case 54 : test_assert( [self xr72x7zo] == @selector( xr72x7zo)); break;
      case 55 : test_assert( [self pij8wvkv] == @selector( pij8wvkv)); break;
      case 56 : test_assert( [self sarb06j2] == @selector( sarb06j2)); break;
      case 57 : test_assert( [self b0x8ut60] == @selector( b0x8ut60)); break;
      case 58 : test_assert( [self x74s7jrz] == @selector( x74s7jrz)); break;
      case 59 : test_assert( [self oy1jvsil] == @selector( oy1jvsil)); break;
      case 60 : test_assert( [self gqvjz4zg] == @selector( gqvjz4zg)); break;
      case 61 : test_assert( [self t6yluvdj] == @selector( t6yluvdj)); break;
      case 62 : test_assert( [self ggrzvbnf] == @selector( ggrzvbnf)); break;
      case 63 : test_assert( [self a116dl17] == @selector( a116dl17)); break;
      case 64 : test_assert( [self vo8n70ph] == @selector( vo8n70ph)); break;
      case 65 : test_assert( [self mr42h5h1] == @selector( mr42h5h1)); break;
      case 66 : test_assert( [self zpk5g277] == @selector( zpk5g277)); break;
      case 67 : test_assert( [self x0338x4m] == @selector( x0338x4m)); break;
      case 68 : test_assert( [self ew_7y_7t] == @selector( ew_7y_7t)); break;
      case 69 : test_assert( [self pqnhyv4m] == @selector( pqnhyv4m)); break;
      case 70 : test_assert( [self mvsiln0u] == @selector( mvsiln0u)); break;
      case 71 : test_assert( [self cpmxoqvv] == @selector( cpmxoqvv)); break;
      case 72 : test_assert( [self h93673pk] == @selector( h93673pk)); break;
      case 73 : test_assert( [self duga5gi0] == @selector( duga5gi0)); break;
      case 74 : test_assert( [self jogxwpc_] == @selector( jogxwpc_)); break;
      case 75 : test_assert( [self kof1zi0m] == @selector( kof1zi0m)); break;
      case 76 : test_assert( [self osjm8s5g] == @selector( osjm8s5g)); break;
      case 77 : test_assert( [self iost9lvo] == @selector( iost9lvo)); break;
      case 78 : test_assert( [self xmfiro4e] == @selector( xmfiro4e)); break;
      case 79 : test_assert( [self wv872zue] == @selector( wv872zue)); break;
      case 80 : test_assert( [self c2ktt9eb] == @selector( c2ktt9eb)); break;
      case 81 : test_assert( [self f9ce4tjw] == @selector( f9ce4tjw)); break;
      case 82 : test_assert( [self rhqdbjj9] == @selector( rhqdbjj9)); break;
      case 83 : test_assert( [self odjjdwir] == @selector( odjjdwir)); break;
      case 84 : test_assert( [self mt2gqe_v] == @selector( mt2gqe_v)); break;
      case 85 : test_assert( [self jywrq08p] == @selector( jywrq08p)); break;
      case 86 : test_assert( [self px4s8fpn] == @selector( px4s8fpn)); break;
      case 87 : test_assert( [self lsfkoec5] == @selector( lsfkoec5)); break;
      case 88 : test_assert( [self iqbmnrq0] == @selector( iqbmnrq0)); break;
      case 89 : test_assert( [self tax94t83] == @selector( tax94t83)); break;
      case 90 : test_assert( [self u2_ddd4k] == @selector( u2_ddd4k)); break;
      case 91 : test_assert( [self uybjkdjz] == @selector( uybjkdjz)); break;
      case 92 : test_assert( [self b6p_n6oh] == @selector( b6p_n6oh)); break;
      case 93 : test_assert( [self tt4zf3l0] == @selector( tt4zf3l0)); break;
      case 94 : test_assert( [self s9i6dymi] == @selector( s9i6dymi)); break;
      case 95 : test_assert( [self ac0ete68] == @selector( ac0ete68)); break;
      case 96 : test_assert( [self g6g2k_7h] == @selector( g6g2k_7h)); break;
      case 97 : test_assert( [self d1c3p01z] == @selector( d1c3p01z)); break;
      case 98 : test_assert( [self o7zyapvv] == @selector( o7zyapvv)); break;
      case 99 : test_assert( [self dzpov7tg] == @selector( dzpov7tg)); break;
      case 100 : test_assert( [self f5ce7apt] == @selector( f5ce7apt)); break;
      case 101 : test_assert( [self zauvd0q6] == @selector( zauvd0q6)); break;
      case 102 : test_assert( [self m31hc2db] == @selector( m31hc2db)); break;
      case 103 : test_assert( [self gto7q3tp] == @selector( gto7q3tp)); break;
      case 104 : test_assert( [self ul_560o_] == @selector( ul_560o_)); break;
      case 105 : test_assert( [self qt3c81qp] == @selector( qt3c81qp)); break;
      case 106 : test_assert( [self w3yxtq3_] == @selector( w3yxtq3_)); break;
      case 107 : test_assert( [self k_l43od7] == @selector( k_l43od7)); break;
      case 108 : test_assert( [self l8tihhv4] == @selector( l8tihhv4)); break;
      case 109 : test_assert( [self tfav4qx1] == @selector( tfav4qx1)); break;
      case 110 : test_assert( [self cmldgzlx] == @selector( cmldgzlx)); break;
      case 111 : test_assert( [self oboj3jfs] == @selector( oboj3jfs)); break;
      case 112 : test_assert( [self agt7idjm] == @selector( agt7idjm)); break;
      case 113 : test_assert( [self tk07w84w] == @selector( tk07w84w)); break;
      case 114 : test_assert( [self n1c_cbgl] == @selector( n1c_cbgl)); break;
      case 115 : test_assert( [self jqr35mkr] == @selector( jqr35mkr)); break;
      case 116 : test_assert( [self in_8amsy] == @selector( in_8amsy)); break;
      case 117 : test_assert( [self mn5al64r] == @selector( mn5al64r)); break;
      case 118 : test_assert( [self t4hv_ali] == @selector( t4hv_ali)); break;
      case 119 : test_assert( [self r0x7d_dm] == @selector( r0x7d_dm)); break;
      case 120 : test_assert( [self suz1j5gn] == @selector( suz1j5gn)); break;
      case 121 : test_assert( [self dtljhmot] == @selector( dtljhmot)); break;
      case 122 : test_assert( [self mcsgd45w] == @selector( mcsgd45w)); break;
      case 123 : test_assert( [self tpy2fk0s] == @selector( tpy2fk0s)); break;
      case 124 : test_assert( [self pw5ev71l] == @selector( pw5ev71l)); break;
      case 125 : test_assert( [self zmwobfw3] == @selector( zmwobfw3)); break;
      case 126 : test_assert( [self ap207y5q] == @selector( ap207y5q)); break;
      case 127 : test_assert( [self w5couvq7] == @selector( w5couvq7)); break;
   }
}
@end



int main( void)
{
   NSThread    *thread;

   srand( time( NULL));
   thread = [[[NSThread alloc] initWithTarget:[Foo class]
                                     selector:@selector( run:)
                                       object:nil] autorelease];
   [thread mulleStartUndetached];
   [Foo run:nil];
   [thread mulleJoin];
   // mulle_objc_class_htmldump_to_directory( [Foo class], ".");
   return( 0);
}
