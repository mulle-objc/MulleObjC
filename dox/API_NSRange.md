# NSRange


## MulleObjCRangeSubtract


### Function Signature

```c
NSUInteger MulleObjCRangeSubtract( NSRange range1, 
                                   NSRange range2,
                                   NSRange result[ 2]);
```

### Parameters

- `range1`: The first range to subtract from.
- `range2`: The second range to subtract.
- `result`: An array of NSRange structures that will store the resulting ranges after subtraction.

### Return Value

Returns the number of resulting ranges after the subtraction.

### Description

The `MulleObjCRangeSubtract` function subtracts `range2` from `range1` and stores the resulting ranges in the `result` array. The function considers different cases, such as non-overlapping ranges or ranges that are fully contained within each other.

### Example

```c
NSRange range1 = {5, 10};
NSRange range2 = {8, 3};
NSRange result[2];

NSUInteger count = MulleObjCRangeSubtract(range1, range2, result);

for (NSUInteger i = 0; i < count; i++) {
    printf("Resulting range %lu: location = %lu, length = %lu\n", i, result[i].location, result[i].length);
}
```

Output:

```
Resulting range 0: location = 5, length = 3
Resulting range 1: location = 11, length = 4
```

If there is no overlap between the two input ranges, the `MulleObjCRangeSubtract` function will return a single resulting range, which is the same as `range1`. The `result` array will contain only one NSRange structure with the same location and length as `range1`. Here's an example:

```c
NSRange range1 = {5, 10};
NSRange range2 = {16, 3};
NSRange result[2];

NSUInteger count = MulleObjCRangeSubtract(range1, range2, result);

for (NSUInteger i = 0; i < count; i++) {
    printf("Resulting range %lu: location = %lu, length = %lu\n", i, result[i].location, result[i].length);
}
```

Output:

```
Resulting range 0: location = 5, length = 10
```


# MulleObjCRangeCombine

## Function Signature

```c
NSRange MulleObjCRangeCombine(NSRange aRange, NSRange bRange);
```

## Parameters

- `aRange`: The first `NSRange` struct to be combined.
- `bRange`: The second `NSRange` struct to be combined.

## Return Value

The function returns a single `NSRange` struct that covers the union of the input ranges. If the input ranges do not overlap, the function returns a range with `NSNotFound` as the location and `0` as the length.

## Example

```c
#include <Foundation/Foundation.h>
#include "MulleObjCRangeCombine.h"

int main() {
    NSRange range1 = NSMakeRange(0, 2);
    NSRange range2 = NSMakeRange(3, 4);
    NSRange combinedRange = MulleObjCRangeCombine(range1, range2);

    printf("Combined Range: {%td, %td}\n", combinedRange.location, combinedRange.length);
    return 0;
}
```

In this example, the `MulleObjCRangeCombine` function is used to combine `range1` and `range2`. Since these ranges do not overlap, the function returns a range with `NSNotFound` as the location and `0` as the length. The output will be:

```
Combined Range: {4294967295, 0}
```