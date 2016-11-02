//
//  Lists.m
//  ClarksCollection
//
//  Created by Openly on 03/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "Lists.h"
#import "ItemColor.h"
#import "ListItem.h"
#import "ItemsInListViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation Lists

- (id)init
{
    if (self) {
        // Initialization code
        self.listOfItems = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

-(BOOL) addItemColorToList:(ListItem *)theListItemColor withPositionCheck:(BOOL)withPositionCheck{
    ListItem *listItem;
    for(listItem in self.listOfItems) {
        if([listItem.itemNumber isEqualToString:theListItemColor.itemNumber]){
            return NO;
        }
    }
    for (int i=0;i<[self.listOfItems count];i++) {
        ListItem *iterItem = self.listOfItems[i];
        if (iterItem.idx > theListItemColor.idx) {
            [self.listOfItems insertObject:theListItemColor atIndex:i];
            return YES;
        }
    }
    [self.listOfItems addObject:theListItemColor];
    return YES;
}

-(BOOL) addItemToList:(Item *)theItem{
    for(ItemColor *theColor in theItem.colors)
    {
        ListItem *newListItem = [[ListItem alloc] initWithItemAndColor:theItem withColor:theColor];
        [self addItemColorToList:newListItem withPositionCheck:NO];
    }
    return true;
}


-(BOOL) deleteItemFromList:(Item *)theItem{
    BOOL anyThingDeleted = NO;
    for(ItemColor *theColor in theItem.colors)
    {
        int i = 0;;
        for(ListItem *listItem in self.listOfItems) {
            if([theColor.colorId isEqualToString:listItem.itemNumber]) {
                [self.listOfItems removeObjectAtIndex:i];
                anyThingDeleted = YES;
                break;
            }
            i++;
        }
    }
    return anyThingDeleted;
}

-(BOOL) deleteItemColorFromList:(NSString *)theListItemColorNumber{
    int i = 0;
    for(ListItem *listItem in self.listOfItems) {
        if([theListItemColorNumber isEqualToString:listItem.itemNumber]) {
            [self.listOfItems removeObjectAtIndex:i];
            return YES;
        }
        i++;
    }
    return NO;
}

-(BOOL) saveList{
    return YES;
}

-(BOOL) emptyList{
    [self.listOfItems removeAllObjects];
    return YES;
}

-(BOOL) createNewList:(NSString *)theListItemName{
    return YES;
}

-(BOOL) emptyList:(NSString *)theListItemName{
    [self.listOfItems removeAllObjects];
    return true;
}

-(BOOL) exportList:(NSString *)theListItemName{
    return YES;
}

-(int) noOfItemsInList:(NSString *)theListItemName{
    return (int)[self.listOfItems count];
}

-(int) noOfItemsForCollecton:(NSString *)theCollectionName{
    int count = 0;
    for(ListItem *theListItem in self.listOfItems) {
        if([theListItem.collectionName isEqualToString:theCollectionName])
            count++;
    }
    return count;
}

-(BOOL)removeItemAtIndex:(int)index{
    if(index >= 0)
    {
        [self.listOfItems removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.listName forKey:@"listName"];
    [encoder encodeObject:self.listOfItems forKey:@"listOfItems"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.listName = [decoder decodeObjectForKey:@"listName"];
        self.listOfItems = [decoder decodeObjectForKey:@"listOfItems"];
    }
    return self;
}

-(void) sort{
    for (ListItem *item in self.listOfItems) {
        Item *theItem = [item getItem];
        int index = [item getItemColorIdx:theItem] ;
        if (index >= 0) {
            ItemColor *theColor = theItem.colors[index];
            item.idx = theColor.idx;
        }else{
            CLSLog(@"Index is -1");
        }
    }
    NSSortDescriptor *sorter =[NSSortDescriptor sortDescriptorWithKey:@"idx" ascending:YES];
    NSArray* sortDescriptors = @[sorter];
    NSArray *cpy = [self.listOfItems sortedArrayUsingDescriptors:sortDescriptors];
    self.listOfItems = [cpy mutableCopy];
}
@end
