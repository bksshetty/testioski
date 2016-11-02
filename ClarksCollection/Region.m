//
//  Region.m
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "Region.h"

@implementation Region

+(NSArray *) loadAll{
    NSString *dataFile = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSError *e;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataFile] options:nil error:&e];
    NSMutableArray *regions = [[NSMutableArray alloc] init];
    NSArray *jsonRegions = [data valueForKey:@"regions"];
    for (int i = 0; i < [jsonRegions count]; i++) {
        [regions addObject:[[Region alloc] initWithDict:jsonRegions[i]]];
    }
    return regions;
}

-(Region *) initWithDict: (NSDictionary *) dict{
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
    return self;
}
@end
