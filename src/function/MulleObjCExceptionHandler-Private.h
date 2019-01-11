//
// the "MulleObjC" interface to NSException by default these all just call
// abort. Only MulleObjC is calling these functions.
//
#pragma mark -
#pragma mark Some C Interfaces with char *

MULLE_C_NO_RETURN void
   __mulle_objc_universe_raise_invalidargument( struct _mulle_objc_universe *universe, char *format, ...);

MULLE_C_NO_RETURN void
   __mulle_objc_universe_raise_errno( struct _mulle_objc_universe *universe, char *format, ...);

MULLE_C_NO_RETURN void
   __mulle_objc_universe_raise_internalinconsistency( struct _mulle_objc_universe *universe, char *format, ...);

MULLE_C_NO_RETURN void
   __mulle_objc_universe_raise_invalidindex( struct _mulle_objc_universe *universe, NSUInteger index);

MULLE_C_NO_RETURN void
   mulle_objc_universe_raisev_invalidargument( struct _mulle_objc_universe *universe, char *format, va_list args);

MULLE_C_NO_RETURN void
   mulle_objc_universe_raisev_errno( struct _mulle_objc_universe *universe, char *format, va_list args);

MULLE_C_NO_RETURN void
   mulle_objc_universe_raisev_internalinconsistency( struct _mulle_objc_universe *universe, char *format,
                                                        va_list args);