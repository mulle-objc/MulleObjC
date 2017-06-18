#include <mulle_objc_runtime/mulle_objc_runtime.h>


@interface IloveCpp
@end


@implementation IloveCpp
@end



@interface Foo <__covariant IloveCpp>

- (IloveCpp) soExciting;

@end


@implementation Foo

- (id) soExciting
{
   return( [IloveCpp new]);
}

@end

