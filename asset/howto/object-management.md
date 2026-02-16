## Object management
<!-- Keywords: objc, leak, object, property, memory -->

There are three distinct phases in an object lifecycle: birth, life, death.


## Birth

### +instance

You create objects by calling `+instance`. This will return an autoreleased
object. Also fine are factory methods like +stringWithUTF8String: which also
produce autoreleased object. Try to avoid `+alloc`/`-init`/`-autorelease` code.
Remember if you have to call `+alloc`/`-init` you also must call `-autorelease`.

### -init

Birth is a special time with different time semantics than life. The only
code that should run during the birth of an object is an "init" method.
Inside the init method, you try to AVOID calling autorelease and factory
methods. You also must not start any threads in init.

## Life

This is the normal state, where you message objects. You will not manually
`-release` the instance. You will not `-autorelease` the instance, as it is
already autoreleased.

If another object needs a reference to yours, it should use a `@property( retain)`
to manage it.


## Death

### -finalize

Finalize puts the object into a limbo state. Here it is expected that "heavy"
resources, like file descriptors are closed. The object will still be
messagable but is already fairly useless. The default implementation of
NSObject will write zero to all properties with the exception of `readonly`
properties, thus effectively autoreleasing them:

``` bash
- (void) finalize
{
   _MulleObjCInstanceClearProperties( self, NO);
}
```

Do not call `-release` but do use `-autorelease` during `-finalize`.


### -dealloc

This will eventually free the object. It's your task to clean up any
instance variables, that are not backed by properties. Do not call
`-autorelease` but do use `-release` during `-dealloc`. This is the opposite
of `-finalize`

