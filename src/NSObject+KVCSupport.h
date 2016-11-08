//
//  NSObject+KVCSupport.h
//  MulleObjC
//
//  Created by Nat! on 15.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSObject.h"


// TODO: real caching needed

enum _MulleObjCKVCMethodType
{
   _MulleObjCKVCValueForKeyIndex           = 0,
   _MulleObjCKVCTakeValueForKeyIndex       = 1,
   _MulleObjCKVCStoredValueForKeyIndex     = 2,
   _MulleObjCKVCTakeStoredValueForKeyIndex = 3,
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

