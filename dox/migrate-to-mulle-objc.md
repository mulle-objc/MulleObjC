# Migrating to mulle-objc

Check `__MULLE_OBJC__` to decide, if you are compiling with `mulle-clang` or
not.


## Stoppers

### `Protocol` does not exist

`Protocol` as a type and pseudo-class does not exist in **mulle-objc**. Use `PROTOCOL` instead if you can. Rewrite your code do use `PROTOCOL` and make this **typedef** for
other runtimes:

```
#ifndef __MULLE_OBJC__
typedef Protocol    *PROTOCOL;
#endif
```


### Variable argument methods

Methods that expect **...** arguments, must be recoded to use `mulle_vararg_list`
instead of `va_list`. See the example below for an idea how to solve that:


```
#ifdef __MULLE_OBJC__
   reason = [[[NSString alloc] initWithFormat:format
                              mulleVarargList:args] autorelease];
#else
   reason = [[[NSString alloc] initWithFormat:format
                                      va_list:args] autorelease];
#endif
```


### IMPs with more than one argument or non-object arguments

Code calling **IMP**s with more than one argument, or an argument that is
floating point or where `sizeof( argument) > sizeof( void *)` will not work.

#### Solutions

1. Convert your code back to '[]' syntax
2. Change parameter scheme to pass a struct
3. Manually create _param structure and pass that ( see "MulleObjCFuntions.h" for examples)

Example:

```
   IMP imp;

   imp = [foo methodForSelector:@selector( setValue:forKey:)];
#ifdef __MULLE_OBJC__
   MulleObjCIMPCall2( imp, foo, @selector( setValue:forKey:), a, b);
#else
   (*imp)( foo, @selector( setValue:forKey:), a, b);
#endif
```

## Improvements

### Straighten out `release` and `autorelease`

1.  `-init` methods, that return a different object should `release` self
2.  `-dealloc` methods should `release` references
3.  All other methods only ever use `autorelease`

