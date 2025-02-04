#import <MulleObjC/MulleObjC.h>

#import <MulleObjC/MulleObjCDebug.h>


@interface Foo : MulleObject < MulleAutolockingObjectProtocols>
@end

@implementation Foo
@end


#define s_pool   4

static id                      pool[ s_pool];
static volatile unsigned int   n_pool;
mulle_thread_mutex_t           pool_mutex;


static void   fill_pool( void)
{
   unsigned int   i;

   mulle_thread_mutex_lock( &pool_mutex);
   for( i = 0; i < s_pool; i++)
   {
      if( ! pool[ i])
      {
         pool[ i] = [Foo new];
         ++n_pool;
      }
   }
   mulle_thread_mutex_unlock( &pool_mutex);
}


static void   release_pool( void)
{
   unsigned int   i;

   mulle_thread_mutex_lock( &pool_mutex);
   for( i = 0; i < s_pool; i++)
   {
      [pool[ i] release];
      pool[ i] = 0;
   }
   mulle_thread_mutex_unlock( &pool_mutex);
}


struct id_pair
{
   id   a;
   id   b;
};


static id   _extract_random_object( void)
{
   unsigned int    i;
   id              obj;

   // still locked
   do 
   {
      i = rand() % s_pool;
   }
   while( ! pool[ i]);

   obj      = pool[ i];
   pool[ i] = 0;
   n_pool  -= 1;

   return( obj);
}


static struct id_pair   extract_random_object_pair( void)
{
   unsigned int    i;
   id              obj;
   struct id_pair  pair;

   for(;;)
   {
      mulle_thread_mutex_lock( &pool_mutex);
      if( n_pool >= 2)
         break;
      mulle_thread_mutex_unlock( &pool_mutex);
      mulle_thread_yield();
   }

   pair.a = _extract_random_object();
   pair.b = _extract_random_object();

   mulle_thread_mutex_unlock( &pool_mutex);

   return( pair);
}


static void  insert_object( id obj)
{
   unsigned int   i;

   assert( obj);

   for(;;)
   {
      mulle_thread_mutex_lock( &pool_mutex);
      if( n_pool != s_pool)
         break;
      mulle_thread_mutex_unlock( &pool_mutex);
      mulle_thread_yield();
   }

   // still locked
   for( i = 0; i < s_pool; i++)
   {
      if( ! pool[ i])
      {
         pool[ i] = obj;
         ++n_pool;
         mulle_thread_mutex_unlock( &pool_mutex);
         return;
      }
   }
   abort();
}


#define n_loops   10
#define s_thread  (s_pool * 2)


@interface Foo( Test)

- (void) swap:(id) bar;
- (void) swapWithObject:(Foo *) other;

@end

// Problem: dadurch daß die locks geshared werden, kann es sein daß die locks
//          von pool[ 2] und pool[ 0] dieselbe ist als auch die von 
//          pool[ 3] und pool[ 1]. So benutzt ein thread pair = 
//          { pool[ 0], pool[ 1] }  und der andere pair = { pool[3], pool[2] }
//          wenn beide gleichzeitig laufen, locked thread 0 erst pool[0] und
//          nebenher thread 1 pool[ 3] (gleiche lock wie pool[ 1]) Dann dead
//          locked thread 0 auf pool[ 1]
//
@implementation Foo( Test)

- (void) swapWithObject:(Foo *) other 
{
   mulle_thread_yield();
   [self shareRecursiveLockWithObject:other];
}

- (void) swap:(id) bar
{
   [bar swapWithObject:self];
   mulle_thread_yield();
}

@end


static int   test_thread_main( NSThread *thread, void *index)
{
   unsigned int     i;
   Foo              *foo;
   Foo              *bar;
   struct id_pair   pair;

   for( i = 0; i < n_loops; i++)
   {
      pair = extract_random_object_pair();
      [pair.a swap:pair.b];
      if( i == n_loops / 2)
         mulle_fprintf( stderr, "%p %p\n", index, (void *) mulle_thread_self());
      insert_object( pair.b);
      insert_object( pair.a);
   }
   return( 0);
}


// TODO: check cache growth

int  main( int argc, char *argv[])
{
   Foo            *foo;
   NSThread       *thread[ s_thread];
   unsigned int   i;

   mulle_thread_mutex_init( &pool_mutex);
   {
      fill_pool();

      for( i = 0; i < s_thread; i++)
      {
         thread[ i] = [NSThread mulleThreadWithFunction:test_thread_main
                                               argument:(void *) (intptr_t) i + 1];
         [thread[ i] mulleStart];
      }

      for( i = 0; i < s_thread; i++)
      {
         [thread[ i] mulleJoin];
         mulle_fprintf( stderr, "joined with %p\n", (void *) (intptr_t) i + 1);
      }
      release_pool();
   }
   mulle_thread_mutex_done( &pool_mutex);
   mulle_fprintf( stderr, "gone now\n");

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
