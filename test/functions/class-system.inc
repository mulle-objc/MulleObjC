@interface A
@end

@implementation A
+ (void) foo
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}
+ (void) bar
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchOverriddenIMP( self, _cmd, @selector( A), MULLE_OBJC_NO_CATEGORYID);
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) baz
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchSuperIMP( self, _cmd, @selector( A));
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) foobar
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
}
@end

@class P;
@protocol P
@end

@interface P <P>
@end

@implementation P

+ (void) foo
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}
+ (void) bar
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchOverriddenIMP( self, _cmd, @selector( P), MULLE_OBJC_NO_CATEGORYID);
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) baz
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchSuperIMP( self, _cmd, @selector( P));
   if( imp)
      (*imp)( self, _cmd, self);
}
@end



@class Q;
@protocol Q
@end

@interface Q <Q>
@end

@implementation Q

+ (void) foo
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}
+ (void) bar
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchOverriddenIMP( self, _cmd, @selector( Q), MULLE_OBJC_NO_CATEGORYID);
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) baz
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchSuperIMP( self, _cmd, @selector( Q));
   if( imp)
      (*imp)( self, _cmd, self);
}
@end


@interface B : A < P, Q >
@end


@implementation B
+ (void) foo
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   [super foo];
}
+ (void) bar
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchOverriddenIMP( self, _cmd, @selector( B), MULLE_OBJC_NO_CATEGORYID);
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) baz
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchSuperIMP( self, _cmd, @selector( B));
   if( imp)
      (*imp)( self, _cmd, self);
}
@end


@interface B ( C)
@end


@implementation B( C)
+ (void) foo
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   [super foo];
}
+ (void) bar
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchOverriddenIMP( self, _cmd, @selector( B), @selector( C));
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) baz
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSearchSuperIMP( self, _cmd, @selector( B));
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) foobar
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   [super foobar];
}
@end
