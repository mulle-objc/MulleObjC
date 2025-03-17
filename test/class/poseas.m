#ifdef __MULLE_OBJC__
# import <MulleObjC/MulleObjC.h>
#else
# import <Foundation/Foundation.h>
#endif

#include <assert.h>

// POSING
//
// You have a class hierarcy Foobar : Bar and you want to augment code in Bar,
// but don't want to use categories (for old times sake). So you recreate
// [NSObject poseAsClass:] for old times sake.
//
// This works as long a no new categories are loaded (via NSBundle for example)
// A category that calls super, will not have a proper superid.  or ?
//
#define SQUELCH_ADDRESS


#ifdef SQUELCH_ADDRESS
# define _trace( self)                                                       \
   mulle_printf( "      %s: <%s>\n", __PRETTY_FUNCTION__,                    \
                               MulleObjCObjectGetClassNameUTF8String( self))
#else
# define _trace( self)                                                       \
   mulle_printf( "      %s: <%s %p>\n", __PRETTY_FUNCTION__,                 \
                               MulleObjCObjectGetClassNameUTF8String( self), \
                               self)
#endif

@interface NSObject( Trace)

+ (void) trace;
- (void) trace;

@end

@implementation NSObject( Trace)

+ (void) trace { _trace( self); }
- (void) trace { _trace( self); }

@end

@interface Foo : NSObject
@end


@implementation Foo

+ (void) trace { [super trace]; _trace( self); }
- (void) trace { [super trace]; _trace( self); }

@end


@interface Bar : Foo

@property( assign) int   v1;

@end


@implementation Bar

- (instancetype) init
{
   [super init];
   _v1 = -0x1848;
   return( self);
}


+ (void) trace { [super trace]; _trace( self); }
- (void) trace { assert( _v1 == -0x1848); [super trace]; _trace( self); }

@end



@interface FooBar : Bar

@property( assign) int   v2;

@end


@implementation FooBar

- (instancetype) init
{
   [super init];
   _v2 = 1848;
   return( self);
}

+ (void) trace { [super trace]; _trace( self); }
- (void) trace { assert( _v1 == -0x1848); assert( _v2 == 1848); [super trace]; _trace( self); }

@end


@interface Poser : Bar
@end


@implementation Poser : Bar

+ (void) trace { [super trace]; _trace( self); }
- (void) trace { assert( _v1 == -0x1848); [super trace]; _trace( self); }

@end


struct poseas_ctxt
{
   struct _mulle_objc_infraclass   *victim;
   struct _mulle_objc_infraclass   *poseur;
};


static mulle_objc_walkcommand_t
   poseas_callback( struct _mulle_objc_universe *universe,
                    void *p,
                    enum mulle_objc_walkpointertype_t type,
                    char *key,
                    void *parent,
                    void *userinfo)
{
   struct poseas_ctxt              *ctxt = userinfo;
   struct _mulle_objc_infraclass   *infra = p;
   struct _mulle_objc_metaclass    *meta;
   struct _mulle_objc_metaclass    *super_meta;
   struct _mulle_objc_class        *super_meta_superclass;

   if( infra == ctxt->poseur)
      return( mulle_objc_walk_ok);

   if( mulle_objc_infraclass_is_subclass( infra, ctxt->victim))
   {
      meta = _mulle_objc_infraclass_get_metaclass( infra);

      if( _mulle_objc_infraclass_get_superclass( infra) == ctxt->victim)
      {
         mulle_fprintf( stderr, "change %s superclass\n",
                               _mulle_objc_infraclass_get_name( infra));

         _mulle_objc_class_set_superclass( (struct _mulle_objc_class *) infra,
                                           (struct _mulle_objc_class *) ctxt->poseur);

         super_meta            = _mulle_objc_infraclass_get_metaclass( ctxt->poseur);
         super_meta_superclass =  super_meta ? &super_meta->base : &ctxt->poseur->base,

         _mulle_objc_class_set_superclass( (struct _mulle_objc_class *) meta,
                                           super_meta_superclass);
      }

      mulle_fprintf( stderr, "invalidate %s caches\n",
                               _mulle_objc_infraclass_get_name( infra));
      mulle_objc_class_invalidate_caches( _mulle_objc_infraclass_as_class( infra), NULL);
      mulle_objc_class_invalidate_caches( _mulle_objc_metaclass_as_class( meta), NULL);
   }
   return( mulle_objc_walk_ok);
}



@implementation NSObject( Poseur)

