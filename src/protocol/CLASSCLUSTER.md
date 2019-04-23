# Classcluster thoughts

* an infraclass is marked as a class cluster with a state bit
* subclasses of a class cluster should not implement +alloc (or they are not
part of the classcluster anymore)
* the placeholder for a class cluster is infinite retained, you don't need to
release it.
* you must not release it in your -init routine.


A complicated class cluster such as NSArray must serve a lot of different
uses.

```
Array <- _PlaceholderArray
      <- _EmptyArray
      <- _ConcreteArray
```

```
Array <- MutableArray <- _PlaceholderMutableArray
                      <- _EmptyArray
                      <- _ConcreteMutableArray
```

