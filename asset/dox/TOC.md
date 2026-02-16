# MulleObjC Library Documentation for AI
<!-- Keywords: foundation, objective-c -->

## 1. Introduction & Purpose

**MulleObjC** is the foundational Objective-C library for the mulle-sde ecosystem. It provides the complete set of root classes (NSObject, NSProxy), core protocols (NSCoding, NSCopying, NSFastEnumeration, NSLocking), threading support (NSThread), memory management (NSAutoreleasePool), and essential utilities for dynamic Objective-C programming on top of the mulle-objc runtime.

**Key Features:**
- Complete Objective-C root class hierarchy
- Method serialization (NSInvocation, NSMethodSignature)
- Thread support with platform abstraction
- Exception handling integration
- Autorelease pool management
- Dynamic type introspection utilities
- Lock and synchronization primitives
- Zero C standard library dependencies (portable)

## 2. Key Concepts & Design Philosophy

- **Two Root Classes**: NSObject (standard) and NSProxy (for dynamic forwarding/proxies)
- **Memory Model**: Retain/release counting with NSAutoreleasePool for batch deallocation
- **Protocol-Based Design**: Protocols (NSCoding, NSCopying, etc.) enable optional features without base class bloat
- **C-Only Core**: MulleObjC minimally depends on mulle-objc-runtime C library, not standard C libraries
- **Introspection-First**: Full access to method metadata and dynamic dispatch mechanisms
- **Exception Safety**: Integration with mulle-objc exception handling via @try/@catch/@finally

## 3. Core API & Data Structures

### 3.1 Root Classes: NSObject & NSProxy

#### NSObject - The Standard Root Class

**Purpose**: Root class for all objects in typical Objective-C hierarchies. Provides lifecycle, reference counting, memory management, and introspection.

**Lifecycle Methods:**
- `+ (id)alloc` → Creates uninitialized instance (returns autoreleased in some contexts)
- `- (id)init` → Designated initializer, must be overridden in subclasses
- `- (void)dealloc` → Destructor, called when retain count reaches zero
- `+ (id)new` → Shortcut: `[[class alloc] init]`

**Reference Counting:**
- `- (id)retain` → Increment reference count, return self
- `- (void)release` → Decrement reference count; deallocate if zero
- `- (id)autorelease` → Add to current NSAutoreleasePool, released at pool drain
- `- (NSUInteger)retainCount` → Get current reference count

**Introspection & Method Dispatch:**
- `- (Class)class` → Get object's class (compile-time or runtime)
- `- (Class)superclass` → Get superclass
- `- (BOOL)isKindOfClass:(Class)cls` → Check if object is instance of class or subclass
- `- (BOOL)isMemberOfClass:(Class)cls` → Check exact class match
- `- (BOOL)respondsToSelector:(SEL)selector` → Query if selector exists
- `- (id)performSelector:(SEL)selector` → Dynamically invoke with no args
- `- (id)performSelector:(SEL)selector withObject:(id)arg` → With one object argument
- `- (BOOL)conformsToProtocol:(Protocol *)proto` → Check protocol conformance

**Object Comparison & Hashing:**
- `- (BOOL)isEqual:(id)other` → Default: pointer equality
- `- (NSUInteger)hash` → Hash for use in collections
- `- (NSString *)description` → Human-readable string (default: class name + pointer)

**Copy & Archive Support:**
- `- (id)copy` → Shallow copy, requires NSCopying protocol
- `- (id)mutableCopy` → Mutable copy, requires NSMutableCopying protocol
- `- (void)encodeWithCoder:(NSCoder *)coder` → Serialization support (NSCoding protocol)
- `- (id)initWithCoder:(NSCoder *)coder` → Deserialization support

#### NSProxy - Alternative Root for Dynamic Proxies

**Purpose**: Unlike NSObject, NSProxy does *not* conform to NSObject protocol, enabling pure forwarding proxies.

**Key Methods:**
- `+ (id)alloc` → Create proxy
- `- (void)dealloc` → Cleanup
- `- (void)forwardInvocation:(NSInvocation *)inv` → Override to handle unknown messages
- `- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector` → Provide signature for forwarded message

**Usage Pattern**: Use NSProxy for transparent message forwarding (e.g., remote object proxies, lazy-loading wrappers)

