#import <MulleObjC/MulleObjC.h>


#import <stdint.h>


//
// Benchmark that contrasts the call cost of the different dispatching
// mechanisms of mulle-objc:
//
//   1. plain C function calls
//   2. Objective-C method calls via the FCS "vtable" (fastmethodtable)
//   3. Objective-C method calls via the class method cache
//   4. calls that get forwarded to another object's method
//   5. calls through NSInvocation
//
// The benchmark just prints a calls/s number and never fails. Timings are
// super flakey, so run it twice. The first run warms up the process, the
// second run is the one that matters.
//
// The optimizer will try its very best to remove the calls, so the measured
// loops are MULLE_C_NEVER_INLINE and the return values are accumulated and
// printed at the end. The dispatch targets are function pointers, so they
// can not be devirtualized away. The bench compiles at -O3 -DNDEBUG via the
// `dispatch-bench.Debug.CFLAGS` / `dispatch-bench.Release.CFLAGS` files;
// -O0 figures would be meaningless here.
//
// Because a `.CFLAGS` file clobbers the platform default flags, the file
// must also mirror the thread-affinity flag of the linked library: the
// Debug build of MulleObjC is `-fobjc-tao`, the Release build is
// `-fno-objc-tao` (the runtime rejects a mismatch).
//
// NOTE: The (Debug) test build compiles with -fobjc-tao, which keeps
// non-threadsafe methods out of the method cache ("refail" on every call).
// To compare the dispatch *mechanisms* on equal footing, the TAO bit is
// cleared upfront in main, so the "objc cache" and "objc forward:" cases
// measure true cache hits. Run with `MULLE_OBJC_CHECK_TAO=NO` to achieve
// the same effect externally.
//


@interface Bench : NSObject

- (instancetype) init;
- (id) run:(id) param;

@end


@implementation Bench

- (instancetype) init
{
   return( self);
}


- (id) run:(id) param
{
   return( self);
}

@end


@interface ForwardProxy : NSObject
{
   id   _target;
}

- (instancetype) initWithTarget:(id) target;
- (void *) forward:(void *) param;

@end


@implementation ForwardProxy

- (instancetype) initWithTarget:(id) target
{
   if( (self = [super init]))
      _target = target;
   return( self);
}


// override -forward: so that the whole forward path (cache miss on the
// proxy, forward, second dispatch on the target) is compiled in this file
// at the same optimization level. Relying on NSObject's -forward: would
// pull in the -O0 build of the MulleObjC library and blow up the number
// with debug code.
//
// The proxy does not implement run:, so dispatching run: on it misses the
// proxy's cache and lands here. This forwards the message to _target, i.e.
// one dispatch on the proxy (that reaches forward:) plus one dispatch on the
// target object. That is the minimal honest "forward to another object's
// method" cost.
- (void *) forward:(void *) param
{
   return( mulle_objc_object_call_inline_variable( _target,
                                                   (mulle_objc_methodid_t) _cmd,
                                                   param));
}

@end


typedef void *(* call_t)( void *object, void *parameter);


static mulle_objc_methodid_t   CacheSel;
static uintptr_t               Accumulator;


MULLE_C_NEVER_INLINE
static void *c_call( void *object, void *parameter)
{
   return( object);
}


MULLE_C_NEVER_INLINE
static void *cache_call( void *object, void *parameter)
{
   return( mulle_objc_object_call_inline_full( object, CacheSel, parameter));
}


#ifdef __MULLE_OBJC_FCS__
#define MULLE_OBJC_BENCH_VTAB_SLOT_INIT   1   // == mulle_objc_get_fastmethodtable_index( MULLE_OBJC_INIT_METHODID)
MULLE_C_NEVER_INLINE
static void *vtable_call( void *object, void *parameter)
{
   struct _mulle_objc_class              *cls;
   mulle_objc_implementation_t           imp;

   // compile-time constant slot index, just like inlined FCS dispatch gets
   // for a constant _cmd. A runtime global would force a reload of the index
   // on every call, which would distort the measurement.
   cls = _mulle_objc_object_get_isa( object);
   imp = (mulle_objc_implementation_t)
            _mulle_atomic_pointer_read( &cls->vtab.methods[ MULLE_OBJC_BENCH_VTAB_SLOT_INIT].pointer);
   return( (*imp)( object, MULLE_OBJC_INIT_METHODID, parameter));
}
#endif


// dispatch a method the proxy does not implement; its inherited -forward:
// calls -forwardingTargetForSelector:, which hands off to the real Bench
// object, which then actually implements run:
MULLE_C_NEVER_INLINE
static void *forward_call( void *object, void *parameter)
{
   return( mulle_objc_object_call_inline_full( object, CacheSel, parameter));
}


