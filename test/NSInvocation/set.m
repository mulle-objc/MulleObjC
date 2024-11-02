#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo

- (void) string:(char *) s
       selector:(SEL) sel
          range:(NSRange) range
      character:(char) c
          float:(float) f
{

   printf( "s         : %s\n", s);
   printf( "selector  : %x\n", sel);
   printf( "range     : { %lu, %lu }\n", range.location, range.length);
   printf( "character : '%c'\n", c);
   printf( "float     : %g\n", f);
}

@end


int   main( void)
{
   Foo                 *foo;
   NSInvocation        *invocation;
   NSMethodSignature   *signature;
   NSRange             range;
   SEL                 sel;
   char                *s;
   float               f;
   char                c;

   foo        = [Foo object];
   sel        = @selector( string:selector:range:character:float:);
   signature  = [foo methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];

   [invocation setSelector:sel];

   s = "VfL Bochum 1848";
   [invocation setArgument:&s
                   atIndex:2];
   sel = @selector( self);
   [invocation setArgument:&sel
                   atIndex:3];
   range = NSRangeMake( 18, 48);
   [invocation setArgument:&range
                   atIndex:4];
   c = 'X';
   [invocation setArgument:&c
                   atIndex:5];
   f = 18.48;
   [invocation setArgument:&f
                   atIndex:6];

   [invocation invokeWithTarget:foo];

   return( 0);
}
