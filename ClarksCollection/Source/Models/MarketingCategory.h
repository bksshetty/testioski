//
//  MarketingCategory.h
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarketingMaterial.h"
#import "TemplatizedData.h"

@interface MarketingCategory : NSObject
+(NSArray *) loadAll;


@property NSString *name;
@property NSMutableArray *marketingMaterials;

@end
