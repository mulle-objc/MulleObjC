##  NSAutoreleasePool

Here are rules that, when you play by them, make everything easy. 
(The implied scope is the current function or method.)

1. Every allocated object is placed into an autorelease pool. You need to do 
this step manually, for now, with +alloc/-init/-autorelease or one of the 
convenience constructors. This rule implies that there is always an enclosing 
autorelease pool. 

> The runtime keeps track of all ObjC objects (directly or implicitly). In times 
of need, all objects can be found and wiped away. There are no "free" root
objects.

2. **set** accessors retain or copy their arguments, and autorelease the old 
values. **get** accessors just return the object. You only `-release` those 
references during `-dealloc`. Otherwise you `-autorelease`.

> The result of this is, that the expected lifetime of a returned object is 
always the enclosing autoreleasepool. Not more not less. An object does not just 
vanish.

3. Extend the lifetime of an object in an autoreleasepool by moving it into the
parent autoreleasepool like so:

   [obj retain];
   [pool autorelease];
   [obj autorelease];

> You may need to do this for performance reasons, when a new nested 
autoreleasepool improves memory usage.


## Staying in control

> "I had control... and that's what it all comes down to" -- G. Ridgway

Wrapping code in autoreleasepools to get deterministic deallocation of a 
temporary object. This would work, when -doesImportantStuff does not lead to a 
`retain` of `p`:

~~~
    @autoreleasepool
    {
        p = [[MaybeAWindow new] autorelease];
        [p doSomeImportantStuff];
    }
~~~

But that is sometimes hard to guarantee. The solution to this problem is to
`-finalize`, which is described in the runtime.



