# MulleObjCExceptionHandler


## MulleObjCSetupExceptionHandler

### Function Signature

```c
void MulleObjCSetupExceptionHandler(void (*handler)(void));
```

### Description

Sets up an exception handler for the current thread. When an exception is raised, the exception handler will be invoked.

### Parameters
- `handler`: A pointer to the exception handler function.

### Returns
None.

## MulleObjCRaiseException

### Function Signature

```c
void MulleObjCRaiseException(id exception);
```

### Description

Raises an exception, which will be caught by the exception handler set up by `MulleObjCSetupExceptionHandler()`. If no exception handler is set up, the process will terminate.

### Parameters

- `exception`: The exception object to be raised.

### Returns
None.