### 3.2 Method Serialization & Introspection

#### NSInvocation - Message Recording & Replay

**Purpose**: Serialize a message send into an object, modify it, and replay.

**Creation:**
- `+ (NSInvocation *)invocationWithMethodSignature:(NSMethodSignature *)sig` → Create with signature
- `- (NSMethodSignature *)methodSignature` → Get associated signature

**Configuration:**
- `- (void)setTarget:(id)target` → Object to receive message
- `- (void)setSelector:(SEL)selector` → Selector to invoke
- `- (void)setArgument:(void *)arg atIndex:(NSInteger)idx` → Set argument by index (0=return value, 1+=args)
- `- (void)getArgument:(void *)arg atIndex:(NSInteger)idx` → Retrieve argument by index

**Execution:**
- `- (void)invoke` → Send serialized message to target
- `- (void)invokeWithTarget:(id)target` → Override target for this invocation

**Accessors:**
- `- (id)target` → Get target
- `- (SEL)selector` → Get selector
- `- (id)returnValue` → Get serialized return value (after invoke)

#### NSMethodSignature - Method Metadata

**Purpose**: Describes method signature: argument types, return type, etc.

**Creation:**
- `+ (NSMethodSignature *)signatureWithObjCTypes:(const char *)types` → From encoded type string (e.g., "v@:")
- `- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector` → Get from object/class (via NSObject)

**Accessors:**
- `- (NSUInteger)numberOfArguments` → Count of arguments (includes self, selector)
- `- (const char *)getArgumentTypeAtIndex:(NSUInteger)idx` → Encoded type of arg (e.g., "@", "i", "v")
- `- (const char *)methodReturnType` → Encoded return type
- `- (NSUInteger)frameLength` → Stack frame size needed for arguments

**Encoded Types**: e.g., "v@:" = void(self, selector), "i@:@" = int(self, selector, object)

### 3.3 Synchronization Primitives

#### NSLock - Basic Mutual Exclusion

**Purpose**: Simple lock for mutual exclusion.

**Methods:**
- `- (BOOL)lock` → Wait for and acquire lock
- `- (BOOL)tryLock` → Non-blocking acquire, return YES if successful
- `- (void)unlock` → Release lock
- `- (NSString *)name` → Lock identifier

#### NSRecursiveLock - Reentrant Lock

**Purpose**: Lock that same thread can acquire multiple times.

**Methods:**
- `- (BOOL)lock` → Acquire (blocks other threads even if same thread)
- `- (BOOL)tryLock` → Non-blocking acquire
- `- (void)unlock` → Release

#### NSCondition - Wait/Signal with Lock

**Purpose**: Condition variable for thread coordination.

**Methods:**
- `- (void)wait` → Release lock, wait for signal, reacquire lock
- `- (BOOL)waitUntilDate:(NSDate *)limit` → Wait with timeout
- `- (void)signal` → Wake one waiting thread
- `- (void)broadcast` → Wake all waiting threads
- `- (void)lock` / `- (void)unlock` → Underlying lock operations

#### NSConditionLock - Condition + Integer State

**Purpose**: Condition variable with associated condition value.

**Methods:**
- `- (void)lockWhenCondition:(int)condition` → Acquire when condition matches
- `- (BOOL)tryLockWhenCondition:(int)condition` → Non-blocking version
- `- (void)unlockWithCondition:(int)condition` → Release and set new condition
- `- (int)condition` → Current condition value

### 3.4 Threading

#### NSThread - Platform-Abstracted Thread Control

**Purpose**: Portable thread abstraction; work with mulle-c-threads.

**Class Methods:**
- `+ (NSThread *)currentThread` → Get running thread
- `+ (void)sleepForTimeInterval:(NSTimeInterval)duration` → Sleep current thread
- `+ (BOOL)isMainThread` → Check if in main thread
- `+ (NSThread *)mainThread` → Get main thread

**Instance Methods:**
- `- (id)initWithTarget:(id)target selector:(SEL)sel object:(id)arg` → Create thread
- `- (void)start` → Begin thread execution
- `- (BOOL)isExecuting` → Thread is running
- `- (BOOL)isFinished` → Thread finished
- `- (NSString *)name` → Thread identifier
- `- (void)setName:(NSString *)name` → Set identifier

