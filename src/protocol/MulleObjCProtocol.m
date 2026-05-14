#import "MulleObjCProtocol.h"

#import "NSObjectProtocol.h"
#import "NSCopying.h"
#import "MulleObjCException.h"


@implementation MulleObjCThreadSafe

// here it comes in handy, that initialize is called by subclasses
+ (void) initialize
{
   struct _mulle_objc_class  *cls;

   cls = _mulle_objc_infraclass_as_class( (struct _mulle_objc_infraclass *) self);
   _mulle_objc_class_set_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
}


- (BOOL) mulleIsThreadSafe   MULLE_OBJC_THREADSAFE_METHOD
{
   return( YES);
}


- (id) mulleThreadSafeCopy
{
   return( MulleObjCObjectRetain( self)); // is a little unclean
}


//
// this is needed so our object does not get removed from the AutoreleasePool
//
- (MulleObjCTAOStrategy) mulleTAOStrategy  MULLE_OBJC_THREADSAFE_METHOD
{
   return( MulleObjCTAOKnownThreadSafe);
}

@end



@implementation MulleObjCThreadUnsafe

+ (void) initialize
{
   struct _mulle_objc_class  *cls;

   cls = _mulle_objc_infraclass_as_class( (struct _mulle_objc_infraclass *) self);
   _mulle_objc_class_clear_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
}

- (BOOL) mulleIsThreadSafe   MULLE_OBJC_THREADSAFE_METHOD
{
   return( NO);
}


- (instancetype) mulleThreadSafeCopy
{
   return( nil);
}


// This may be superfluous, since coming from MulleObjCThreadSafe there
// is no change in the implementation (as the method wont get called). And if
// some subclass, wants to extend, why would we clobber ? Though, if someone
// mistakenly "fixed" this in his MulleObjCThreadSafe class, he might be
// surprised that putting on MulleObjCThreadSafe in his subclass doesn't fix
//problems....
//
// So ensure that the strategy is back to the default
//

- (MulleObjCTAOStrategy) mulleTAOStrategy  MULLE_OBJC_THREADSAFE_METHOD
{
   return( MulleObjCTAOCallerRemovesFromCurrentPool);
}

@end


@implementation MulleObjCImmutable

- (id) copy
{
   return( [self retain]);
}


@method_implementation -immutableCopy = -copy;

@end



@implementation MulleObjCPlaceboRetainCount

- (void) dealloc
{
}


// all do nothing
@method_implementation -finalize = -dealloc;
@method_implementation -release  = -dealloc;



- (instancetype) retain
{
   return( self);
}

// all return self
@method_implementation -autorelease = -retain;


- (NSUInteger) retainCount
{
   return( MULLE_OBJC_NEVER_RELEASE);
}

@end

