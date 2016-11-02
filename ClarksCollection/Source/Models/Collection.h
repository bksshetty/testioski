//
//  Collection.h
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Collection : NSObject
- (Collection *) initWithDict: (NSDictionary *) dict assortmentName:(NSString *)assortmentName;
@property NSString *name;
@property NSString *assortmentName;
@property NSString *image;
@property NSString *selImage;
@property NSArray *items;
@end
