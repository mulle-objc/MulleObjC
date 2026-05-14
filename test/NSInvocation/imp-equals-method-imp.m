#import <MulleObjC/MulleObjC.h>

@interface FooImp : NSObject
@end

@implementation FooImp

- (id) greet:(id)name
{
   return( name);
}

@end

int main(void)
{
   FooImp        *foo;
   NSInvocation  *inv;
   IMP           imp;
   id            ret;
   NSObject      *payload;

   foo = [FooImp new];
   payload = [NSObject new];

   inv = [NSInvocation mulleInvocationWithTarget:foo
                                       selector:@selector(greet:)
                                         object:payload];
   imp = [foo methodForSelector:@selector(greet:)];
   [inv setImplementation:imp];

   [inv invoke];

   ret = nil;
   [inv getReturnValue:&ret];
   if( ret != payload )
   {
      printf("IMP_EQUALS_METHOD_FAIL\n");
      [payload release];
      [foo release];
      return( 1);
   }

   printf("IMP_EQUALS_METHOD_OK\n");
   [payload release];
   [foo release];
   return( 0);
}
