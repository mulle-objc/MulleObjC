# Class Properties in mulle-objc (mulle-clang 22+)

Keywords: class property, class properties, classproperty, classpropertylock,
          lock, unlock, thread safe, shared state, registry, singleton

## Reality check

As of mulle-clang 22.1.2, `@property (class, ...)` is **fully implemented**.
The compiler synthesizes locked accessors and stores ivars in the classpair
allocation. Use class properties for class-level state — not plain C statics
with manual getter/setter methods.

## What gets synthesized

```objc
@interface Foo : NSObject
@property (class, assign) int sharedCount;
@end

@implementation Foo
@end
```

The compiler synthesizes a locked getter and setter — you do NOT write these:

```objc
+ (int) sharedCount
{
   mulle_objc_infraclass_lock_classproperty( self);
   int v = self->_sharedCount;
   mulle_objc_infraclass_unlock_classproperty( self);
   return( v);
}

+ (void) setSharedCount:(int) value
{
   mulle_objc_infraclass_lock_classproperty( self);
   self->_sharedCount = value;
   mulle_objc_infraclass_unlock_classproperty( self);
}
```

Storage lives in the classpair allocation — zeroed at creation, cleared at
teardown. No file-static, no global, no manual lifecycle.

## Accessing self->_field in + methods

In `+` methods `self` is typed as the infraclass struct, so `self->_field`
works directly. Wrap manual ivar access with `[self lock]`/`[self unlock]`:

```objc
+ (void) increment
{
   [self lock];
   self->_sharedCount++;
   [self unlock];
}
```

Or just use the synthesized accessor — the mutex is recursive so re-entry
from within a lock is safe:

```objc
+ (void) reset
{
   [self setSharedCount:0];
}
```

## Compound operations — +lock / +unlock / +tryLock

`NSObject` provides `+lock` / `+unlock` / `+tryLock` inherited by all classes
(implemented in `MulleObjCRootObject.m`). The mutex is recursive so
synthesized accessors re-enter safely:

```objc
+ (void) resetAll
{
   [self lock];
   [self setSharedCount:0];
   [self setSharedName:nil];
   [self unlock];
}
```

## Category class properties — must be dynamic

Categories cannot add ivars. Declare `dynamic` and implement accessors
manually using `[self lock]`/`[self unlock]`:

```objc
// Foo+Extra.h
@interface Foo (Extra)
@property (class, dynamic, assign) BOOL loggingEnabled;
@end

// Foo+Extra.m
@implementation Foo (Extra)
static BOOL   _loggingEnabled;   // shared: all subclasses that don't override

+ (BOOL) loggingEnabled
{
   BOOL   v;

   [self lock];
   v = _loggingEnabled;
   [self unlock];
   return( v);
}

+ (void) setLoggingEnabled:(BOOL) flag
{
   [self lock];
   _loggingEnabled = flag;
   [self unlock];
}

@end
```

The file-static is compile-time bound to `Foo+Extra.m` — so `[Bear loggingEnabled]`
reads the same variable as `[Foo loggingEnabled]` unless Bear overrides the
accessor with its own static.

**The classpropertylock is only initialized if the class (or one of its
categories) has at least one non-dynamic `@property (class, ...)` declaration.**
If the class only has dynamic category properties, add a dummy class property
to activate the lock:

```objc
@interface Foo (Extra)
@property (class, assign) char _lockActivator;   // never used, activates mutex
@property (class, dynamic, assign) BOOL loggingEnabled;
@end
```

## Inheritance

Each class gets **independent storage**. `[Animal population]` and
`[Bear population]` are different memory locations (different classpairs)
at the same offset. `self` in `+` methods is the receiver's infraclass —
so `[Bear new]` calling `Animal`'s `+new` touches Bear's `_population`.

For **shared-hierarchy** state (one value for all subclasses), use a category
dynamic property backed by a file-static (see above).

## Registry pattern

