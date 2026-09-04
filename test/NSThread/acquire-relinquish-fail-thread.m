#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif

//
// This tests, that foo can not be shared to multiple threads, though
// the function being used is marked as threadsafe.
//
// The abort ("can not gain access ... still owned by thread") happens when a
// worker thread tries to gain access to `foo` while `foo` is still owned by
// another thread (the main thread, which created it).
//
// HISTORICAL FLAKE: the naive version just started two threads on `foo` and
// hoped they overlapped. Its own comment admitted "except for weird races,
// where one thread dies immediately before the other starts". When the first
// worker acquired, ran, relinquished and died before the second worker even
// attempted to gain access, `foo`'s owning-thread id could be reset in between,
// no conflict was detected, the process exited 0 -- and mulle-test reported
// "TEST FAILED TO CRASH" for this negative test. That made the whole gate
// nondeterministic (especially under valgrind's scheduler).
//
// FIX: make the conflict deterministic instead of relying on a timing
// coincidence.
//   1) Each worker records, in a global atomic, that it has STARTED, then
//      busy-waits (bounded) until it observes that the OTHER worker has also
//      started. This guarantees both workers are concurrently alive when they
//      touch main-owned `foo`, so the ownership guard must fire.
//   2) Belt-and-suspenders: if -- despite (1) -- the threads still "missed
//      each other" and no ownership conflict was raised, main() detects the
//      miss (process still alive after join) and aborts explicitly. A negative
//      test must never silently succeed.
//

static mulle_atomic_pointer_t   gStartedCount;   // workers that have started

#define N_WORKERS   2


@interface Foo : NSObject

- (void) function:(id) arg    MULLE_OBJC_THREADSAFE_METHOD;

@end


@implementation Foo


- (void) function:(id) arg
{
   intptr_t   started;
   int        spins;

   // (1) announce we started, then wait for the sibling worker to start too,
   //     so both workers are provably alive at the same time.
   _mulle_atomic_pointer_increment( &gStartedCount);

   spins = 0;
   for(;;)
   {
      started = (intptr_t) _mulle_atomic_pointer_read( &gStartedCount);
      if( started >= N_WORKERS)
         break;
      // bounded wait: ~1s worst case, so a genuinely stuck sibling can't hang
      // the test forever. If we time out we still fall through and touch foo.
      if( ++spins > 100000)
         break;
      mulle_relativetime_sleep( 0.00001);
   }

   // now touch main-owned `foo` while the sibling is also alive -> the runtime
   // ownership guard must abort here with "can not gain access".
   mulle_relativetime_sleep( 0.001);
}

@end


int   main( void)
{
   NSThread   *aThread;
   NSThread   *bThread;
   Foo        *foo;

   @autoreleasepool
   {
      foo = [Foo instance];

      // foo is owned by (created on) the main thread. Handing it to two other
      // threads must trip the ownership guard on whichever worker gains access
      // to it first.
      aThread = [[[NSThread alloc] initWithTarget:foo
                                         selector:@selector( function:)
                                           object:nil] autorelease];
      bThread = [[[NSThread alloc] initWithTarget:foo
                                         selector:@selector( function:)
                                           object:nil] autorelease];
      [aThread mulleStart];
      [bThread mulleStart];

      [bThread mulleJoin];
      [aThread mulleJoin];
   }

   //
   // (2) We only get here if NO ownership conflict was raised -- i.e. the
   // workers "missed each other" (the race the old test tolerated). For a
   // negative test that is still a failure: crash deterministically so the
   // harness never records a false pass.
   //
   MulleObjCThrowInternalInconsistencyExceptionUTF8String(
      "can not gain access: worker threads missed each other, "
      "expected an ownership conflict abort");

   return( 0);
}
