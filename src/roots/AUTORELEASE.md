##  AutoreleasePools

Here are rules that, when you play by them, make everything easy. 
(The implied scope is the current function or method.)

1. Every allocated object is placed into an autorelease pool. You need to do 
this step manually, for now, with +alloc/-init/-autorelease or one of the 
convenience constructors. This rule implies that there is always an enclosing 
autorelease pool. 

> All ObjC objects are kept track off (directly or implicitly). In times of 
need, all objects can be found and wiped away. There are no multiple "roots".

2. Set accessors retain or copy their arguments, and autorelease the old values. 
Get accessors just return the object. You only ever call release on those 
references during -dealloc. Otherwise you autorelease.

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


----

## Death of an idiom, birth of a new rule

This idiom is now invalid...

~~~ 
    obj = [Foo new];
    [array addObject:obj];
    [obj release];
~~~

The improved solution is a new methods for collections, which does not retain 
its argument. Consequently `obj` need and must not be released afterwards. Which 
makes this code optimal. 

~~~
    obj = [Foo new];
    [array addRetainedObject:obj];
~~~

Unfortunately by our definition #1 this is not allowable. The solution is to 
modify #1.

1.1 An object may not need to be autoreleased, if ownership is passed 
    explicitily to another object (within local scope). The receiving object 
    must either store a reference to this object (#2) or autorelease it.



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

But that is sometimes hard to guarantee. The solution to this problem is 
`finalize`, which is described in the runtime.
