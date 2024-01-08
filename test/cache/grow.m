#include <mulle-objc-runtime/mulle-objc-runtime.h>

@interface Foo
@end

@implementation Foo

+ (id) alloc
{
   return( mulle_objc_infraclass_alloc_instance( (struct _mulle_objc_infraclass *) self));
}

- (void) dealloc
{
   mulle_objc_instance_free( self);
}


- (void) a_0000 {}
- (void) a_0001 {}
- (void) a_0002 {}
- (void) a_0003 {}
- (void) a_0004 {}
- (void) a_0005 {}
- (void) a_0006 {}
- (void) a_0007 {}
- (void) a_0008 {}
- (void) a_0009 {}
- (void) a_000a {}
- (void) a_000b {}
- (void) a_000c {}
- (void) a_000d {}
- (void) a_000e {}
- (void) a_000f {}

- (void) a_0010 {}
- (void) a_0011 {}
- (void) a_0012 {}
- (void) a_0013 {}
- (void) a_0014 {}
- (void) a_0015 {}
- (void) a_0016 {}
- (void) a_0017 {}
- (void) a_0018 {}
- (void) a_0019 {}
- (void) a_001a {}
- (void) a_001b {}
- (void) a_001c {}
- (void) a_001d {}
- (void) a_001e {}
- (void) a_001f {}

- (void) a_0020 {}
- (void) a_0021 {}
- (void) a_0022 {}
- (void) a_0023 {}
- (void) a_0024 {}
- (void) a_0025 {}
- (void) a_0026 {}
- (void) a_0027 {}
- (void) a_0028 {}
- (void) a_0029 {}
- (void) a_002a {}
- (void) a_002b {}
- (void) a_002c {}
- (void) a_002d {}
- (void) a_002e {}
- (void) a_002f {}

- (void) a_0030 {}
- (void) a_0031 {}
- (void) a_0032 {}
- (void) a_0033 {}
- (void) a_0034 {}
- (void) a_0035 {}
- (void) a_0036 {}
- (void) a_0037 {}
- (void) a_0038 {}
- (void) a_0039 {}
- (void) a_003a {}
- (void) a_003b {}
- (void) a_003c {}
- (void) a_003d {}
- (void) a_003e {}
- (void) a_003f {}

- (void) b_0000 {}
- (void) b_0001 {}
- (void) b_0002 {}
- (void) b_0003 {}
- (void) b_0004 {}
- (void) b_0005 {}
- (void) b_0006 {}
- (void) b_0007 {}
- (void) b_0008 {}
- (void) b_0009 {}
- (void) b_000a {}
- (void) b_000b {}
- (void) b_000c {}
- (void) b_000d {}
- (void) b_000e {}
- (void) b_000f {}

- (void) b_0010 {}
- (void) b_0011 {}
- (void) b_0012 {}
- (void) b_0013 {}
- (void) b_0014 {}
- (void) b_0015 {}
- (void) b_0016 {}
- (void) b_0017 {}
- (void) b_0018 {}
- (void) b_0019 {}
- (void) b_001a {}
- (void) b_001b {}
- (void) b_001c {}
- (void) b_001d {}
- (void) b_001e {}
- (void) b_001f {}

- (void) b_0020 {}
- (void) b_0021 {}
- (void) b_0022 {}
- (void) b_0023 {}
- (void) b_0024 {}
- (void) b_0025 {}
- (void) b_0026 {}
- (void) b_0027 {}
- (void) b_0028 {}
- (void) b_0029 {}
- (void) b_002a {}
- (void) b_002b {}
- (void) b_002c {}
- (void) b_002d {}
- (void) b_002e {}
- (void) b_002f {}

- (void) b_0030 {}
- (void) b_0031 {}
- (void) b_0032 {}
- (void) b_0033 {}
- (void) b_0034 {}
- (void) b_0035 {}
- (void) b_0036 {}
- (void) b_0037 {}
- (void) b_0038 {}
- (void) b_0039 {}
- (void) b_003a {}
- (void) b_003b {}
- (void) b_003c {}
- (void) b_003d {}
- (void) b_003e {}
- (void) b_003f {}

@end



int  main( void)
{
   Foo   *foo;

   // this should grow the cache a couple of times
   // calling all those methods
   //
   foo = [Foo alloc];

   [foo a_0000];
   [foo a_0001];
   [foo a_0002];
   [foo a_0003];
   [foo a_0004];
   [foo a_0005];
   [foo a_0006];
   [foo a_0007];
   [foo a_0008];
   [foo a_0009];
   [foo a_000a];
   [foo a_000b];
   [foo a_000c];
   [foo a_000d];
   [foo a_000e];
   [foo a_000f];

   [foo a_0010];
   [foo a_0011];
   [foo a_0012];
   [foo a_0013];
   [foo a_0014];
   [foo a_0015];
   [foo a_0016];
   [foo a_0017];
   [foo a_0018];
   [foo a_0019];
   [foo a_001a];
   [foo a_001b];
   [foo a_001c];
   [foo a_001d];
   [foo a_001e];
   [foo a_001f];

   [foo a_0020];
   [foo a_0021];
   [foo a_0022];
   [foo a_0023];
   [foo a_0024];
   [foo a_0025];
   [foo a_0026];
   [foo a_0027];
   [foo a_0028];
   [foo a_0029];
   [foo a_002a];
   [foo a_002b];
   [foo a_002c];
   [foo a_002d];
   [foo a_002e];
   [foo a_002f];

   [foo a_0030];
   [foo a_0031];
   [foo a_0032];
   [foo a_0033];
   [foo a_0034];
   [foo a_0035];
   [foo a_0036];
   [foo a_0037];
   [foo a_0038];
   [foo a_0039];
   [foo a_003a];
   [foo a_003b];
   [foo a_003c];
   [foo a_003d];
   [foo a_003e];
   [foo a_003f];

   [foo b_0000];
   [foo b_0001];
   [foo b_0002];
   [foo b_0003];
   [foo b_0004];
   [foo b_0005];
   [foo b_0006];
   [foo b_0007];
   [foo b_0008];
   [foo b_0009];
   [foo b_000a];
   [foo b_000b];
   [foo b_000c];
   [foo b_000d];
   [foo b_000e];
   [foo b_000f];

   [foo b_0010];
   [foo b_0011];
   [foo b_0012];
   [foo b_0013];
   [foo b_0014];
   [foo b_0015];
   [foo b_0016];
   [foo b_0017];
   [foo b_0018];
   [foo b_0019];
   [foo b_001a];
   [foo b_001b];
   [foo b_001c];
   [foo b_001d];
   [foo b_001e];
   [foo b_001f];

   [foo b_0020];
   [foo b_0021];
   [foo b_0022];
   [foo b_0023];
   [foo b_0024];
   [foo b_0025];
   [foo b_0026];
   [foo b_0027];
   [foo b_0028];
   [foo b_0029];
   [foo b_002a];
   [foo b_002b];
   [foo b_002c];
   [foo b_002d];
   [foo b_002e];
   [foo b_002f];

   [foo b_0030];
   [foo b_0031];
   [foo b_0032];
   [foo b_0033];
   [foo b_0034];
   [foo b_0035];
   [foo b_0036];
   [foo b_0037];
   [foo b_0038];
   [foo b_0039];
   [foo b_003a];
   [foo b_003b];
   [foo b_003c];
   [foo b_003d];
   [foo b_003e];
   [foo b_003f];

   [foo dealloc];

   return( 0);
}
