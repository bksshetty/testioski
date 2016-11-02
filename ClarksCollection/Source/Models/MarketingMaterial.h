//
//  MarketingMaterial.h
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketingMaterial : NSObject
- (MarketingMaterial *) initWithDict: (NSDictionary *) dict;

@property NSString *name;
@property BOOL isTemplatized;
@property NSString *heading;
@property NSString *subHeading;
@property NSString *headerImage;
@property NSArray *detailImages;
@property NSMutableArray *templatizedData;
@property NSString *idx;

@end
