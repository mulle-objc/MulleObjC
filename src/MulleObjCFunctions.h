//
//  MulleObjCFunctions.h
//  MulleObjC
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import "ns_type.h"


char    *NSGetSizeAndAlignment( char *type, NSUInteger *size, NSUInteger *alignment);

void    MulleObjCMakeObjectsPerformSelector( id *objects, NSUInteger n, SEL sel, id argument);
void    MulleObjCMakeObjectsPerformSelector2( id *objects, NSUInteger n, SEL sel, id argument, id argument2);

void    MulleObjCMakeObjectsPerformRetain( id *objects, NSUInteger n);
void    MulleObjCMakeObjectsPerformRelease( id *objects, NSUInteger n);

void    *MulleObjCClassGetName( Class cls);
void    *MulleObjCSelectorGetName( SEL sel);
Class   MulleObjCLookupClassByName( id obj);
SEL     MulleObjCCreateSelector( id obj);

Class   NSClassFromObject( id object);
