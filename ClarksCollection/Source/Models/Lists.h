//
//  Lists.h
//  ClarksCollection
//
//  Created by Openly on 03/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListItem.h"

@interface Lists : NSObject
@property(strong,nonatomic) NSMutableArray *listOfItems;
@property NSString *listName;
-(BOOL) addItemToList:(Item *)theItem;
-(BOOL) addItemColorToList:(ListItem *)theListItemColor withPositionCheck:(BOOL)withPositionCheck;
-(BOOL) deleteItemFromList:(Item *)theItem;
-(BOOL) deleteItemColorFromList:(NSString *)theListItemColorNumber;
-(BOOL) saveList;
-(BOOL) createNewList:(NSString *)theListItemName;
-(BOOL) emptyList;
//-(BOOL) exportList:(NSString *)theListItemName;
-(int) noOfItemsInList:(NSString *)theListItemName;
-(int) noOfItemsForCollecton:(NSString *)theCollectionName;
-(BOOL)removeItemAtIndex:(int)index;
-(void) sort;

@end
