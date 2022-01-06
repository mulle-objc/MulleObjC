#import <MulleObjC/MulleObjC.h>
#import <MulleObjC/private/MulleObjCExceptionHandler-Private.h>

//
// ## MulleInvocationBuilder
//
// ``` objc
// invocation = [MulleInvocationBuilder objectAtIndex:12];
// [invocation invokeWithTarget:array];
// [invocation getReturnValue:&obj];
// ```
//
// A root class, that does something funny. You send the class the method
// you want to call with the properly casted arguments and you get an
// NSInvocation back.
// You can then `-invokeWithTarget:` on a target that supports this method.
//
// This is way more convenient than building a `NSInvocation` by hand.
// If you use arguments that get "upcasted" by default, like `char` and
// `float` casting won't work. Here you can create a category interface
// (no implementation) on **MulleInvocationBuilder** with said method as a
// class method.
//
// Like so:
//
// ``` objc
// @interface MulleInvocationBuilder (Whatever)
// + (NSInvocation *) whatever:(float) x;
// @end
// ```
//
@interface MulleInvocationBuilder
@end


@implementation MulleInvocationBuilder

+ (void *) forward:(void *) param
{
   NSMethodSignature               *signature;
   NSInvocation                    *invocation;
   struct _mulle_objc_universe     *universe;
   struct _mulle_objc_descriptor   *desc;
   struct _mulle_objc_class        *cls;

   universe  = _mulle_objc_infraclass_get_universe( self);
   desc      = _mulle_objc_universe_lookup_descriptor( universe,
                                                       (mulle_objc_methodid_t) _cmd);
   if( ! desc)
   {
      cls = _mulle_objc_infraclass_as_class( self);
      mulle_objc_universe_fail_methodnotfound( universe, cls, (mulle_objc_methodid_t) _cmd);
      return( NULL);
   }

   signature  = [NSMethodSignature _signatureWithObjCTypes:desc->signature
                                            descriptorBits:desc->bits];
   if( ! signature)
   {
      __mulle_objc_universe_raise_internalinconsistency( universe,
                                                         "method is broken");
      return( NULL);
   }

   /*
    * Why not variadic ? The MetaABI doesn't care or ?
    * Well it does, because though everything is nicely contained in
    * _param, we have to copy _param into the invocation, but don't know
    * its size.
    */
   if( [signature isVariadic])
   {
      __mulle_objc_universe_raise_internalinconsistency( universe,
                                                         "variadic methods can \
not be forwarded using invocations");
      return( NULL);
   }

   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:_cmd];
   [invocation _setMetaABIFrame:param];
   return( invocation);
}

@end



@interface A : NSObject
@end

@implementation A

- (char *) name
{
   return( "A");
}

@end


@interface B : NSObject
@end

@implementation B

- (char *) name
{
   return( "B");
}

@end


@interface Foo : NSObject
@end


@implementation Foo

- (void) foo:(id) obj1 : (id) obj2 : (NSUInteger) i
{
   printf( "%td %s %s\n", i, [obj1 name], [obj2 name]);
}

- (void) bar:(id) obj1 : (id) obj2 : (NSUInteger) i  : (float) x : (char) y
{
   printf( "%td %s %s %g %c\n", i, [obj1 name], [obj2 name], x, y);
}

@end


@interface MulleInvocationBuilder( Foo)

+ (NSInvocation *) bar:(id) obj1 : (id) obj2 : (NSUInteger) i : (float) x : (char) y;

@end



int   main( void)
{
   A                    *a;
   B                    *b;
   Foo                  *foo;
   NSAutoreleasePool    *pool;
   NSInvocation         *invocation;

   foo  = [Foo object];
   a    = [A object];
   b    = [B object];

   // 1848 by default will produce an "int", but we need a NSUInteger here
   // solution a) cast on call
   invocation = [MulleInvocationBuilder foo:a :b :(NSUInteger) 1848];
   [invocation invokeWithTarget:foo];

   // solution b) have a category on MulleInvocationBuilder to pass here
   // with the proper size
   invocation = [MulleInvocationBuilder bar:a :b :1848 : 18.48 : 'V'];
   [invocation invokeWithTarget:foo];

   // general not so niceties:
   // return type of category is different
   // you usually have to change the method to be a class method, which is
   // somewhat obscure
   return( 0);
}
