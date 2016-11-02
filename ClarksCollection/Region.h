//
//  Region.h
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Assortment.h"

@interface Region : NSObject
+(NSArray *) loadAll;

+ (void) setCurrent: (Region *) region;
+(Region *) getCurrent;

-(Region *) initWithDict: (NSDictionary *) dict;

@property NSString *name;
@property NSString *image;
@property NSArray *assortments;
@end
