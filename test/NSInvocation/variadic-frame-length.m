#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif

#include <mulle-vararg/mulle-vararg-builder.h>


@interface Foo : NSObject
@end


@implementation Foo

//
// the named parameter is an int, so that natural and promoted layout agree
// and a caller can build the entire parameter block with the vararg builder
//
- (void) collect:(int) first, ...
{
   mulle_vararg_list   args;
   int                 value;

   printf( "%d\n", first);

   mulle_vararg_start( args, first);
   do
   {
      value = mulle_vararg_next_int( args);
      printf( "%d\n", value);
   }
   while( value);

   mulle_vararg_end( args);
}

@end


int   main( void)
{
   Foo                          *foo;
   NSInvocation                 *invocation;
   NSMethodSignature            *signature;
   size_t                       frameLength;
   mulle_vararg_builderbuffer_t frame[ 64];
   mulle_vararg_list            p;

   foo       = [Foo new];
   signature = [foo methodSignatureForSelector:@selector( collect:)];
   if( ! signature)
   {
      printf( "no signature\n");
      return( 1);
   }

   //
   // the signature can not describe the variadic tail, so it can not size
   // an invocation. The factory has to refuse it, as that nil is how
   // -forward: detects that it can not copy a variadic parameter block
   //
   printf( "variadic: %d\n", (int) [signature isVariadic]);
   printf( "invocationSize: %lu\n", (unsigned long) [signature mulleInvocationSize]);
   printf( "factory: %s\n", [NSInvocation invocationWithMethodSignature:signature] ? "yes" : "no");

   //
   // named parameter first, then the promoted tail, terminator 0
   //
   p = mulle_vararg_list_make( frame);
   mulle_vararg_push_int( p, 1);
   mulle_vararg_push_int( p, 11);
   mulle_vararg_push_int( p, 22);
   mulle_vararg_push_int( p, 0);

   frameLength = (size_t) ((char *) p.p - (char *) frame);

   invocation = NSInvocationCreateWithMetaABIFrameAndLength( signature,
                                                             foo,
                                                             @selector( collect:),
                                                             frame,
                                                             frameLength,
                                                             0);
   if( ! invocation)
   {
      printf( "no invocation\n");
      return( 1);
   }

   [invocation invoke];

   // a zero frameLength is a caller error and must not create anything
   printf( "without length: %s\n",
           NSInvocationCreateWithMetaABIFrameAndLength( signature,
                                                        foo,
                                                        @selector( collect:),
                                                        frame,
                                                        0,
                                                        0) ? "yes" : "no");

   [foo release];
   return( 0);
}
