//
//  FilterOption.m
//  ClarksCollection
//
//  Created by Openly on 27/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "FilterOption.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation FilterOption

- (FilterOption *) initWithDict: (NSDictionary *) dict {
    if ([self init]) {
        self.name = [[dict valueForKey: @"name"] lowercaseString];
        self.query = [[dict valueForKey: @"query"] lowercaseString];
    }
    return self;
}

@end
