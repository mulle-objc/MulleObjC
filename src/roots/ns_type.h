//
//  NSType.h
//  mulle-objc-foundation
//
//  Created by Nat! on 09.03.15.
//  Copyright (c) 2015 Mulle kybernetiK. All rights reserved.
//

#ifndef ns_type_h__
#define ns_type_h__

#include "mulle_objc_root_parent_include.h"

//
// this should be C readable
// these are here in the header, but they are actually defined by the
// compiler. So you can't change them.
//
// --- compiler defined begin ---
typedef void                          *id;
typedef struct _mulle_objc_class      *Class;
#if NOT_HAVE_PROTOCOL
typedef void                          Protocol;
#endif
typedef unsigned long                 SEL;
typedef void                           *(*IMP)( void *, SEL, void *params);
// --- compiler defined end ---


#ifndef NSINTEGER_DEFINED

// resist the temptation to typedef(!)
// but why ?
typedef uintptr_t   NSUInteger;
typedef intptr_t    NSInteger;

#define NSIntegerMax    ((NSInteger) (((NSUInteger) -1) >> 1))
#define NSIntegerMin    (-((NSInteger) (((NSUInteger) -1) >> 1)) - 1)
#define NSUIntegerMax   ((NSUInteger) -1)
#define NSUIntegerMin   0

#define NSINTEGER_DEFINED

#endif

enum
{
   NSNotFound = NSIntegerMax
};


enum _NSComparisonResult
{
   NSOrderedAscending = -1,
   NSOrderedSame,
   NSOrderedDescending
};
typedef NSInteger    NSComparisonResult;

#define nil   ((id) 0)
#define Nil   ((Class) 0)

typedef unsigned char   BOOL;  // the hated BOOL

enum
{
   YES = 1,
   NO  = 0
};


#endif
