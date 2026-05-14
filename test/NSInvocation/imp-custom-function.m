#import <MulleObjC/MulleObjC.h>

static id custom_imp(id self, SEL _cmd, id arg)
{
   return( arg );
}

@interface FooImp2 : NSObject
@end

@implementation FooImp2
- (id) greet:(id)name
{
   return( name);
}
@end

int main(void)
{
   FooImp2       *foo;
   NSInvocation  *inv;
   id            ret;
   NSObject      *payload;

   foo = [FooImp2 new];
   payload = [NSObject new];

   inv = [NSInvocation mulleInvocationWithTarget:foo
                                       selector:@selector(greet:)
                                   implementation:(IMP)custom_imp
                                          object:payload];

   [inv invoke];

   ret = nil;
   [inv getReturnValue:&ret];
   if( ret != payload )
   {
      printf("IMPFUNC_FAIL\n");
      [payload release];
      [foo release];
      return( 1);
   }

   printf("IMPFUNC_OK\n");
   [payload release];
   [foo release];
   return( 0);
}
