#import <MulleObjC/MulleObjC.h>
#import <MulleObjC/NSDebug.h>


@interface A
{
   Class   space_enough;
}
@end

@implementation A

+ (id) new
{
   return( (id) _mulle_objc_infraclass_alloc_instance( (struct _mulle_objc_infraclass *) self));
}
+ (Class) class
{
   return( self);
}
- (void) dealloc
{
   _mulle_objc_instance_free( self);
}
- (void) foo
{
}
@end



int   main()
{
   A   *a;

   a = [A new];
   [a foo]; // fine
   MulleObjCZombifyObject( a, 0);
   [a foo]; // gotta crash
   [a dealloc];
}