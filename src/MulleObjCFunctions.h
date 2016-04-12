//
//  MulleObjCFunctions.h
//  MulleObjC
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import "ns_type.h"


char   *NSGetSizeAndAlignment( char *type, NSUInteger *size, NSUInteger *alignment);

void   MulleObjCMakeObjectsPerformSelector( id *objects, NSUInteger n, SEL sel, id argument);
void   MulleObjCMakeObjectsPerformSelector2( id *objects, NSUInteger n, SEL sel, id argument, id argument2);

void   MulleObjCMakeObjectsPerformRetain( id *objects, NSUInteger n);


void   *MulleObjCStringFromClass( Class cls);
void   *MulleObjCStringFromSelector( SEL sel);
Class   MulleObjCClassFromString( void *obj);
SEL     MulleObjCSelectorFromString( void *obj);
