//
//  ListItem.h
//  ClarksCollection
//
//  Created by Openly on 23/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface ListItem : NSObject
- (ListItem *) initWithItemAndColor: (Item *) item withColor: (ItemColor *) withColor;
- (ListItem *) initWithListItem: (ListItem *) listItem;
@property NSString *name;
@property NSString *collectionName;
@property NSString *itemColor;
@property NSString *fit;
@property NSString *size;
@property NSString *features;
@property NSString *imageSmall;
@property NSString *imageLarge;

@property NSNumber* wholeSalePrice;
@property NSNumber* retailPrice;
@property NSString* itemNumber;
@property NSArray* technologies;

@property int idx;

- (Item *) getItem;
- (int) getItemColorIdx:(Item *) item;

@end
