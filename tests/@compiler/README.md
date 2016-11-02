Q: Why don't the tests crash when, [Foo new] does not get released ?
A: The test classes implement new with calloc, which is not tracked by the mulle_test_allocator.

