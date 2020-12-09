@interface A
@end

@implementation A
+ (void) foo
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}
+ (void) overridden
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCOverriddenIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) super
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSuperIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) foobar
{
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
+ (void) overridden
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCOverriddenIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) super
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSuperIMP;
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
+ (void) overridden
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCOverriddenIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) super
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSuperIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
@end


@interface B : A < P, Q >
@end


@implementation B
+ (void) chained
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}
+ (void) foo
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   [super foo];
}
+ (void) overridden
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCOverriddenIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) clobbered
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCClobberedIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) super
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSuperIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) chain
{
   IMP            imps[ 4];
   unsigned int   i, n;

   n = MulleObjCObjectSearchClobberChain( self, @selector( chained), imps, 4);
   for( i = n; i;)
      (*imps[ --i])( self, _cmd, self);
}

@end


@interface B ( X)
@end


@implementation B( X)
+ (void) chained
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}
+ (void) foo
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   [super foo];
}
+ (void) foobar
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   [super foobar];
}

+ (void) overridden
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCOverriddenIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) clobbered
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCClobberedIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) super
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSuperIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}

@end



@interface B ( Y)
@end


@implementation B( Y)

MULLE_OBJC_DEPENDS_ON_CATEGORY( B, X);
+ (void) chained
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}
+ (void) foo
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   [super foo];
}
+ (void) foobar
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   [super foobar];
}

+ (void) overridden
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCOverriddenIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) clobbered
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCClobberedIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}
+ (void) super
{
   IMP  imp;

   printf( "%s\n", __PRETTY_FUNCTION__);
   imp = MulleObjCSuperIMP;
   if( imp)
      (*imp)( self, _cmd, self);
}

@end