### 3.5 Autorelease Pool Management

#### NSAutoreleasePool - Deferred Memory Release

**Purpose**: Batch memory management—objects added to pool released at pool drain.

**Methods:**
- `+ (NSAutoreleasePool *)currentPool` → Top of pool stack
- `- (id)init` → Create and push pool
- `- (void)dealloc` → Pop and drain pool (release all contained objects)
- `- (void)drain` → Explicit drain (alternative to dealloc)
- `- (void)addObject:(id)obj` → Manually add object to pool

**Macros (mulle-sde convention):**
- `@autoreleasepool { ... }` → Create pool scope, auto-drain at end

### 3.6 Core Protocols

#### NSCoding - Object Serialization

**Purpose**: Enable objects to serialize and deserialize.

**Methods:**
- `- (void)encodeWithCoder:(NSCoder *)coder` → Write object state
- `- (id)initWithCoder:(NSCoder *)coder` → Reconstruct from coder

#### NSCopying & NSMutableCopying - Copying

**Purpose**: Support shallow/deep copying.

**Methods:**
- `- (id)copy` → Return copy (implement NSCopying)
- `- (id)mutableCopy` → Return mutable copy (implement NSMutableCopying)

#### NSFastEnumeration - for-in Loop Support

**Purpose**: Enable `for (Type *obj in collection) { ... }` syntax.

**Methods:**
- `- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len`
  - Returns count of objects in this batch; updates state; called repeatedly until returns 0

#### NSLocking - Lock Protocol

**Purpose**: Unify lock interfaces.

**Methods:**
- `- (void)lock`
- `- (void)unlock`

#### NSObjectProtocol (Informal Protocol)

**Purpose**: Expected methods on NSObject; not formally declared.

**Key Methods:**
- `- (NSString *)description`
- `- (BOOL)isEqual:(id)other`
- `- (NSUInteger)hash`

### 3.7 Utility Protocols

#### NSCopyingWithAllocator - Advanced Copying

**Purpose**: Specify allocator for copy (rarely used).

**Methods:**
- `- (id)copyWithAllocator:(NSZone *)zone`

#### MulleObjCRuntimeObject (Informal Protocol)

**Purpose**: Minimal object contract for mulle-objc runtime.

**Implies**: Has `isa` pointer, supports `-class`, `-retain`/`-release`.

#### MulleObjCClassCluster - Class Factory Pattern

**Purpose**: Implement class clusters (e.g., NSString returns different subclasses).

**Methods:** None; used as marker for cluster implementation.

#### MulleObjCException - Exception Object Marker

**Purpose**: Marks object as exception-compatible (for @throw/@catch).

**Methods:** None; used by runtime for exception unwinding.

#### MulleObjCSingleton - Singleton Pattern

**Purpose**: Mark class for singleton instance management.

**Methods:** None; enables runtime singleton support.

#### MulleObjCTaggedPointer - Inline Integer Objects

**Purpose**: Encode small integers directly in pointer for efficiency.

**Methods:** None; runtime optimization.

### 3.8 Utility Functions & Macros

#### Allocation & Type Checking

- `id objc_calloc(size_t count, size_t size)` → Allocate zeroed memory for object components
- `NSUInteger class_instanceSize(Class cls)` → Size of class instance
- `BOOL class_isMetaClass(Class cls)` → Check if class is metaclass

#### Debug & Introspection

- `void mulle_objc_printf(const char *format, ...)` → Printf variant for objc context
- `NSString *NSStringFromClass(Class cls)` → Get class name as NSString
- `NSString *NSStringFromSelector(SEL sel)` → Get selector name as NSString
- `Class NSClassFromString(NSString *name)` → Get class by name

#### Property & Ivar Access

- `struct objc_ivar *class_getInstanceVariable(Class cls, const char *name)` → Get ivar metadata
- `id object_getIvar(id obj, struct objc_ivar *ivar)` → Get ivar value
- `void object_setIvar(id obj, struct objc_ivar *ivar, id value)` → Set ivar value

#### Hash Functions

- `NSUInteger mulle_objc_hashConstantCStringCallback(const void *key)` → Hash C string
- `BOOL mulle_objc_isEqualConstantCStringCallback(const void *a, const void *b)` → Compare C strings

### 3.9 Structures

#### NSRange - Interval Type

