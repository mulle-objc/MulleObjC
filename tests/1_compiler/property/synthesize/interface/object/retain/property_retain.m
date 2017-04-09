#include <mulle_objc/mulle_objc.h>

#include <string.h>
#include <stdio.h>


@interface Foo
{
   char   _name[ 32];
}

@property( retain) Foo   *other;

+ (id) alloc;
- (id) initWithName:(char *) name;
- (void) print;

@end


@implementation Foo

+ (id) alloc
{
   return( mulle_objc_infraclass_alloc_instance( self, NULL));
}


- (id) initWithName:(char *) name
{
   strcpy( self->_name, name);
   return( self);
}


- (void) print
{
   printf( "%s (RC:%ld)\n", _name, mulle_objc_object_get_retaincount( self));
}


@end


main()
{
   Foo  *foo1;
   Foo  *foo2;

   foo1 = [[Foo alloc] initWithName:"foo1"];

   foo2 = [[Foo alloc] initWithName:"foo2"];

   [foo1 print];
   [foo2 print];

   [foo1 setOther:foo2];

   [foo1 print];
   [[foo1 other] print];
}
