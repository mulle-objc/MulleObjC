//
//  MulleObjC.h
//  MulleObjC
//
//  Copyright (c) 2015 Nat! - Mulle kybernetiK.
//  Copyright (c) 2015 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

// because standalone versions must define FASTIDs

//#ifdef MULLE_OBJC_RUNTIME_VERSION
//# error "do not include the mulle-objc-runtime before MulleObjC.h"
//#endif

#import "import.h"

// classes
#import "MulleObjCLoader.h"
#import "NSAutoreleasePool.h"
#import "NSInvocation.h"
#import "NSMethodSignature.h"
#import "NSObject.h"
#import "NSProxy.h"
#import "NSThread.h"

// protocols and protocolclasses
#import "MulleObjCClassCluster.h"
#import "MulleObjCContainerObjectCallback.h"
#import "MulleObjCException.h"
#import "MulleObjCProtocol.h"
#import "MulleObjCSingleton.h"
#import "MulleObjCTaggedPointer.h"
#import "NSCopying.h"
#import "NSCoding.h"
#import "NSContainer.h"
#import "NSEnumeration.h"
#import "NSMutableCopying.h"
#import "NSObjectProtocol.h"

// categories
#import "NSObject+NSCodingSupport.h"

// structs
// none.. all C

// functions
#import "MulleObjCAllocation.h"
#import "MulleObjCFunctions.h"
#import "MulleObjCUniverse.h"