```c
struct NSRange {
   NSUInteger location;   // Start index
   NSUInteger length;     // Count of elements
};
```

#### NSZone - Memory Zone (Legacy)

- Largely unused in modern code; present for compatibility

## 4. Performance Characteristics

- **Message Send**: O(1) average with inline cache; optimized by mulle-objc-runtime
- **Method Lookup**: O(1) cached; O(log n) first lookup with modern runtime
- **retain/release**: O(1) atomic increment/decrement
- **NSAutoreleasePool**: O(1) add; O(n) drain where n = pooled objects
- **NSInvocation**: O(n) where n = argument count (serialization cost)
- **Locking**: O(1) acquire/release (platform-dependent; typically futex on Linux)
- **Memory**: Object header ~2 pointers (isa + retain count or atomic id)
- **Thread-Safety**: NSObject retain/release thread-safe (atomic). Collections not thread-safe without external locking.

## 5. AI Usage Recommendations & Patterns

### Best Practices

- **Memory Model**: Always pair `retain`/`release`; prefer autorelease for return values
- **Lifecycle**: Use `-init`/`-dealloc` pattern; call `[super init]` and `[super dealloc]`
- **Message Dispatch**: Use `-respondsToSelector:` before optional methods
- **Thread Safety**: Protect mutable state with NSLock; NSObject immutable reference counting is thread-safe
- **Pool Management**: Create pools in tight loops; use `@autoreleasepool` for scope
- **Proxy Usage**: Use NSProxy only for custom forwarding; NSObject is standard
- **Serialization**: Implement NSCoding for persistence; NSInvocation for message capture

### Common Pitfalls

- **Retain Cycles**: NSAutoreleasePool > weak references > circular references
- **Double-Release**: Each retain must have exactly one release; use MRC (Manual Retain-release) carefully
- **Deallocated Objects**: Accessing released object causes crash; no nil safety (use if (obj) checks)
- **forwardInvocation**: NSProxy requires implementation; default NSObject raises "unrecognized selector"
- **Lock Deadlock**: NSRecursiveLock allows same thread reentry; NSLock does not—avoid in single-threaded contexts
- **NSInvocation Overhead**: Slower than direct dispatch; use for dynamic methods only
- **Exception Safety**: @try/@catch context required for exception objects; default unwind may skip dealloc

### Idiomatic Usage Patterns

**Pattern 1: Proper Object Lifecycle**
```objc
@interface MyObject : NSObject {
    int value;
}
- (id)initWithValue:(int)v;
@end

@implementation MyObject
- (id)initWithValue:(int)v {
    self = [super init];
    if (self) {
        value = v;
    }
    return self;
}

- (void)dealloc {
    // Clean up if needed
    [super dealloc];
}
@end
```

**Pattern 2: Safe Message Dispatch**
```objc
// Check before calling optional methods
if ([object respondsToSelector:@selector(optionalMethod)]) {
    [object performSelector:@selector(optionalMethod)];
}
```

**Pattern 3: Autorelease for Return Values**
```objc
- (NSString *)processedString {
    NSString *result = [[NSString alloc] initWithCString:"data"];
    return [result autorelease];  // Caller doesn't need to release
}
```

**Pattern 4: Thread-Safe Access**
```objc
NSLock *lock = [[NSLock alloc] init];
[lock lock];
// Access shared state safely
[lock unlock];
```

**Pattern 5: Dynamic Method Invocation**
```objc
NSMethodSignature *sig = [object methodSignatureForSelector:@selector(method:)];
NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
[inv setTarget:object];
[inv setSelector:@selector(method:)];
id arg = ...;
[inv setArgument:&arg atIndex:2];  // Index 2 because 0=return, 1=self
[inv invoke];
id returnValue = nil;
[inv getReturnValue:&returnValue];
```

## 6. Integration Examples

### Example 1: Basic NSObject Usage

```objc
#import <MulleObjC/MulleObjC.h>

@interface Person : NSObject {
    NSString *name;
    int age;
}
- (id)initWithName:(NSString *)n age:(int)a;
- (NSString *)description;
@end

@implementation Person
- (id)initWithName:(NSString *)n age:(int)a {
    self = [super init];
    if (self) {
        name = [n retain];
        age = a;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Person: %@ (%d)", name, age];
}

- (void)dealloc {
    [name release];
    [super dealloc];
}
@end

int main() {
    Person *p = [[Person alloc] initWithName:@"Alice" age:30];
    NSLog(@"%@", p);
    [p release];
    return 0;
}
```

