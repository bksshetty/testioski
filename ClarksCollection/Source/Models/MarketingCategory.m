//
//  MarketingCategory.m
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "MarketingCategory.h"
#import "MarketingMaterial.h"
#import "DataReader.h"
#import "Region.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation MarketingCategory

+(NSArray *) loadAll{
    NSDictionary *data = [DataReader read];
    NSMutableArray *marketingCategory = [[NSMutableArray alloc] init];
    NSArray *jsonCategoriesDict = [[[[data valueForKey:@"marketing_material"]valueForKey:@"regions"]valueForKey:[Region getCurrent].name] valueForKey:@"categories"];
//    NSArray *jsonCategoriesDict = [[data valueForKey:@"marketing_material"] valueForKey:@"categories"];
    NSLog(@"Marketing Region selected :%@",[[[[data valueForKey:@"marketing_material"]valueForKey:@"regions"]valueForKey:[Region getCurrent].name] valueForKey:@"categories"] );
    for (int i = 0; i < [jsonCategoriesDict count]; i++) {
        MarketingCategory *theCategory = [[MarketingCategory alloc]init];
        theCategory.marketingMaterials = [[NSMutableArray alloc]initWithCapacity:1];
        NSDictionary *theCategoryDict = [jsonCategoriesDict objectAtIndex:i];
        theCategory.name = [theCategoryDict valueForKey:@"name"];
        NSArray *jsonStoriesDict = [theCategoryDict valueForKey:@"stories"];
        for (int j = 0; j < [jsonStoriesDict count]; j++) {
            NSDictionary *theStory = [jsonStoriesDict objectAtIndex:j];
            MarketingMaterial *theMaterial = [[MarketingMaterial alloc]initWithDict:theStory];
            [theCategory.marketingMaterials addObject:theMaterial];
         }
        [marketingCategory addObject:theCategory];
    }
    return marketingCategory;
}
@end
