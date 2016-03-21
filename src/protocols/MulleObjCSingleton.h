//
//  NSObject+MulleObjCSingleton.h
//  MulleObjC
//
//  Created by Nat! on 21.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSObjectProtocol.h"


@protocol MulleObjCSingleton < NSObject>

+ (instancetype) sharedInstance;

@end
