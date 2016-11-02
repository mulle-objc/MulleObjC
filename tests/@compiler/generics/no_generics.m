#include <mulle_objc/mulle_objc.h>


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

