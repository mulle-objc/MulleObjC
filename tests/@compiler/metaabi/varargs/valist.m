//
//  main.m
//  test-varargs
//
//  Created by Nat! on 29.10.15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//
#include <mulle_objc/mulle_objc.h>
#include <mulle_vararg/mulle_vararg.h>

#include <string.h>


@interface Foo

+ (id) alloc;
- (void) dealloc;
- (id) initWithUTF8Characters:(uint8_t *)  chars
                       length:(unsigned int) len;
- (id) initWithFormat:(uint8_t *) format
              va_list:(va_list) va_list;

@end


@implementation Foo

+ (id) alloc
{
   return( mulle_objc_class_alloc_instance( self, calloc));
}


- (void) dealloc
{
   mulle_objc_object_free( self, free);
}


- (id) initWithUTF8Characters:(uint8_t *)  chars
                       length:(unsigned int) len
{
   printf( "%.*s\n", len, chars);
   return( self);
}


- (id) initWithFormat:(uint8_t *) format
              va_list:(va_list) va_list
{
   return( [self initWithUTF8Characters:format
                                 length:strlen( format)]);
}

@end


int x( int argc, ...)
{
   Foo  *foo;

   va_list  args;

   va_start( args, argc);

// hoped to catch a bug with this...
   foo = [[Foo alloc] initWithFormat:"hello"
                             va_list:args];
   [foo dealloc];
   va_end( args);

   return 0;
}


int   main( void)
{
    x( 2, 3, 4);
}
