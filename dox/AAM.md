# AAM Objective-C

* compile ARC code w/o having to edit the code (with special mulle-clang option `-fobjc-aam`)


```
@interface Foo
{
   NSObject  *_ivar;
}

@property id   other;

@end
```


### Rules

* AAM code can only access ivars via methods and properties


## alloc / new

`x = [Foo alloc];`

* in AAM means `[Foo instantiate]`

`x = [Foo new];`

* in AAM means `[[Foo instantiate] init]`


## retain/release/autorelease

* in AAM these are NOPs


# What about `+instantiate` ?

It is just a short hand way to write alloc/autorelease code in
non AAM mode, that will also work when compiled in AAM.  (It would also work in
ARC, when `+instantiate` is defined as `+alloc`).

* compiles to just `+alloc` in AAM mode (which is `+alloc` +  `-autorelease`)
* compiles to `+alloc` +  `-autorelease` in normal mode



