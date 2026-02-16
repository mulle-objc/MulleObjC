# Accessor Patterns and Memory Management
<!-- Keywords: objc, leak, object, property, ivar, memory -->

## Property Accessors

### Retain Properties

For a property declared as `@property( retain) Type *object;`:

#### Setter Pattern

The setter must autorelease the old value and retain the new value:

```objective-c
- (void) setObject:(Type *) object
{
   [_object autorelease];
   _object = [object retain];
}
```

This pattern ensures:

- The old object is autoreleased (not immediately freed)
- The new object is retained (ownership taken)
- Works correctly even if `object == _object` (same object)
- Works correctly if `object == nil` (clearing the property)

#### Getter Pattern (Simple)

```objective-c
- (Type *) object
{
   return( _object);
}
```

#### Getter Pattern (Lazy Initialization)

When lazily creating an object in a getter, use `+alloc`/`-init` and assign directly to the ivar:

```objective-c
- (Type *) object
{
   if( _object)
      return( _object);

   _object = [[Type alloc] initWithFrame:...];
   // ... configure _object ...

   return( _object);
}
```

**Important:** Do NOT call `-autorelease` here!

**Why this works:**

- The ivar is known to be nil (checked by the `if`)
- `+alloc`/`-init` creates an object with retain count 1
- Direct assignment to ivar takes ownership
- When the property is later cleared via the setter, the setter will autorelease it
- When the object is deallocated, `-dealloc` or `-finalize` will handle cleanup

**This is NOT the same as:**
```objective-c
// WRONG - double retain!
[self setObject:[[Type alloc] init]];  // leaks - alloc gives +1, setter retains to +2

// WRONG - will be deallocated immediately!
_object = [[[Type alloc] init] autorelease];  // object might be freed too early
```

### Copy Properties

For `@property( copy)`, the setter uses `-copy` instead of `-retain`:

```objective-c
- (void) setTitle:(NSString *) title
{
   [_title autorelease];
   _title = [title copy];
}
```

### Assign Properties

For `@property( assign)` (weak references), no retain/release:

```objective-c
- (void) setDelegate:(id) delegate
{
   _delegate = delegate;
}
```

## Instance Variable Management in -init

Inside `-init` methods, avoid factory methods and autorelease:

```objective-c
- (instancetype) init
{
   self = [super init];
   if( self)
   {
      // Direct alloc/init is fine here
      _object = [[Type alloc] init];

      // Do NOT use autorelease
      // Do NOT use factory methods like [Type instance]
   }
   return( self);
}
```

## Instance Variable Management in -finalize

In `-finalize`, use `-autorelease` for non-property ivars and set them to nil:

```objective-c
- (void) finalize
{
   [_object autorelease];
   _object = nil;

   [super finalize];
}
```

## Instance Variable Management in -dealloc

In `-dealloc`, use `-release` for non-property ivars:

```objective-c
- (void) dealloc
{
   [_object release];

   [super dealloc];
}
```

For property-backed ivars, the properties should already be cleared by `-finalize`.

## Summary

- **Lazy getter with retain property**: Use `[[Type alloc] init]` and assign to ivar directly
- **Setter for retain property**: `[_ivar autorelease]; _ivar = [param retain];`
- **Init method**: Use `+alloc`/`-init`, avoid `-autorelease` and factory methods
- **Finalize method**: Use `-autorelease` and set to `nil`, never use `-release`
- **Dealloc method**: Use `-release`, never use `-autorelease`
- **Normal code**: Use `+instance` or factory methods, never manually manage retain/release

