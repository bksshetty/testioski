//
//  Assortment.m
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "Assortment.h"

@implementation Assortment
- (Assortment *) initWithDict: (NSDictionary *) dict{
    if ([self init]) {
        self.name = [dict valueForKey:@"name"];
        self.image = [dict valueForKey:@"image"];
        if (self.image == nil) {
            if([self.name caseInsensitiveCompare:@"women"]== NSOrderedSame)
                self.image = @"box-womens.jpg";
            else
                self.image = [NSString stringWithFormat:@"box-%@.jpg",[self.name lowercaseString]];
        }
        NSArray *curCollections = [dict valueForKey:@"collections"];
        NSMutableArray *collections = [[NSMutableArray alloc] init];
        for (int i =0; i<[curCollections count]; i++) {
            [collections addObject:[[Collection alloc] initWithDict: curCollections[i] assortmentName:self.name]];
        }
        self.collections = collections;
    }
    return self;
}
@end
