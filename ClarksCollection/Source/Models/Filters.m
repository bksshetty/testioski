//
//  Filters.m
//  ClarksCollection
//
//  Created by Openly on 12/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "Filters.h"
#import "Collection.h"
#import "Assortment.h"
#import "Region.h"
#import "DataReader.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation Filters

+ (NSArray *) filtersForCollections: (NSArray *) collections{
    NSDictionary *data = [DataReader read];
    NSMutableArray *allFilters = [[NSMutableArray alloc] init];
    for(Collection *collection in collections) {
        [allFilters addObjectsFromArray:[self filtersforCollection: collection fromDict:[data valueForKey:@"filters"]]];
    }
    NSMutableArray *mergedFilters = [[NSMutableArray alloc] init];
    NSMutableArray *groupNames = [[NSMutableArray alloc] init];
    for (NSDictionary *filter in allFilters) {
        NSUInteger idx = [groupNames indexOfObject:[filter valueForKey:@"name"]];
        if (idx != NSNotFound && idx < [mergedFilters count]) {
            NSArray *oldOpts = [[((NSMutableDictionary *)mergedFilters[idx]) valueForKey:@"options"] mutableCopy];
            NSMutableArray *opts = [self merge: [oldOpts mutableCopy]
                                          with:[filter valueForKey:@"options"]];
            [((NSMutableDictionary *)mergedFilters[idx]) setObject:opts forKey:@"options"];
        }else{
            [mergedFilters addObject:[filter mutableCopy]];
            [groupNames addObject:[filter valueForKey:@"name"]];
        }
    }
    NSMutableArray *array = [NSMutableArray array];
   
    NSArray *genFilterOrder =[data valueForKey:@"filter_orders"] ;
    NSMutableArray *filterArr = [[NSMutableArray alloc] init];
    for (NSDictionary *filterOrder in genFilterOrder) {
        if ([[Region getCurrent].name isEqualToString:[filterOrder valueForKey:@"region"]]) {
            NSLog(@"Region Name in app: %@", [Region getCurrent].name);
            NSLog(@"Region Name from json: %@", [filterOrder valueForKey:@"region"]);
            filterArr = [filterOrder valueForKey:@"order"];
        }
    }
    for (NSString *str in filterArr) {
        for (NSDictionary *dict in mergedFilters) {
            if ([str isEqualToString:[dict valueForKey:@"name"]]) {
                [array addObject:dict];
            }
        }
    }
    return array;
    
}
+ (NSMutableArray *) merge :(NSMutableArray *) orig with:(NSArray *) dest{
    for(NSDictionary *option in dest){
        BOOL foundinOrig = NO;
        for(NSDictionary *origOpt in orig){
            if([[[option valueForKey:@"name"] lowercaseString] isEqualToString:[[origOpt valueForKey:@"name"] lowercaseString]]){
                foundinOrig = YES;
            }
        }
        if(!foundinOrig){
            [orig addObject:option];
        }
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [orig sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    return orig;
}
+(NSArray *)filtersforCollection:(Collection *) collection fromDict:(NSDictionary *)dict{
    NSString *assortmentName = collection.assortmentName;
    NSString *collectionName = collection.name;
    //NSString *filterName;
    Region *curRegion = [Region getCurrent];
    
    dict = [[dict valueForKey:@"regions"] valueForKey:curRegion.name];
    
    // TODO: Fix this dirty bit of code.
//    if ([[assortmentName lowercaseString] isEqualToString:@"womens"]) {
//        assortmentName = @"women";
//    }
    
    for (NSDictionary *assortment in [dict valueForKey:@"assortments"]) {
        if ([[[assortment valueForKey:@"name"] lowercaseString] isEqualToString:[assortmentName lowercaseString]]) {
            NSArray *filterCollections = [assortment valueForKey:@"collections" ];
            for (NSDictionary *collection in filterCollections) {
                if ([[collection valueForKey:@"name"] isEqualToString:collectionName ]) {
                    return [collection valueForKey:@"filters"];
                }
            }
        }
    }
    return @[];
}
@end
