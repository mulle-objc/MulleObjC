# AAO mode

* compile ARC code w/o having to edit the code (with special mode --mulle-aao)
* compile regular code w/o having to edit it, not #ifdefs


@interface Foo
{
   NSObject  *_ivar;
}

@property id   other;

@end


### Rules

* AAO code can only access ivars via methods and properties


## alloc / new

x = [Foo alloc];

* means [Foo alloc]
* in AAO means [Foo instantiate]

x = [Foo new];

* means [[Foo alloc] init]
* in AAO means [[Foo instantiate] init]


## retain/release/autorelease

* in AAO these are NOPs


# What about +instantiate ?

It is just a short hand way to write alloc/autorelease code in
non AAO mode, that will also work when compiled in AAO.  (It would also work in
ARC, when instantiate is defined as +alloc).

* compiles to just +alloc in AAO mode, which is +alloc -autorelease
* compiles to +alloc autorelease in normal mode



