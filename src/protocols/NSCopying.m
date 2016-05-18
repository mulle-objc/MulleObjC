//
//  NSCopying.m
//  MulleObjC
//
//  Created by Nat! on 31.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSCopying.h"

#import "NSObject.h"
#import "MulleObjCAllocation.h"


@interface NSObject (NSCopyCompatibility)

- (id) copyWithZone:(NSZone *) null;

@end

// what is this ?
// by default NSObject does not implement copyWithZone:
// I want to keep it this way.
// But I also don't want to prolong the life of copyWithZone:
// so as as soon as a class implements NSCopying it gets
// a base copyWithZone: that calls copy
// therefore only copy needs to be coded. If copyWithZone: is
// coded this overrides the protocol
//
@interface NSCopying < NSCopying>
@end


@implementation NSCopying

+ (id) copyWithZone:(NSZone *) zone
{
   return( [self copy]);
}

@end


//
// the default implementation is different though,
// i think this is compatible, but have to check
//
@implementation NSObject ( NSCopying)


id   NSCopyObject( id object, NSUInteger extraBytes, NSZone *zone)
{
   id      clone;
   Class   cls;
   
   cls   = [object class];
   clone = NSAllocateObject( cls, extraBytes, NULL);
   memcpy( clone, object, extraBytes + _mulle_objc_class_get_instance_size( cls));
   return( clone);
}


// I have to do this for backward compatibility
// for classes, that don't implement copy, but
// just copyWithZone:

- (id) copy
{
   return( [self copyWithZone:NULL]);
}


+ (id) copy
{
   return( self);
}

+ (id) copyWithZone:(NSZone *) zone
{
   return( self);
}

@end
