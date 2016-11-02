//
//  Assortment.h
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Collection.h"

@interface Assortment : NSObject
- (Assortment *) initWithDict: (NSDictionary *) dict;

@property NSString *name;
@property NSString *image;
@property NSArray *collections;
@property NSArray *techLogos ;
@end
