//
//  User.h
//  ClarksCollection
//
//  Created by Openly on 16/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
+(User *) current;
+(void) setCurrent:(User *)user;

-(User *) initWithDict:(NSDictionary *) dict;
-(NSString *) uniqueID;
@property NSString *name;
@property NSArray *regions;
@property BOOL *mixpanelBlocked ;
@end
