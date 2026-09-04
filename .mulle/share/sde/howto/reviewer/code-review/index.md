# Code Review Checklist

<!-- Keywords: reviewer, code-review, objc, checklist -->

## 1. Avoid duplicate method calls — use a local variable

Repeating the same message send in multiple branches is wasteful and noisy.
Compute the value once, then use it.

**Bad:**
```objc
if( x)
   [foo doSomethingWith: a];
else
   [foo doSomethingWith: b];
```

**Good:**
```objc
id  value;

value = x ? a : b;
[foo doSomethingWith: value];
```

**Why:** Each message send has dispatch overhead. Caching
avoids redundant lookups and makes the single call site obvious.

## 2. Avoid nesting message sends — cache intermediate results

Chained message sends worsen readability and debugging. Assign each
intermediate result to a local variable.

**Bad:**
```objc
result = [[[foo bar] baz] qux];
```

**Good:**
```objc
id  bar;
id  baz;

bar = [foo bar];
baz = [bar baz];
result = [baz qux];
```

This also applies to `alloc`/`init`/`autorelease` chains — split into
separate lines so each step is debuggable:

**Bad:**
```objc
foo = [[[Foo alloc] init] autorelease];
```

**Good:**
```objc
Foo   *foo;

foo = [Foo alloc];
foo = [foo init];
foo = [foo autorelease];
```

**Why:** When a crash lands on a chained expression you can't tell which
message failed. Split lines give you a proper call stack and let you
inspect each step.

## 3. Avoid superfluous casts — use `MULLE_OBJC_CLASS_CAST` when you must

Plain C casts from `id` to a concrete type bypass runtime type checking.
Use `MULLE_OBJC_CLASS_CAST` or `MULLE_OBJC_CLASS_CAST_OR_NIL` to assert
the object is actually the expected class.

**Bad:**
```objc
UIWindow   *window;

window = (UIWindow *) [self object];
```

**Good:**
```objc
UIWindow   *window;

window = MULLE_OBJC_CLASS_CAST_OR_NIL( UIWindow, [self object]);
```

**Why:** A raw cast hides bugs — if `[self object]` returns something else,
you get a cryptic crash later. `MULLE_OBJC_CLASS_CAST` asserts the class at
runtime via `isKindOfClass:`, catching the mismatch early. Use
`MULLE_OBJC_CLASS_CAST_OR_NIL` when `nil` is a valid outcome.

## 4. No manual memory management in user code

Outside of `-init`, `-dealloc`, `-finalize`, and property accessor overrides,
user code must not use `new`, `copy`, `retain`, `release`, or `autorelease`.
Rely on properties and factory methods instead.

Allowed patterns by location:
- **`+factory` methods:** `alloc`/`init`/`autorelease` are OK — this is
  plumbing, not user-facing code. Example:

  ```objc
  + (instancetype) viewWithLayer:(id <UILayer>) layer
  {
     UIView  *obj;

     obj = [self alloc];
     obj = [obj initWithLayer:layer];
     obj = [obj autorelease];
     return( obj);
  }
  ```
- **Property accessor override:** `autorelease` is OK (the setter owns the
  incoming value). This is the only place you autorelease outside of
  factory methods.
- **`-dealloc`:** `release` is OK. This is the only place you release.
- **`-finalize`:** `autorelease` and nil out ivars (mandatory).
- **Everywhere else:** none of the above.

**Bad:**
```objc
Foo   *a;

a = [Foo new];
[array addObject:a];
[a release];
```

**Good:**
```objc
Foo   *a;

a = [Foo instance];
[array addObject:a];
// no release needed — +instance returns an autoreleased object
```

Or via a property that retains:

```objc
self.children = [Foo instance];
// setter handles the retain
```

**Why:** Manual retain/release in user code is a source of leaks and
crashes. Properties encapsualate the memory management policy. The
styleguide covers this in "Objective-C Specific / General coding style" and
"Properties".

## 5. Don't guard against `nil` on message sends — messaging `nil` is harmless

Objective-C silently ignores messages to `nil` and returns
`0` / `0.0` / `nil` / `NO` as appropriate. Testing for `nil` before
every message is noisy and unnecessary.

**Bad:**
```objc
if( a)
   [a doSomething];
```

**Good:**
```objc
[a doSomething];
```

An even more obvious smell is when both branches message the same
object anyway:

**Bad:**
```objc
if( a)
   return [a doSomething];
else
   return nil;
```

**Good:**
```objc
return( [a doSomething]);
```

since messaging `nil` returns `nil`.

**Why:** Nil-guarding adds visual noise without safety. The runtime
handles `nil` receivers at the dispatch level — no crash, no undefined
behavior. Reserve nil checks for the rare case where the return value
matters (e.g., distinguishing "no value" from an actual result).

## 6. Avoid mutable `static` variables — use class properties

`static` variables with mutable state introduce hidden state that tests
cannot easily reset, break isolation, and complicate threading. Prefer
class properties declared in the `@interface` instead.

**Exception — compile-time constants are fine:**
```objc
static NSString   *foo = @"whatever";
```
These are immutable and harmless.

**Bad (mutable static):**
```objc
static Foo  *shared;

@implementation Bar

+ (Foo *) sharedFoo
{
   if( ! shared)
      shared = [Foo instance];
   return( shared);
}
```

**Good:**
```objc
@interface Bar
@property( class, readonly) Foo   *sharedFoo;
@end
```

**Why:** Class properties are visible in the API, participate in
runtime introspection, and can be mocked in tests. `static` variables
with mutable state are invisible, persist across test boundaries, and
introduce global state that other code cannot observe or reset.

## 7. Methods with more than five parameters — extract into a context struct

Long parameter lists are hard to read and harder to call correctly.
When many parameters are passed en bloc to another method, wrap them
in a context or info struct and pass that by reference.

**Bad:**
```objc
- (void) configureWithName:(NSString *) name
                     color:(NSColor *) color
                      font:(NSFont *) font
                     align:(NSTextAlignment) align
                     width:(CGFloat) width
                    height:(CGFloat) height
                   visible:(BOOL) visible;
```

**Good:**
```objc
struct ConfigInfo
{
   NSString         *name;
   NSColor          *color;
   NSFont           *font;
   NSTextAlignment  align;
   CGFloat          width;
   CGFloat          height;
   BOOL             visible;
};

- (void) configureWithInfo:(struct ConfigInfo *) info;
```

And call it with a compound literal — zero-initialization is free:

```objc
info = (struct ConfigInfo)
{
   .name    = @"Hello",
   .visible = YES
};
[self configureWithInfo:&info];
```

Fields not listed are zero-initialized automatically (`nil` for
pointers, `0` for scalars, `NO` for bools) — no need to set them
explicitly.

**Why:** A struct groups related data into a single unit, simplifies
the call site, makes it easy to add/remove fields without changing
every caller, and the parameters are still available in a debugger
when passed by pointer.
