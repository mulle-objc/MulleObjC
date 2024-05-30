#ifdef __has_include
# if __has_include( "MulleDynamicObject.h")
#  import "MulleDynamicObject.h"
# endif
#endif

#import "import.h"

#import "NSLocking.h"
#import "NSRecursiveLock.h"


// Assume obj is of a subclass of MulleObject, which implements the
// method `-call:`
//
// When you execute [obj call:foo], the method will be found in the subclass
// and since its not a NSObject method, it will automagically lock the 
// instance with a NSRecursiveLock and unlock on exit. It is bad for -call to
// not catch exceptions, because then the unlock code is not executed. 
//
// [obj call:foo] 
//
// [obj]--isa-->[class]---->[array of methods]
//                 |
//                 v
//              [cache] --> callback
//
// [NSLock lock]
// <magie> (aufruf der Methode)  --> [cache] 
// [NSLock unlock]
//

// this method user bit is taken by this class
// same as _mulle_objc_method_user_attribute_4
#define MULLE_OBJC_METHOD_USER_BIT_NOT_LOCKING   _mulle_objc_method_user_attribute_4

// to make a subclass actually use the locking code, adorn it with
// MulleAutolockingObjectProtocols. This way you can use MulleObject
// as a base class for classes that do not aspire to be thread safe.
//
// All instance methods will be thread-safe, due to the whole class being
// marked MulleObjCThreadSafe. Special methods, that don't need (want) the
// locking should be marked as MULLE_OBJC_THREADSAFE_METHOD.
//
// To search for methods in a subclass of MulleObject, you will need to
// specify the desired inheritance value manually. The cls->inheritance value
// of MulleObject will appear to be broken. This is basically the main
// trick MulleAutolockingObject uses and it can't be avoided.
//
@protocol MulleAutolockingObject
@end

#define MulleAutolockingObjectProtocols   MulleObjCThreadSafe, MulleAutolockingObject


@interface MulleObject : MulleDynamicObject < NSLocking>
{
   NSRecursiveLock   *__lock;        // use __ to "hide" it
}

- (BOOL) tryLock                                         MULLE_OBJC_THREADSAFE_METHOD;

// we don't want to access this locked
- (void) shareLockOfObject:(MulleObject *) other  MULLE_OBJC_THREADSAFE_METHOD;

@end


//
// Declare your subclass like so:
//
// @interface Foo : MulleObject < MulleAutolockingObjectProtocols>
//
// In subclasses of Foo that are then **not threadsafe** put this in
//
// @interface Bar : Foo < MulleObjCThreadUnsafe>
//
// + (void) initialize
// {
//    MulleLockingObjectSetAutolockingEnabled( self, NO);
// }
//
// This is a bit clumsy, but we want to inherit from MulleObject,
// in MulleDynamicObject, but we don't want threadSafety always. We could use a
// protocolclass but in this special case, speed is really important as it
// hits most method calls. With the subclass we get the recursive lock
// location for free..
//
void   MulleLockingObjectSetAutolockingEnabled( Class self, BOOL flag);


void   MulleLockingObjectFillCache( MulleObject *self,
                                    SEL sel,
                                    IMP imp,
                                    BOOL isThreadAffine);
