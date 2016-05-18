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


#import <MulleObjC/MulleObjC.h>

//
// this is defined here for standalone. a "real" foundation will want to
// produce their own. This version is compiled into the linked output.
//
// the forwarding method in this partiular runtime
void   *_objc_msgForward( void *self, mulle_objc_methodid_t _cmd, void *_param);

//
// [^1] first candidates for replacement
//
