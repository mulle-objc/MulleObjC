//
//  _MulleObjCConcreteValue-Private.h
//  MulleObjCValueFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
static inline void   *_MulleObjCConcreteValueBytes( _MulleObjCConcreteValue *_self)
{
   struct { @defs( _MulleObjCConcreteValue); }  *self = (void *) _self;
   return( &self->_size + 1);
}


static inline void   *_MulleObjCConcreteValueObjCType( _MulleObjCConcreteValue *_self)
{
   struct { @defs( _MulleObjCConcreteValue); }  *self = (void *) _self;

   return( &((char *) _MulleObjCConcreteValueBytes( _self))[ self->_size]);
}