//
// this can be put into +load or +initialize and it should work, since
// subsequent class loads will then attach to the proper "posing" superclass
//
void   MulleObjCClassPoseAsSuperclass( Class self)
{
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_infraclass   *superclass;
   struct _mulle_objc_infraclass   *victim_infra;
   struct _mulle_objc_metaclass    *victim_meta;
   struct _mulle_objc_universe     *universe;
   struct poseas_ctxt              ctxt;
   char                            *name;
   mulle_objc_uniqueid_t           classid;

   if( ! self)
      return;

   infra        = (struct _mulle_objc_infraclass *) self;
   superclass   = _mulle_objc_infraclass_get_superclass( infra);
   if( ! superclass)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "your poser class \"%s\" is a root class",
               _mulle_objc_infraclass_get_name( infra));

   victim_infra = (struct _mulle_objc_infraclass *) superclass;
   victim_meta  = _mulle_objc_infraclass_get_metaclass( victim_infra);

   // ensure that we don't have any ivars, else this can't work,
   // the base class can have some no problems
   if( _mulle_objc_infraclass_has_ivars( infra))
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "your poser class \"%s\" has instance variables",
               _mulle_objc_infraclass_get_name( infra));

   universe = _mulle_objc_infraclass_get_universe( infra);
   _mulle_objc_universe_lock( universe);
   {
      if( mulle_objc_universe_patch_infraclass( universe, infra))
         MulleObjCThrowErrnoExceptionUTF8String( "poser class \"%s\" could not pose as \"%s\"",
                  _mulle_objc_infraclass_get_name( infra),
                  _mulle_objc_infraclass_get_name( superclass));

      // need to duplicate superids and add new ones for new class
      ctxt.victim = victim_infra;
      ctxt.poseur = infra;

      // register old superclass under new name, so we still get proper
      // cleanup when the universe pedantically exists
      // Foo ->  %Foo  (which is invalid for the compiler)
      mulle_buffer_do( buffer)
      {
         mulle_buffer_sprintf( buffer, "%%%s", _mulle_objc_infraclass_get_name( victim_infra));
         name = mulle_objc_universe_strdup( universe, mulle_buffer_get_string( buffer));

         victim_infra->base.name =
         victim_meta->base.name  = name;

         // if we change the classids here than within victim code (class
         // and category) stops working. Thats because the supers are
         // referencing the wrong classid and the search will fail.
         //

         //victim_infra->base.classid =
         //victim_meta->base.classid  = classid;
         classid = mulle_objc_classid_from_string( name);
         if( _mulle_objc_universe_register_infraclass_for_classid( universe, victim_infra, classid))
            MulleObjCThrowErrnoExceptionUTF8String( "posed away class \"%s\" could not register",
                  _mulle_objc_infraclass_get_name( victim_infra));
      }

      _mulle_objc_universe_invalidate_classcache( universe);

      //
      // all direct subclasses must change direct parent, and all deep
      // subclasses need to jetison their caches
      //
      _mulle_objc_universe_walk_classes( universe, 0, poseas_callback, &ctxt);
   }
   _mulle_objc_universe_unlock( universe);

}


+ (void) poseAsSuperclass
{
   MulleObjCClassPoseAsSuperclass( self);
}

@end


static char  *names[ 8] =
{
   "Foo class",
   "Foo instance",
   "Bar class",
   "Bar instance",
   "FooBar class",
   "FooBar instance",
   "Poser class",
   "Poser instance"
};

#define FOO_CLASS_INDEX        0
#define FOO_INSTANCE_INDEX     1
#define BAR_CLASS_INDEX        2
#define BAR_INSTANCE_INDEX     3
#define FOOBAR_CLASS_INDEX     4
#define FOOBAR_INSTANCE_INDEX  5
#define POSER_CLASS_INDEX      6
#define POSER_INSTANCE_INDEX   7


static void   create( id obj[ 8])
{
   obj[ 0] = [Foo class];
   obj[ 1] = [Foo object];
   obj[ 2] = [Bar class];
   obj[ 3] = [Bar object];
   obj[ 4] = [FooBar class];
   obj[ 5] = [FooBar object];
   obj[ 6] = [Poser class];
   obj[ 7] = [Poser object];
}


static void   trace( id obj[ 8])
{
   unsigned int  i;

   for( i = 0; i < 8; i++)
   {
      mulle_printf( "   %s\n", names[ i]);
      [obj[ i] trace];
      mulle_printf( "\n");
   }
}


static void   dump_class_table( void)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_infraclass               *infra;
   struct mulle_concurrent_hashmapenumerator   rover;
   intptr_t                                    classid;

   universe = _mulle_objc_infraclass_get_universe( (struct _mulle_objc_infraclass *) [NSObject class]);

   mulle_concurrent_hashmap_for( &universe->classtable, classid, infra)
   {
      mulle_fprintf( stderr, "%4ld: %08x \"%s\"\n",
                             (long) _mulle_objc_infraclass_get_classindex( infra),
                             classid,
                             _mulle_objc_infraclass_get_name( infra));
   }
}


int   main( int argc, char *argv[])
{
   id   before[ 8];
   id   after[ 8];

   create( before);
   mulle_printf( "before posing objects:\n");
   trace( before);

   [Poser poseAsSuperclass];

   dump_class_table();

   mulle_printf( "after posing same objects:\n");
   trace( before);

   create( after);
   mulle_printf( "after posing new objects:\n");
   trace( after);

   return( 0);
}
