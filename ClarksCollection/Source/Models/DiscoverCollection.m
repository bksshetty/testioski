//
//  DiscoverCollection.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DiscoverCollection.h"
#import "DataReader.h"

@implementation DiscoverCollection

+(NSArray *) loadAll{
    NSDictionary *data = [DataReader read];
    NSMutableArray *discoverCollections = [[NSMutableArray alloc] init];
    NSArray *jsonDC = [data valueForKey:@"discover_collections"];
    DiscoverCollection *theCollection;
    int i;
    for (i = 0; i < [jsonDC count]; i++) {
        NSDictionary *dict = jsonDC[i];
        theCollection = [DiscoverCollection alloc];
        theCollection.assortmentName = [dict valueForKey:@"assortment"];
        theCollection.collectionName = [dict valueForKey:@"collection"];
        theCollection.headerImage = [dict valueForKey:@"header_image"];
        NSArray *arr = [dict valueForKey:@"detail_images"];
        theCollection.detailImages = [[NSMutableArray alloc]initWithArray:arr];
        [discoverCollections addObject:theCollection];
    }
    return discoverCollections;
}
@end
