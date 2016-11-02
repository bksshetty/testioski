//
//  FilterGroup.m
//  ClarksCollection
//
//  Created by Openly on 27/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "FilterGroup.h"
#import "FilterOption.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation FilterGroup

- (FilterGroup *) initWithDict: (NSDictionary *) dict{
    if ([self init]) {
        self.name = [dict valueForKey:@"name"];
        
        NSArray *curFilterOptions = [dict valueForKey:@"options"];
        NSMutableArray *filterOption = [[NSMutableArray alloc] init];
        
        for (int i =0; i<[curFilterOptions count]; i++) {
            [filterOption addObject:[[FilterOption alloc] initWithDict: curFilterOptions[i]]];
        }
        self.filterOptions= filterOption;
    }
    return self;
}

@end
