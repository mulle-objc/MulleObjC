# Migrating to mulle-objc

Check `__MULLE_OBJC__` to decide, if you are compiling with `mulle-clang` or
not.


## Stoppers

### Variable argument methods

Methods that expect **...** arguments, must be recoded to use `mulle_vararg_list`
instead of `va_list`. See the example below for an idea how to solve that:


```
#ifndef __MULLE_OBJC_RUNTIME__
   reason = [[[NSString alloc] initWithFormat:format
                                    arguments:args] autorelease];
#else
   reason = [[[NSString alloc] initWithFormat:format
                                      va_list:args] autorelease];
#endif
```


### IMPs with more than one argument or non-object arguments

Code calling **IMP**s with more than one argument, or an argument that is
floating point or where `sizeof( argument) > sizeof( void *)` will not work.

#### Solutions

1. Convert back to []
2. Change parameter scheme to pass a struct
3. Manually create _param structure and pass that ( see -[NSObject peform...] for an example)

Example:

```
#ifndef __MULLE_OBJC_RUNTIME__
   [foo setValue:a forKey:b];
#else
   IMP imp;

   imp = [foo methodForSelector:@selector( setValue:forKey:)];
   (*imp)( self, @selector( setValue:forKey:), a, b);
#endif
``

## Improvements

### Straighten out `release` and `autorelease`

1.  `-init` methods, that return a different object should `release` self
2.  `-dealloc` methods should `release` references
3.  All other methods only ever use `autorelease`

