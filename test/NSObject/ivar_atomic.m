#import <MulleObjC/MulleObjC.h>

// private stuff from MulleObjC for fake Exception

#import <MulleObjC/mulle-objc-universefoundationinfo-private.h>


//
// we don't have NSExceptions yet, so fake something up
//
@interface Exception : NSObject < MulleObjCException>
@end


@implementation Exception

__attribute__ ((noreturn))
static void   throw_argument_exception( id format, va_list args)
{
   [[Exception object] raise];
   abort(); // compiler sigh
}


+ (void) load
{
   struct _mulle_objc_exceptionhandlertable   *table;
   struct _mulle_objc_universe                *universe;
   static int                                 flag;

   if( ! flag)
   {
      universe                = MulleObjCObjectGetUniverse( self);
      table                   = mulle_objc_universe_get_foundationexceptionhandlertable( universe);
      table->invalid_argument = throw_argument_exception;
      flag                    = YES;
   }
}

@end



//
// MEMO: maybe NOT that well named in hindsight
//
@interface Assign : NSObject <NSCopying>
@end
@interface Copy : Assign
@end
@interface Retain : Assign
@end

@implementation Assign

- (char *) UTF8String
{
   return( MulleObjCInstanceGetClassNameUTF8String( self));
}

- (id) copy
{
   return( [[self class] new]);
}

@end
@implementation Copy
@end
@implementation Retain
@end


@interface Foo : NSObject
{
   mulle_atomic_id_t   _ivarAssign;
   mulle_atomic_id_t   _ivarCopy;
   mulle_atomic_id_t   _ivarRetain;
}
@end




@implementation Foo

- (id) lazyAssign
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
   return( [Assign object]);
}

- (id) lazyCopy
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
   return( [Copy new]);
}


- (id) lazyRetain
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
   return( [Retain new]);
}


- (id) assignedObject
{
   return( _MulleObjCAtomicIdGetLazy( &self->_ivarAssign,
                                      _C_ASSIGN_ID,
                                      self,
                                      @selector( lazyAssign),
                                      _C_ASSIGN_ID));
}


- (id) copiedObject
{
   return( _MulleObjCAtomicIdGetLazy( &self->_ivarCopy,
                                      _C_COPY_ID,
                                      self,
                                      @selector( lazyAssign),
                                      _C_ASSIGN_ID));
}



- (id) retainedObject
{
   return( _MulleObjCAtomicIdGetLazy( &self->_ivarRetain,
                                      _C_RETAIN_ID,
                                      self,
                                      @selector( lazyAssign),
                                      _C_ASSIGN_ID));
}


- (void) dealloc
{
   MulleObjCAtomicIdRelease( &self->_ivarCopy);
   MulleObjCAtomicIdRelease( &self->_ivarRetain);
   [super dealloc];

}
@end


@interface Bar : Foo
@end


@implementation Bar

- (id) assignedObject
{
   return( _MulleObjCAtomicIdGetLazy( &self->_ivarAssign,
                                      _C_ASSIGN_ID,
                                      self,
                                      @selector( lazyCopy),
                                      _C_COPY_ID));
}

- (id) copiedObject
{
   return( _MulleObjCAtomicIdGetLazy( &self->_ivarCopy,
                                      _C_COPY_ID,
                                      self,
                                      @selector( lazyCopy),
                                      _C_COPY_ID));
}



- (id) retainedObject
{
   return( _MulleObjCAtomicIdGetLazy( &self->_ivarRetain,
                                      _C_RETAIN_ID,
                                      self,
                                      @selector( lazyCopy),
                                      _C_COPY_ID));
}

@end


@interface Baz : Foo
@end


@implementation Baz

- (id) assignedObject
{
   return( _MulleObjCAtomicIdGetLazy( &self->_ivarAssign,
                                      _C_ASSIGN_ID,
                                      self,
                                      @selector( lazyRetain),
                                      _C_RETAIN_ID));
}

- (id) copiedObject
{
   return( _MulleObjCAtomicIdGetLazy( &self->_ivarCopy,
                                      _C_COPY_ID,
                                      self,
                                      @selector( lazyRetain),
                                      _C_RETAIN_ID));
}



- (id) retainedObject
{
   return( _MulleObjCAtomicIdGetLazy( &self->_ivarRetain,
                                      _C_RETAIN_ID,
                                      self,
                                      @selector( lazyRetain),
                                      _C_RETAIN_ID));
}

@end



static void   access( Foo *foo, SEL sel)
{
   id    value;

   mulle_printf( "-[%s %s]: ",
                     MulleObjCInstanceGetClassNameUTF8String( foo),
                     MulleObjCSelectorUTF8String( sel));
   @try
   {
      value = [foo performSelector:sel];
      mulle_printf( "%@\n", value);
   }
   @catch( Exception *e)
   {
      mulle_printf( "**failed**\n");
   }
}


static void  test( Class cls)
{
   Foo   *foo;
   char  *name;

   foo  = [cls new];

   access( foo, @selector( retainedObject));
   access( foo, @selector( copiedObject));
   access( foo, @selector( assignedObject));

   access( foo, @selector( retainedObject));
   access( foo, @selector( copiedObject));
   access( foo, @selector( assignedObject));

   [foo release];
}


int   main( void)
{
   test( [Foo class]);
   test( [Bar class]);
   test( [Baz class]);

   return( 0);
}
