#import "MulleObjCProtocol.h"

#import "NSObjectProtocol.h"
#import "NSCopying.h"
#import "NSMutableCopying.h"



PROTOCOLCLASS_IMPLEMENTATION( MulleObjCThreadSafe)

// here it comes in handy, that initialize is called by subclasses
+ (void) initialize
{
   struct _mulle_objc_class  *cls;

   cls = _mulle_objc_infraclass_as_class( (struct _mulle_objc_infraclass *) self);
   _mulle_objc_class_set_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
}

- (BOOL) mulleIsThreadSafe
{
   return( YES);
}


- (id) mulleThreadSafeCopy
{
   return( MulleObjCObjectRetain( self)); // is a little unclean
}

// no need for mulleTAOStrategy as it doesn't apply to threadSafe objects

PROTOCOLCLASS_END()



PROTOCOLCLASS_IMPLEMENTATION( MulleObjCThreadUnsafe)

+ (void) initialize
{
   struct _mulle_objc_class  *cls;

   cls = _mulle_objc_infraclass_as_class( (struct _mulle_objc_infraclass *) self);
   _mulle_objc_class_clear_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
}

- (BOOL) mulleIsThreadSafe
{
   return( NO);
}


- (id) mulleThreadSafeCopy
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

PROTOCOLCLASS_END()



PROTOCOLCLASS_IMPLEMENTATION( MulleObjCImmutable)

- (id /*<MulleObjCImmutable>*/) copy;
{
   return( [self retain]);
}


- (id /*<MulleObjCImmutable>*/) copyWithZone:(NSZone *) zone
{
   return( [self retain]);
}


PROTOCOLCLASS_END()



PROTOCOLCLASS_IMPLEMENTATION( MulleObjCPlaceboRetainCount)

- (void) finalize
{
}


- (void) dealloc
{
}


- (instancetype) retain
{
   return( self);
}


- (instancetype) autorelease
{
   return( self);
}


- (void) release
{
}


- (NSUInteger) retainCount
{
   return( MULLE_OBJC_NEVER_RELEASE);
}

PROTOCOLCLASS_END()