### Example 2: Autorelease Pool Pattern

```objc
#import <MulleObjC/MulleObjC.h>

int main() {
    @autoreleasepool {
        NSString *str1 = [NSString stringWithCString:"Hello"];  // autoreleased
        NSString *str2 = [[NSString alloc] initWithCString:" World"];  // must release
        [str2 autorelease];
        
        NSLog(@"%@%@", str1, str2);
        // Both released at pool drain
    }
    return 0;
}
```

### Example 3: Thread Synchronization

```objc
#import <MulleObjC/MulleObjC.h>

int main() {
    NSLock *lock = [[NSLock alloc] init];
    NSCondition *cond = [[NSCondition alloc] init];
    
    // Acquire lock
    [lock lock];
    NSLog(@"Lock acquired");
    [lock unlock];
    
    // Wait on condition with timeout
    [cond lock];
    NSDate *timeout = [[NSDate date] dateByAddingTimeInterval:2.0];
    BOOL signaled = [cond waitUntilDate:timeout];
    [cond unlock];
    
    if (!signaled) {
        NSLog(@"Timeout waiting for signal");
    }
    
    [lock release];
    [cond release];
    return 0;
}
```

### Example 4: Method Introspection

```objc
#import <MulleObjC/MulleObjC.h>

@interface Calculator : NSObject
- (int)add:(int)a to:(int)b;
@end

@implementation Calculator
- (int)add:(int)a to:(int)b {
    return a + b;
}
@end

int main() {
    Calculator *calc = [[Calculator alloc] init];
    
    SEL selector = @selector(add:to:);
    if ([calc respondsToSelector:selector]) {
        NSMethodSignature *sig = [calc methodSignatureForSelector:selector];
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
        [inv setTarget:calc];
        [inv setSelector:selector];
        int x = 5, y = 3;
        [inv setArgument:&x atIndex:2];
        [inv setArgument:&y atIndex:3];
        [inv invoke];
        
        int result = 0;
        [inv getReturnValue:&result];
        NSLog(@"Result: %d", result);  // Output: Result: 8
    }
    
    [calc release];
    return 0;
}
```

### Example 5: NSProxy for Message Forwarding

```objc
#import <MulleObjC/MulleObjC.h>

@interface Forwarder : NSProxy {
    id target;
}
- (id)initWithTarget:(id)t;
@end

@implementation Forwarder
- (id)initWithTarget:(id)t {
    target = [t retain];
    return self;
}

- (void)forwardInvocation:(NSInvocation *)inv {
    [inv setTarget:target];
    [inv invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [target methodSignatureForSelector:sel];
}

- (void)dealloc {
    [target release];
    [super dealloc];
}
@end

int main() {
    NSString *realString = [@"Hello" copy];
    Forwarder *proxy = [[Forwarder alloc] initWithTarget:realString];
    
    // Message sent to proxy, forwarded to realString
    NSLog(@"String: %@", proxy);  // Works transparently
    
    [proxy release];
    [realString release];
    return 0;
}
```

### Example 6: NSCoding for Object Serialization

```objc
#import <MulleObjC/MulleObjC.h>

@interface Book : NSObject <NSCoding> {
    NSString *title;
    int year;
}
- (id)initWithTitle:(NSString *)t year:(int)y;
@end

@implementation Book
- (id)initWithTitle:(NSString *)t year:(int)y {
    self = [super init];
    if (self) {
        title = [t retain];
        year = y;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:title forKey:@"title"];
    [coder encodeInt:year forKey:@"year"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        title = [[coder decodeObjectForKey:@"title"] retain];
        year = [coder decodeIntForKey:@"year"];
    }
    return self;
}

- (void)dealloc {
    [title release];
    [super dealloc];
}
@end
```

## 7. Dependencies

- **mulle-objc-runtime** (C library) - Runtime engine; method dispatch, memory model
- **mulle-objc-debug** (optional) - Debug support; introspection tools
- **mulle-thread** (via mulle-c) - Thread primitives
- No C standard library; fully self-contained portable implementation
