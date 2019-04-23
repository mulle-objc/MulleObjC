#import "import.h"

#import "mulle-objc-type.h"
#import "MulleObjCIntegralType.h"
#import "NSObjectProtocol.h"
#import "NSEnumeration.h"
#import "NSCopying.h"


// These basic protocols declare the "access" of each container. They
// are not concerned with initialization.

//
// Note the NSEnumeration is not required, as NSFastEnumeration
// is now.
// Use id <NSObject> so that NSProxy and other conforming root class 
// instances can participate
//
@protocol NSArray < NSObject, NSFastEnumeration >

//- (instancetype) init;
//- (instancetype) initWithObjects:(id <NSObject>) objects 
//                           count:(NSUInteger) count;
- (NSUInteger) count;
- (id) objectAtIndex:(NSUInteger) i;

@end


@protocol NSMutableArray < NSArray>

- (void) insertObject:(id <NSObject>) obj
              atIndex:(NSUInteger) i;
- (void) removeObjectAtIndex:(NSUInteger) i;
- (void) addObject:(id <NSObject>) obj;
- (void) removeLastObject;
- (void) replaceObjectAtIndex:(NSUInteger) i
                  withObject:(id <NSObject>) obj;

@end


@protocol NSDictionary < NSObject, NSFastEnumeration >

//- (instancetype) init; 
//- (instancetype) initWithObjects:(id <NSObject>)  objects
//                         forKeys:(id <NSObject, NSCopying>) keys
//                           count:(NSUInteger) count;
- (NSUInteger) count;
- (id) objectForKey:(id <NSObject, NSCopying>) key;

@end


@protocol NSMutableDictionary < NSDictionary>

- (void) setObject:(id <NSObject>) object 
            forKey:(id <NSObject, NSCopying>) key;
- (void) removeObjectForKey:(id <NSObject, NSCopying>) key;

@end



@protocol NSSet < NSObject, NSFastEnumeration >

//- (instancetype) init;
//- (instancetype) initWithObjects:(id <NSObject> *) objects 
//                           count:(NSUInteger) count;
- (NSUInteger) count;
- (BOOL) member:(id <NSObject>) object;

@end


@protocol NSMutableSet < NSSet>

- (void) addObject:(id <NSObject>) obj;
- (void) removeObject:(id <NSObject>) obj;

@end

