## Object management
<!-- Keywords: objc, leak, object, property, memory -->

There are three phases in an object lifecycle: birth, life, death.

## Birth

Prefer `+instance` or factory methods that return autoreleased objects.
Inside `-init`, avoid starting threads and avoid autorelease-heavy flows.

## Life

Use the object normally. Other owners should hold it through retain properties.

## Death

### `-finalize`

Release heavy resources with autorelease-style cleanup and let properties be
cleared.

### `-dealloc`

Release non-property ivars and call `[super dealloc]`.
