//
//  ListItem.m
//  ClarksCollection
//
//  Created by Openly on 23/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ListItem.h"
#import "AppDelegate.h"
#import "User.h"
#import "Region.h"
#import "Assortment.h"
#import "Collection.h"
#import "Item.h"
#import "ItemColor.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation ListItem
- (ListItem *) initWithItemAndColor: (Item *) item withColor: (ItemColor *) withColor {
    if ([self init]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.name = item.name;
        self.collectionName = [NSString stringWithFormat:@"%@ - %@",appDelegate.selectedAssortmentName, item.collectionName];
        self.itemColor = withColor.name;
        self.fit = item.fit;
        self.size = item.size;
        self.features = @"";
        self.idx = withColor.idx;
        if([withColor.thumbs count] > 0)
            self.imageSmall = withColor.thumbs[0];
        else
            self.imageSmall =@"";
        if ([withColor.largeImages count] > 0)
        {
            self.imageLarge = withColor.largeImages[0];
            for(NSString *imageStr in withColor.largeImages) {
                NSRange isRange = [imageStr rangeOfString:@"_T.jpg" options:NSCaseInsensitiveSearch];
                if(isRange.location != NSNotFound) {
                    self.imageLarge = imageStr;
                    break;
                }
            }
        }
        else
            self.imageLarge = @"";
        self.wholeSalePrice = withColor.wholeSalePrice;
        self.retailPrice = withColor.retailPrice;
        self.itemNumber = withColor.colorId;
        self.technologies = item.technologies;
    }
    return self;
}

- (ListItem *) initWithListItem: (ListItem *) listItem {
    if ([self init]) {
        self.name = listItem.name;
        self.collectionName = listItem.collectionName;
        self.itemColor = listItem.itemColor;
        self.fit = listItem.fit;
        self.size = listItem.size;
        self.features = @"";
        self.imageSmall = listItem.imageSmall;
        self.imageLarge = listItem.imageLarge;
        self.wholeSalePrice = listItem.wholeSalePrice;
        self.retailPrice = listItem.retailPrice;
        self.itemNumber = listItem.itemNumber;
        self.technologies = listItem.technologies;
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.collectionName forKey:@"collectionName"];
    [encoder encodeObject:self.itemColor forKey:@"itemColor"];
    [encoder encodeObject:self.features forKey:@"features"];
    [encoder encodeObject:self.imageSmall forKey:@"imageSmall"];
    [encoder encodeObject:self.imageLarge forKey:@"imageLarge"];
    [encoder encodeObject:self.wholeSalePrice forKey:@"wholeSalePrice"];
    [encoder encodeObject:self.retailPrice forKey:@"retailPrice"];
    [encoder encodeObject:self.itemNumber forKey:@"itemNumber"];
    [encoder encodeObject:self.fit forKey:@"fit"];
    [encoder encodeObject:self.size forKey:@"size"];
    [encoder encodeObject:self.technologies forKey:@"technologies"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.collectionName = [decoder decodeObjectForKey:@"collectionName"];
        self.itemColor = [decoder decodeObjectForKey:@"itemColor"];
        self.features = [decoder decodeObjectForKey:@"features"];
        self.imageSmall = [decoder decodeObjectForKey:@"imageSmall"];
        self.imageLarge = [decoder decodeObjectForKey:@"imageLarge"];
        self.wholeSalePrice = [decoder decodeObjectForKey:@"wholeSalePrice"];
        self.retailPrice = [decoder decodeObjectForKey:@"retailPrice"];
        self.itemNumber = [decoder decodeObjectForKey:@"itemNumber"];
        self.fit = [decoder decodeObjectForKey:@"fit"];
        self.size = [decoder decodeObjectForKey:@"size"];
        self.technologies = [decoder decodeObjectForKey:@"technologies"];
    }
    return self;
}

- (Item *) getItem{
    NSString *region = [User current].regions[0];
    if ([[User current].regions count] > 1) {
        region = @"GLOBAL";
    }
    NSArray *assColl = [self.collectionName componentsSeparatedByString:@" - "];
    NSArray *allRegions = [Region loadAll];
    for (Region *reg in allRegions) {
        if(reg.name != NULL){
            if ([reg.name isEqualToString:region]) {
                for (Assortment *ass in reg.assortments) {
                    if ([ass.name isEqualToString:assColl[0]]) {
                        for (Collection *coll in ass.collections) {
                            if ([coll.name isEqualToString:assColl[1]]) {
                                for (Item *item in coll.items) {
                                    if ([item.name isEqualToString:self.name]) {
                                        return item;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return nil;
}

- (int) getItemColorIdx:(Item *) item{
    int i=0;
    for (ItemColor *col in item.colors) {
        if (col.name == nil ||
           [col.name isEqual:[NSNull null]] ||
           (self.itemColor == nil ||
           [self.itemColor isEqual:[NSNull null]])){
               CLSNSLog(@"List item color is null");
           }else{
               if ([col.name isEqualToString:self.itemColor]) {
                   return i;
               }
           }
       _idx++ ;
        i++;
    }
    return -1;
}
@end
