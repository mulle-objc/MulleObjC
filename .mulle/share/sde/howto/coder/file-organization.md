# File Organization
<!-- Keywords: file, organization, split, add, reflect, multi-file, source, class, category, header, import -->

## Adding source files

```bash
mulle-sde add src/Foo.m              # ObjC class (creates .m + .h)
mulle-sde add src/Foo+Bar.m          # ObjC category
mulle-sde add -t file src/helpers.m  # plain .m file (no class template)
mulle-sde add src/util.c             # C file
```

`add` creates the file from a template and runs `reflect` automatically.
After reflect, the build system knows about the new file — no manual
CMake edits needed.

## When to split

Split when a file exceeds ~300–500 lines or when you have distinct
responsibilities (e.g., game state vs. rendering vs. audio).

## How imports work

After `mulle-sde reflect`, two generated headers exist:

| File | Purpose |
|------|---------|
| `src/import.h` | Import all project headers (use in .m files) |
| `src/import-private.h` | Same + private headers (use in test code) |

Every `.m` file should `#import "import.h"` at the top. Don't manually
import individual project headers — `import.h` handles the order.

## Moving / removing files

```bash
mv src/Old.m src/New.m
mv src/Old.h src/New.h
mulle-sde reflect           # updates cmake and import.h
```

```bash
rm src/Unused.m src/Unused.h
mulle-sde reflect
```

## Verify after changes

```bash
mulle-sde check             # fast compile check (~0.7s, no link)
mulle-sde craft             # full build (before run/test)
```