MULLE_C_NEVER_INLINE
static void *invocation_call( void *object, void *parameter)
{
   [(NSInvocation *) object invoke];
   return( object);
}


struct benchcase
{
   char     *name;
   call_t   call;
   id       object;
};


MULLE_C_NEVER_INLINE
static uintptr_t  bench_loop( call_t call, id object, size_t iterations)
{
   size_t        i;
   uintptr_t     sum;

   sum = 0;
   for( i = 0; i < iterations; i++)
      sum += (uintptr_t) (*call)( object, (void *) i);

   return( sum);
}


MULLE_C_NEVER_INLINE
static void  run_case( struct benchcase *bc, int iterations, double budget)
{
   mulle_relativetime_t   a;
   mulle_relativetime_t   b;
   double                 calls;
   double                 seconds;
   size_t                 it;

   // warmup to fill the method cache and the vtable fault handlers
   Accumulator += bench_loop( bc->call, bc->object, 1000);

   it = iterations;
   for(;;)
   {
      mulle_thread_yield();

      a = mulle_relativetime_now();
      Accumulator += bench_loop( bc->call, bc->object, it);
      b = mulle_relativetime_now();

      seconds = b - a;
      if( seconds >= budget)
         break;
      it *= 2;
   }

   // the real measurement run
   mulle_thread_yield();

   a = mulle_relativetime_now();
   Accumulator += bench_loop( bc->call, bc->object, it);
   b = mulle_relativetime_now();

   seconds = b - a;
   calls   = (double) it / seconds;

   mulle_fprintf( stderr, "%-16s %14.0f calls/s   (acc=%#llx)\n",
                  bc->name, calls, (unsigned long long) Accumulator);
}


int  main( int argc, char *argv[])
{
   Bench                             *bench;
   ForwardProxy                      *proxy;
   NSInvocation                      *invocation;
   struct benchcase                   cases[ 5];
   struct _mulle_objc_universe       *universe;
   int                                first;
   int                                i;
   int                                iterations;
   int                                n;
   double                             budget;

   @autoreleasepool
   {
      // the test build compiles with -fobjc-tao (see dispatch-bench.CFLAGS),
      // which keeps non-threadsafe methods out of the method cache
      // ("refail" on every call). Clear the TAO bit so that this benchmark
      // measures the plain dispatch mechanisms instead of the TAO miss path.
      universe = mulle_objc_global_get_universe( 0);
      universe->debug.method_call &= ~MULLE_OBJC_UNIVERSE_CALL_TAO_BIT;

      bench    = [Bench instance];
      proxy    = [[ForwardProxy alloc] initWithTarget:bench];
      invocation = [NSInvocation mulleInvocationWithTarget:bench
                                                 selector:@selector( run:)
                                                   object:nil];

      CacheSel = (mulle_objc_methodid_t) @selector( run:);

      n = 0;

      cases[ n].name   = "c function";
      cases[ n].call   = c_call;
      cases[ n].object = bench;
      n++;

      cases[ n].name   = "objc cache";
      cases[ n].call   = cache_call;
      cases[ n].object = bench;
      n++;

#ifdef __MULLE_OBJC_FCS__
      // MULLE_OBJC_INIT_METHODID is always a fast method (slot 0-5)
      cases[ n].name   = "objc vtable";
      cases[ n].call   = vtable_call;
      cases[ n].object = bench;
      n++;
#endif

      cases[ n].name   = "objc forward:";
      cases[ n].call   = forward_call;
      cases[ n].object = proxy;
      n++;

      cases[ n].name   = "NSInvocation";
      cases[ n].call   = invocation_call;
      cases[ n].object = invocation;
      n++;

      if( argc > 1)
         iterations = atoi( argv[ 1]);
      else
         iterations = 100000;

      if( argc > 2)
         budget = atof( argv[ 2]);
      else
         budget = 1.0;

      if( argc > 3)
         first = atoi( argv[ 3]);
      else
         first = -1;

      if( first >= 0)
         n = 1;

      // each run_case does its own warmup, so the numbers are a bit less flaky
      for( i = 0; i < n; i++)
         run_case( &cases[ first < 0 ? i : first + i], iterations, budget);

      mulle_fprintf( stderr, "\n");
   }

   return( 0);
}


/*
 * #### Usage ####
 *
 *    dispatch-bench.exe [iterations [budget [caseindex]]]
 *
 * The iteration count is doubled until a run lasts at least `budget`
 * seconds (default 1.0s), so the numbers are stable on slow and fast
 * machines. `caseindex` runs only a single case (0..4). Expect the timing
 * to be flaky; run twice and take the second set.
 */