Use `mulle_map` for name→object registries, or `NSMutableDictionary` if
Foundation is available. Store the map/dictionary pointer as a `readonly`
class property so the classpair ivar and classpropertylock are allocated.
**Poison the synthesized getter** so callers can't get the raw pointer and
use it outside the lock — all access must go through the locked methods.

```objc
// MyPreset.h
@interface MyPreset : NSObject

// ivar + lock allocated by runtime; getter poisoned — use +presetNamed: instead
@property (class, readonly) struct mulle_map *presetMap  __attribute__((unavailable));

+ (void) registerPreset:(MyPreset *) preset withName:(char *) name;
+ (MyPreset *) presetNamed:(char *) name;

@end


// MyPreset.m
@implementation MyPreset

// Alternatively, skip __attribute__((unavailable)) on the declaration and
// poison at runtime by overriding the synthesized getter with abort():
//
// + (struct mulle_map *) presetMap { abort(); }

+ (void) initialize
{
   struct mulle_map   *map;

   map = mulle_malloc( sizeof( struct mulle_map));
   mulle_map_init( map,
                   0,
                   &mulle_container_keycallback_nonowned_cstring,
                   &mulle_container_valuecallback_nonowned_pointer,
                   NULL);
   self->_presetMap = map;
}


+ (void) deinitialize
{
   if( self->_presetMap)
   {
      mulle_map_done( self->_presetMap);
      mulle_free( self->_presetMap);
      self->_presetMap = NULL;
   }
}


+ (void) registerPreset:(MyPreset *) preset
               withName:(char *) name
{
   // only called from +load — single-threaded, +initialize already ran
   [preset retain];
   mulle_map_set( self->_presetMap, name, preset);
}


+ (MyPreset *) presetNamed:(char *) name
{
   MyPreset   *result;

   [self lock];
   result = mulle_map_get( self->_presetMap, name);
   [self unlock];
   return( result);
}

@end
```

The map pointer is never safely reachable from outside. All access goes
through the locked methods. `+initialize`/`+deinitialize` access
`self->_presetMap` directly — safe since they run single-threaded.

When Foundation is available, `NSMutableDictionary` works just as well and
is often simpler:

```objc
@interface MyPreset : NSObject
@property (class, readonly) NSMutableDictionary *presetDict  __attribute__((unavailable));
+ (void) registerPreset:(MyPreset *) preset withName:(char *) name;
+ (MyPreset *) presetNamed:(char *) name;
@end

@implementation MyPreset

+ (void) initialize
{
   self->_presetDict = [NSMutableDictionary new];
}

+ (void) deinitialize
{
   [self->_presetDict release];
   self->_presetDict = nil;
}

+ (void) registerPreset:(MyPreset *) preset
               withName:(char *) name
{
   // only called from +load — single-threaded
   [self->_presetDict setObject:preset
                         forKey:[NSString stringWithUTF8String:name]];
}

+ (MyPreset *) presetNamed:(char *) name
{
   MyPreset   *result;

   [self lock];
   result = [self->_presetDict objectForKey:[NSString stringWithUTF8String:name]];
   [self unlock];
   return( result);
}

@end
```

## TAO and class methods

Class objects have `thread_id == 0` (no thread affinity). The TAO check
exits immediately for any call on a class object. Class methods are callable
from any thread without TAO issues.

Instance objects accessed from a thread other than the one that created them
need `< MulleObjCThreadSafe>` conformance (e.g. shared presets, singletons).

## What NOT to do

- Do not use plain C statics + manual getter/setter class methods as a
  replacement for class properties — you lose locking and lifecycle.
- Do not call `[self lock]` on a class that has no non-dynamic
  `@property (class, ...)` declaration — the mutex is dormant (depth = -1)
  and the call will crash.
- Do not use `atomic` — not supported in mulle-objc.
- Do not declare class properties in `@implementation` only — must be in
  `@interface`.
