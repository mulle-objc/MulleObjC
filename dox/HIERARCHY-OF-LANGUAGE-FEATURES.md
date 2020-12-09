


Language Feature            | Danger
----------------------------|------------------------
@autoreleasepool            | Zombie scope and retain problems
@defs                       | as @public
@encode                     | Is a C pointer
@public                     | Unintentional corruption. Change of one variable only, where two are required (e.g. cached count)
@try @catch                 | Control flow problem with locks etc.
C integer datatypes         | Problem with [NSArray array] not being able to return 0, as [array indexOfObjectIdenticalTo:foo] differs
C pointers                  | Corruption by bad code
Copying C structs           | Problem with objects contained within
retain/release/autorelease  | Easy to make mistakes


Can we mix and match ? Can you link with unmatchec code ?


Mode 0:
=======

Can do anything

Mode 1:
=======
   No retain/release/autorelease
   No @autoreleasepool

Mode 2:
=======
   C pointers
   Copying C structs
   C integer datatypes