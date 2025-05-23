# This file will be regenerated by `mulle-match-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Headers.cmake
#
if( MULLE_TRACE_INCLUDE)
   MESSAGE( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# contents are derived from the file locations

set( INCLUDE_DIRS
src/generic
src/class
src/function
src
src/reflect
src/protocol
src/struct
)

#
# contents selected with patternfile ??-header--private-generic-headers
#
set( PRIVATE_GENERIC_HEADERS
src/generic/import-private.h
src/generic/include-private.h
)

#
# contents selected with patternfile ??-header--private-headers
#
set( PRIVATE_HEADERS
src/class/MulleObject-Private.h
src/class/NSLock-Private.h
src/class/NSMethodSignature-Private.h
src/class/NSRecursiveLock-Private.h
src/function/MulleObjCExceptionHandler-Private.h
src/mulle-objc-autoreleasepointerarray-private.h
src/mulle-objc-exceptionhandlertable-private.h
src/mulle-objc-startup-private.inc
src/mulle-objc-universeconfiguration-private.h
src/mulle-objc-universefoundationinfo-private.h
)

#
# contents selected with patternfile ??-header--public-generated-headers
#
set( PUBLIC_GENERATED_HEADERS
src/reflect/_MulleObjC-provide.h
)

#
# contents selected with patternfile ??-header--public-generic-headers
#
set( PUBLIC_GENERIC_HEADERS
src/generic/import.h
src/generic/include.h
)

#
# contents selected with patternfile ??-header--public-headers
#
set( PUBLIC_HEADERS
src/MulleObjCCompiler.h
src/MulleObjCIntegralType.h
src/MulleObjCUniverse.h
src/MulleObjCVersion.h
src/MulleObjC.h
src/class/MulleDynamicObject.h
src/class/MulleObjCAutoreleasePool.h
src/class/MulleObjCLoader.h
src/class/MulleObjCLockFoundation.h
src/class/MulleObject.h
src/class/MulleProxy.h
src/class/NSAutoreleasePool.h
src/class/NSConditionLock.h
src/class/NSCondition.h
src/class/NSInvocation.h
src/class/NSLock.h
src/class/NSMethodSignature.h
src/class/NSNull.h
src/class/NSObject+NSCodingSupport.h
src/class/NSObject.h
src/class/NSProxy.h
src/class/NSRecursiveLock.h
src/class/NSThread.h
src/function/MulleObjCAllocation.h
src/function/MulleObjCDebug.h
src/function/MulleObjCExceptionHandler.h
src/function/MulleObjCFunctions.h
src/function/MulleObjCHashFunctions.h
src/function/MulleObjCIvar.h
src/function/MulleObjCPrinting.h
src/function/MulleObjCProperty.h
src/function/MulleObjCStackFrame.h
src/function/NSByteOrder.h
src/function/NSDebug.h
src/function/mulle-sprintf-object.h
src/minimal.h
src/mulle-objc-atomicid.h
src/mulle-objc-classbit.h
src/mulle-objc-fastclassid.h
src/mulle-objc-fastmethodid.h
src/mulle-objc.h
src/mulle-objc-threadfoundationinfo.h
src/mulle-objc-type.h
src/protocol/MulleObjCClassCluster.h
src/protocol/MulleObjCException.h
src/protocol/MulleObjCProtocol.h
src/protocol/MulleObjCRootObject.h
src/protocol/MulleObjCRuntimeObject.h
src/protocol/MulleObjCSingleton.h
src/protocol/MulleObjCTaggedPointer.h
src/protocol/NSCoding.h
src/protocol/NSContainer.h
src/protocol/NSCopyingWithAllocator.h
src/protocol/NSCopying.h
src/protocol/NSFastEnumeration.h
src/protocol/NSLocking.h
src/protocol/NSObjectProtocol.h
src/reflect/_MulleObjC-versioncheck.h
src/struct/MulleObjCContainerObjectCallback.h
src/struct/NSRange.h
src/struct/NSZone.h
)

