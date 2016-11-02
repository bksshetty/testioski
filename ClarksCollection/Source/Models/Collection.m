//
//  Collection.m
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "Collection.h"

@implementation Collection

- (Collection *) initWithDict: (NSDictionary *) dict assortmentName:(NSString *)assortmentName{
    if ([self init]) {
        self.name = [dict valueForKey:@"name"];
        self.assortmentName = assortmentName;
        self.image = [dict valueForKey:@"image"];
        if (self.image == nil || ![self.image isKindOfClass:[NSString class]]) {
            NSString *tmpName = [self.name lowercaseString];
            if([tmpName isEqualToString:@"t2/3"])
                tmpName = @"t2 3";
            if([[self.assortmentName lowercaseString] isEqualToString:@"women"])
                self.assortmentName = @"womens";
            self.image = [NSString stringWithFormat:@"box-%@-%@.jpg",[self.assortmentName lowercaseString], tmpName];
        }
        self.selImage = [dict valueForKey:@"image-sel"];
        NSArray *curItems = [dict valueForKey:@"items"];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (int i =0; i<[curItems count]; i++) {
            [items addObject:[[Item alloc] initWithDict: curItems[i]]];
        }
        self.items = items;
    }
    return self;
}
@end
