#include <mulle_objc/mulle_objc.h>


// no support for the package keyword
@interface Foo
{
@package
	int  foo;
}
@end


main()
{
   return( 0);
}
