# Tests

Use **mulle-test** or

```
./build-test.sh
./run-test.sh
```

> Use a different Optimization level for testing with `CFLAGS=-O1 ./run-test.sh`

## Test with debug libraries

```
mulle-boostrap -f build --debug
./build-test.sh --debug
./run-test.sh
```

