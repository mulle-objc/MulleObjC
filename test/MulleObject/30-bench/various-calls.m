#import <MulleObjC/MulleObjC.h>
#import <MulleObjC/NSLock-Private.h>
#import <MulleObjC/NSRecursiveLock-Private.h>
#import <MulleObjC/MulleObject-Private.h>

#import <MulleObjC/MulleObjCDebug.h>


@interface A : MulleObject < MulleAutolockingObjectProtocols>

- (void) safeCall:(NSUInteger) n     MULLE_OBJC_THREADSAFE_METHOD;
- (void) unsafeCall:(NSUInteger) n;

@end


@implementation A

- (void) unsafeCall:(NSUInteger) n
{
   if( n)
      [self unsafeCall:n - 1];
}

- (void) safeCall:(NSUInteger) n
{
   if( n)
      [self safeCall:n - 1];
}

@end


@interface B : NSObject
{
   NSRecursiveLock  *_lock;

}
- (void) safeCall:(NSUInteger) n     MULLE_OBJC_THREADSAFE_METHOD;
- (void) unsafeCall:(NSUInteger) n;

@end


@implementation B

- (id) init 
{
   _lock = [NSLock new];
   return( self);
}

- (void) dealloc 
{
   [_lock release];
   [super dealloc];
}


// the unsafeCall gets the lock, because its unsafe without it 
// (just to make this equivalent to A)
- (void) unsafeCall:(NSUInteger) n
{
   [_lock lock];
   if( n)
      [self unsafeCall:n - 1];
   [_lock unlock];
}

- (void) safeCall:(NSUInteger) n
{
   if( n)
      [self safeCall:n - 1];
}

@end


// check that overhead introduced by *_lock is neglible (or not)
@interface C : MulleObject
{
   mulle_atomic_pointer_t  _whatever;
   mulle_thread_t          _thread;
   mulle_thread_mutex_t    _mutex;
}
- (void) safeCall:(NSUInteger) n     MULLE_OBJC_THREADSAFE_METHOD;
- (void) unsafeCall:(NSUInteger) n;

@end


@implementation C

- (instancetype) init
{
   mulle_thread_mutex_init( &_mutex);
   return( self);
}


- (void) dealloc
{
   mulle_thread_mutex_done( &_mutex);
   [super dealloc];
}


// the unsafeCall gets the lock, because its unsafe without it 
// (just to make this equivalent to A)
- (void) unsafeCall:(NSUInteger) n
{
   MulleLockingObjectLock( self);

   if( n)
      [self unsafeCall:n - 1];

   MulleLockingObjectUnlock( self);
}

- (void) safeCall:(NSUInteger) n
{
   // nicht teuer: 0.000000014789s vs 0.000000015450s
   //_mulle_atomic_pointer_increment( &self->_whatever);

   // nicht teuer: 0.000000016191s vs 0.000000015005s
   // _thread = mulle_thread_self();

   // auch nicht so teuer: 0.000000024534s vs 0.000000015184s
   // _thread = mulle_thread_self();
   mulle_thread_mutex_lock( &_mutex);
   mulle_thread_mutex_unlock( &_mutex);

   if( n)
      [self safeCall:n - 1];
}

@end


@interface D : NSObject
{
   mulle_thread_mutex_t    _lock;

}
- (void) safeCall:(NSUInteger) n     MULLE_OBJC_THREADSAFE_METHOD;
- (void) unsafeCall:(NSUInteger) n;

@end


@implementation D

- (instancetype) init
{
   return( MulleObjCLockInit( self));
}

// TODO: check if we this is really needed on a per platform basis
//       mulle_thread should know this...
//
- (void) dealloc
{
   MulleObjCLockDone( self);
   [super dealloc];
}

// the unsafeCall gets the lock, because its unsafe without it 
// (just to make this equivalent to A)
- (void) unsafeCall:(NSUInteger) n
{
   MulleObjCLockLock( self);
   if( n)
      [self unsafeCall:n - 1];
   MulleObjCLockUnlock( self);
}

- (void) safeCall:(NSUInteger) n
{
   if( n)
      [self safeCall:n - 1];
}

@end


MULLE_C_NEVER_INLINE
static void   test_loop( NSUInteger loops, NSUInteger n, A *a, SEL sel)
{
   NSUInteger   j;

   for( j = 0; j < loops; j++)
      mulle_objc_object_call_inline_full_variable( a, sel, (void *) n);
}

MULLE_C_NEVER_INLINE
static void   run_test( NSUInteger n, A *a, SEL sel, BOOL print)
{
   mulle_relativetime_t   start;
   mulle_relativetime_t   end;
   NSUInteger             loops;

   loops = 100000;

   // try to get a slice from the start
   mulle_thread_yield();

   start = mulle_relativetime_now();
   test_loop( loops, n, a, sel);
   end   = mulle_relativetime_now();

   if( print)
      mulle_fprintf( stderr, "%.12fs for [%s %s%tu]\n",
                              (end - start) / loops / (n + 1),
                              MulleObjCObjectGetClassNameUTF8String( a),
                              MulleObjCSelectorUTF8String( sel),
                              n);
}


void  test_object( id obj, NSUInteger n, BOOL print)
{
   NSUInteger   i;

   // these calls will run without the lock wrapper
   for( i = 0; i <= n; i++)
   {
      run_test( i, obj, @selector( safeCall:), print);
   }

   if( print)
      mulle_fprintf( stderr, "\n");

   // these calls will be wrapped inside the automatic lock
   for( i = 0; i <= n; i++)
   {
      run_test( i, obj, @selector( unsafeCall:), print);
   }

   if( print)
      mulle_fprintf( stderr, "\n");
}


// make large caches so that we don't evict and have nicer looking output
// in the HTML dump

static mulle_objc_cache_uint_t   will_init_cache( struct _mulle_objc_universe *universe,
                                                  struct _mulle_objc_class *cls,
                                                  mulle_objc_cache_uint_t n_entries)
{
   return( n_entries < 32 ? 32 : n_entries);
}



static void  tests( BOOL print)
{
   A   *a;
   B   *b;
   C   *c;
   D   *d;

   a = [A object];
   test_object( a, 4, print);

   b = [B object];
   test_object( b, 0, print);

   c = [C object];
   test_object( c, 4, print);

   // remember when doing TAO calls, TAO methods do not go into any cache
   // so that they will be rechecked every time
   d = [D object];
   test_object( d, 0, print);
}


// TODO: check cache growth

int  main( int argc, char *argv[])
{

   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
   universe->callbacks.will_init_cache = will_init_cache;

   tests( NO);

   tests( YES);

   MulleObjCHTMLDumpUniverse();

   return( 0);
}


/*
 * #### Advertisement ####
 *
 * Check for leaks with mulle-testallocator! Add mulle-testallocator to your
 * project:
 *
 * mulle-sde dependency add --marks all-load,no-singlephase \
 *                          --github mulle-core \
 *                          mulle-testallocator
 *
 * Then build your project again and run your executable with the following
 * environment variables:
 *
 *    MULLE_OBJC_PEDANTIC_EXIT=YES
 *    MULLE_TESTALLOCATOR=YES
 *
 * To easier pin down, where a leak is created. try any of:
 *
 *    MULLE_TESTALLOCATOR_TRACE=3
 *    MULLE_OBJC_TRACE_INSTANCE=YES
 *    MULLE_OBJC_TRACE_METHOD_CALL=YES
 *    MULLE_OBJC_TRACE_UNIVERSE=YES
 *
 * If you are writing singleton code try:
 *
 *    MULLE_OBJC_EPHEMERAL_SINGLETON=YES
 *
 */
