//
//  MulleStandaloneObjC.h
//  MulleObjC
//
//  Created by Nat! on 04.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef ns_objc__h__
# error "include MulleStandaloneObjC.h before MulleObjC.h"
#endif

//
// this is defined here for standalone. a "real" foundation will want to
// produce their own.
//
#define MULLE_OBJC_FOUNDATION_VERSION_MAJOR  0
#define MULLE_OBJC_FOUNDATION_VERSION_MINOR  1
#define MULLE_OBJC_FOUNDATION_VERSION_PATCH  0

#define MULLE_OBJC_FOUNDATION_VERSION  (            \
     ((MULLE_OBJC_FOUNDATION_VERSION_MAJOR << 20) | \
      (MULLE_OBJC_FOUNDATION_VERSION_MINOR << 8)  | \
       MULLE_OBJC_FOUNDATION_VERSION_PATCH))


#import "MulleObjC.h"

//
// [^1] first candidates for replacement
//
