# Accessor Patterns and Memory Management
<!-- Keywords: objc, leak, object, property, ivar, memory -->

## Retain property setter pattern

```objective-c
- (void) setObject:(Type *) object
{
   [_object autorelease];
   _object = [object retain];
}
```

This works for replacing, clearing, or reassigning the same object.

## Lazy getter pattern

```objective-c
- (Type *) object
{
   if( _object)
      return( _object);

   _object = [[Type alloc] initWithFrame:...];
   return( _object);
}
```

Do not autorelease here.

## Lifecycle summary

- init: use `alloc/init`, avoid autorelease
- finalize: autorelease and nil out heavy resources
- dealloc: release non-property ivars
