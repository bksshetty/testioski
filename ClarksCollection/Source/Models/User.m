//
//  User.m
//  ClarksCollection
//
//  Created by Openly on 16/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "User.h"
#import "MixPanelUtil.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation User
static User *current;

+(User *) current{
    return current;
}

+(void) setCurrent:(User *)user{
    current = user;
    [CrashlyticsKit setUserEmail:current.name];
    [[MixPanelUtil instance] identify: user];
}

-(NSString *) uniqueID{
    return self.name;
}
-(User *) initWithDict:(NSDictionary *) dict{
    if([self init]){
        self.name = [dict valueForKey:@"name"];
        self.regions = [dict valueForKey:@"regions"];
    }
    return self;
}
@end
