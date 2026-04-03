## Coding Style Guide

<!-- Keywords: syntax, edit, objc, styleguide -->

This document outlines the coding conventions. All contributions must adhere to
these rules to maintain code consistency and readability.

### 1. Formatting

#### 1.1. Indentation
-   Use three (3) spaces for each level of indentation. Do not use tabs.

#### 1.2. Bracing
-   Use the Allman style for braces. The opening and closing braces for a block
    are placed on their own lines and are vertically aligned.

    ```c
    if( condition)
    {
       ...
    }
    ```

#### 1.3. Spacing
-   **Control Structures & Function Calls:** No space between a
    keyword/function name and the opening parenthesis. A space follows the
    opening parenthesis.
    -   `if( condition)`
    -   `while( i < n)`
    -   `[self doSomethingWith: arg]`
-   **Expressions:** No spaces immediately inside parentheses for grouping
    expressions.
    -   `x = (a + b) * c;`

#### 1.4. Columnar Alignment
-   Align similar elements vertically for readability, especially assignment
    operators.

    ```c
    char  *a;
    int   b;

    a = "foo";
    b = 1848;
    ```

#### 1.5. `return` Statements
-   Parenthesize the return expression: `return( expr);`.
-   Do not use parentheses when there is no return value: `return;`.

### 2. Declarations & Initialization

#### 2.1. Variable Declaration
-   Declare all local variables at the top of the function block (C89 style).
-   Sort variable declarations alphabetically by name.
-   Declare one variable per line, except for trivial counters
    (e.g., `int i, n;`).

#### 2.2. Initialization
-   Variables should not be initialized at declaration by default.
-   **Exceptions:**
    1.  When initializing from a function argument, often involving a cast.
    2.  When initializing an aggregate type (struct, array) to zero, which
        replaces a subsequent `memset(..., 0, ...)`. If an aggregate is
        initialized this way, the corresponding `memset` must be removed.

### 3. Control Flow

#### 3.1. `case` and `goto` Labels
-   `case` statements and `goto` labels are not indented relative to the
    block they are in. They align with the opening brace of the `switch` or
    function block.

    ```c
    switch( value)
    {
    case 0:
       ...
       break;

    default:
       ...
       break;
    }
    ```

#### 3.2. Single-Statement Blocks
-   Avoid single-line statements for blocks (e.g., `if(condition) statement;`).
-   Use braces for all blocks, except for single-line statements, when it has
    no continuation and its visual association with the control structure is
    unambiguous.

## 4. Objective-C Specific

### 4.1. General coding style

-   Do not use `-retain` or `copy` or `-release` or `autorelease` (exception: inside `-init` and `-dealloc` and "accessor" methods)
-   Do not use `+alloc` `-init` use `+instance` or an appropriate factory method like `-[NSMutableArray array]`

### 4.2. Property Access
-   Do not use dot-syntax for property access.
-   Prefer non-mutable state in properties, prefer `(copy)` over `(retain)` when possible
-   Do not use strong use retain or copy instead
-   Do not use weak, use assign instead
-   Convert all property reads and writes to explicit message sends.
    -   **Read:** `[self property]` instead of `self.property`.
    -   **Write:** `[self setProperty:value]` instead of `self.property = value`.


## Tip:

NSString, NSArray and most other Foundation classes are not available
with mulle-objc/objc-developer, you want foundation/objc-developer for that.
