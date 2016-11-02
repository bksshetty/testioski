//
//  CollectionSelectDataSource.m
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "CollectionSelectDataSource.h"
#import "API.h"
#import "ManagedImage.h"
#import "ClarksColors.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation CollectionSelectDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.curAssortment.collections count];
}

-(void)setupAssortment:(Assortment *)assortment{
    self.curAssortment = assortment;
    NSUInteger collectionCount =[assortment.collections count];
    self.displayState = [[NSMutableArray alloc]initWithCapacity:collectionCount];
    NSUInteger i =0;
    for(i=0; i < collectionCount; i++)
    {
        NSNumber *number = [[NSNumber alloc]initWithBool:NO];
        [self.displayState addObject:number];
    }
}

-(void)markAllCollectionsState:(BOOL) state{
    NSUInteger collectionCount =[self.curAssortment.collections count];
    for(int i=0; i < collectionCount; i++)
    {
        NSNumber *number = [[NSNumber alloc]initWithBool:state];
        [self.displayState replaceObjectAtIndex:i withObject:number];
    }
 }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"collection_cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ManagedImage *collectionImage = (ManagedImage *)[cell viewWithTag:101];
    Collection *theCollection = ((Collection *)self.curAssortment.collections[indexPath.row]);
    if (theCollection.image != nil && [theCollection.image rangeOfString:@"^https?://" options:NSRegularExpressionSearch].location != NSNotFound) {
        [collectionImage loadImage:theCollection.image];
    }
    else{
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/placeholder.jpg"];
        collectionImage.image = [UIImage imageWithContentsOfFile:fullpath];
    }
    BOOL state = [[self.displayState objectAtIndex:indexPath.row] boolValue];
    cell.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    cell.layer.borderWidth = (state == YES)?1:0;
   
    cell.tag = indexPath.row;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    if( cellCount >0 )
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount;
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth<contentWidth )
        {
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
    }
    return UIEdgeInsetsZero;
}

-(NSArray *)getListofSelectedCollections{
    NSMutableArray *selectedCollectionArray  = [[NSMutableArray alloc] initWithCapacity:4];
    NSUInteger i = 0;
    for(NSNumber *number in self.displayState)
    {
        if([number boolValue]) {
            Collection *theCollection = ((Collection *)self.curAssortment.collections[i]);
            [selectedCollectionArray addObject:theCollection];
        }
        i++;
    }
    return selectedCollectionArray;
}

-(void) updateCallback: (void(^)(BOOL)) completionHandler {
    handler = completionHandler;
}

- (void) updateOtherButtons
{
    BOOL isAnyBtnSelected = NO;
    for(NSNumber *number in self.displayState)
    {
        if([number boolValue]) {
            isAnyBtnSelected = true;
            break;
        }
    }
    handler(isAnyBtnSelected);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSNumber *number = (NSNumber *)[self.displayState objectAtIndex:indexPath.row];
    NSNumber *newNumber;
    if([number boolValue]== NO)
    {
        newNumber = [[NSNumber alloc]initWithBool:YES]; // mark as selected
        cell.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        cell.layer.borderWidth = 1;
    }
    else
    {
        newNumber = [[NSNumber alloc]initWithBool:NO]; // mark as deselected
        cell.layer.borderWidth = 0;
    }
    [self.displayState replaceObjectAtIndex:indexPath.row withObject:newNumber];
    [self updateOtherButtons];
    return;
}
@end
