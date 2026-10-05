//
// Compiler generated static @signature instances and runtime generated
// dynamic signatures must describe the same method identically.
//
// Regression: on 64 bit the compiler emitted natural_size 8 for _cmd (':'),
// while the runtime uses sizeof( mulle_objc_methodid_t), which is 4.
// MulleObjC's NSInvocation copied info->natural_size bytes into a SEL local,
// so the larger static size overflowed the stack in optimized builds.
//
// This test asserts the two agree. It fails while the inconsistency exists.
// The output only reports per argument agreement, no sizes or offsets, so it
// is stable across 32/64 bit and platforms.
//
#import <MulleObjC/MulleObjC.h>
#include <stdio.h>

@interface Foo : NSObject
- (int) add:(int) a to:(int) b;
@end

@implementation Foo
- (int) add:(int) a to:(int) b   { return( a + b); }
@end


int   main( void)
{
   NSMethodSignature                  *staticSig;
   NSMethodSignature                  *dynamicSig;
   MulleObjCMethodSignatureTypeInfo   *staticInfo;
   MulleObjCMethodSignatureTypeInfo   *dynamicInfo;
   NSUInteger                         i;
   NSUInteger                         n;
   int                                consistent;

   staticSig  = @signature( - (int) add:(int) a to:(int) b);
   dynamicSig = [Foo instanceMethodSignatureForSelector:@selector( add:to:)];

   // numberOfArguments excludes rval, the internal index includes it
   consistent = [staticSig numberOfArguments] == [dynamicSig numberOfArguments];
   if( ! consistent)
      printf( "count: MISMATCH\n");

   n = [staticSig numberOfArguments] + 1;
   if( [dynamicSig numberOfArguments] + 1 < n)
      n = [dynamicSig numberOfArguments] + 1;

   for( i = 0; i < n; i++)
   {
      staticInfo  = [staticSig mulleSignatureTypeInfoAtIndex:i];
      dynamicInfo = [dynamicSig mulleSignatureTypeInfoAtIndex:i];

      if( staticInfo->invocation_offset != dynamicInfo->invocation_offset ||
          staticInfo->natural_size      != dynamicInfo->natural_size)
      {
         consistent = 0;
         printf( "%lu: MISMATCH\n", (unsigned long) i);
      }
      else
         printf( "%lu: ok\n", (unsigned long) i);
   }

   printf( "consistent: %s\n", consistent ? "yes" : "no");

   return( consistent ? 0 : 1);
}
