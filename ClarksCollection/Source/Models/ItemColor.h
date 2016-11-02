//
//  ItemColor.h
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemColor : NSObject
+ (void) resetIdx;
- (ItemColor *) initWithDict: (NSDictionary *) dict;

@property BOOL imageDownloaded;

@property NSString *name;
@property NSString *colorId;
@property NSString *displayId;
@property NSString *material;

@property NSArray *thumbs;
@property NSArray *mediumImages;
@property NSArray *largeImages;
@property NSArray *images360;
@property NSNumber *wholeSalePrice;
@property NSNumber *retailPrice;
@property NSString *rrp;
@property NSString *fad;
@property BOOL isSelected;
@property int idx ;

@end
