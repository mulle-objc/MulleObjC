//
//  NSObject+KVCSupport.h
//  MulleObjC
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "NSObject.h"


// TODO: real caching needed

enum _MulleObjCKVCMethodType
{
   _MulleObjCKVCValueForKeyIndex           = 0,
   _MulleObjCKVCTakeValueForKeyIndex       = 1,
   _MulleObjCKVCStoredValueForKeyIndex     = 2,
   _MulleObjCKVCTakeStoredValueForKeyIndex = 3
};


struct _MulleObjCKVCInformation
{
   id     key;
   IMP    implementation;
   SEL    selector;
   int    offset;
   char   valueType;
};


static inline void   _MulleObjCKVCInformationInitWithKey( struct _MulleObjCKVCInformation *p, id key)
{
   p->key            = key;
   p->implementation = 0;
   p->selector       = 0;
   p->offset         = 0;
   p->valueType      = _C_ID;
}


static inline void   _MulleObjCKVCInformationDone( struct _MulleObjCKVCInformation *info)
{
}


@protocol NSStringFuture

- (NSUInteger) _UTF8StringLength;
- (NSUInteger) _getUTF8String:(char *) buf
                   bufferSize:(NSUInteger) maxLength;
@end


//
// the cache is not 100% but more like 99.99%
//
@interface NSObject (KVCSupport)

- (void) _getKVCInformation:(struct _MulleObjCKVCInformation *) kvcInfo
                     forKey:(id <NSStringFuture>) key
                 methodType:(enum _MulleObjCKVCMethodType) type;

@end


@interface NSObject (KVCSupportFuture)

- (void) _divineKVCInformation:(struct _MulleObjCKVCInformation *) info
                        forKey:(id) key
                    methodType:(enum _MulleObjCKVCMethodType) type;

@end
