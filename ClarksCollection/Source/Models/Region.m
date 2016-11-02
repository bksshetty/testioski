                     //
//  Region.m
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "Region.h"
#import "AppDelegate.h"
#import "DataReader.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@class ItemColor;

@implementation Region

static Region *current;
static NSMutableArray *regions;

+(NSArray *) loadAll{
    if (regions != nil && [regions count] !=0) {
        return regions;
    }
    [ItemColor resetIdx];
    NSDictionary *data = [DataReader read];
    
    int version = [[data valueForKey:@"version"] intValue];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.dataVersion = version;
    
    if (regions == nil) {
        regions = [[NSMutableArray alloc] init];
    }
    NSArray *jsonRegions = [data valueForKey:@"regions"];
    
    for (int i = 0; i < [jsonRegions count]; i++) {
        if (![regions containsObject:[[Region alloc] initWithDict:jsonRegions[i]]]) {
            [regions addObject:[[Region alloc] initWithDict:jsonRegions[i]]];
        }
    }
    return regions;
}

+ (void) setCurrent: (Region *) region{
#ifdef DEBUG
    CLSNSLog(@"Region: setCurrent: Entry");
#endif
    current = region;
#ifdef DEBUG
    CLSNSLog(@"Region: setCurrent: Exit");
#endif
}

+(Region *) getCurrent{
    return current;
}

+(void) clearRegions{
    if (regions != nil && regions != NULL) {
        [regions removeAllObjects];
    }
    
}

-(Region *) initWithDict: (NSDictionary *) dict{
#ifdef DEBUG
    CLSNSLog(@"Region: initWithDict: Entry");
#endif
    if ([self init]) {
        self.name = [dict valueForKey:@"name"];
        self.image = [dict valueForKey:@"image"];
        NSArray *curAssortments = [dict valueForKey:@"assortments"];
        NSMutableArray *assortments = [[NSMutableArray alloc] init];
        for (int i =0; i<[curAssortments count]; i++) {
            [assortments addObject:[[Assortment alloc] initWithDict: curAssortments[i]]];
        }
        self.assortments = assortments;
    }
#ifdef DEBUG
    CLSNSLog(@"Region: initWithDict: Exit");
#endif
    return self;
}
@end
