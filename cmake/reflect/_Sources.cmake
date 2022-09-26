# This file will be regenerated by `mulle-match-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/sources.cmake
#
if( MULLE_TRACE_INCLUDE)
   MESSAGE( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# contents selected with patternfile ??-source--sources
#
set( SOURCES
src/class/NSAutoreleasePool.m
src/class/NSInvocation.m
src/class/NSMethodSignature.m
src/class/NSObject+NSCodingSupport.m
src/class/NSObject.m
src/class/NSProxy.m
src/class/NSThread.m
src/function/MulleObjCAllocation.m
src/function/MulleObjCExceptionHandler.m
src/function/MulleObjCFunctions.m
src/function/MulleObjCPrinting.m
src/function/MulleObjCStackFrame.m
src/function/NSDebug.m
src/function/mulle-sprintf-object.m
src/mulle-objc-breakpoint.c
src/mulle-objc-threadfoundationinfo.m
src/mulle-objc-type.c
src/mulle-objc-universeconfiguration.m
src/mulle-objc-universefoundationinfo.m
src/protocol/MulleObjCClassCluster.m
src/protocol/MulleObjCException.m
src/protocol/MulleObjCProtocol.m
src/protocol/MulleObjCSingleton.m
src/protocol/MulleObjCTaggedPointer.m
src/protocol/NSCoding.m
src/protocol/NSCopying.m
src/struct/NSRange.c
)

#
# contents selected with patternfile ??-source--stage2-sources
#
set( STAGE2_SOURCES
src/class/MulleObjCLoader.m
)

#
# contents selected with patternfile ??-source--standalone-sources
#
set( STANDALONE_SOURCES
src/MulleObjC-standalone.m
)
