//
//  AssortmentDatasource.m
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "AssortmentDatasource.h"
#import "ManagedImage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation AssortmentDatasource {
    NSArray *regions;
    NSArray *assortments;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void) setupRegion:(NSArray *)regionArray;
{
    regions = regionArray;
    NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithCapacity:regionArray.count];
    for (id regionObject in regionArray) {
        Region *region = (Region*)regionObject;
        for (id assortmentObject in region.assortments) {
            [tmpArray addObject:assortmentObject];
        }
    }
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:tmpArray];
    assortments = orderedSet.array;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return assortments.count ;
}

-(Assortment *) assortmentAtIndex:(NSInteger)index {
    return (Assortment *)assortments[index];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *assortment_identifier = @"assortment_cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:assortment_identifier forIndexPath:indexPath];
    ManagedImage *assortmentImage = (ManagedImage *)[cell viewWithTag:100];
    Assortment *theAssortment = (Assortment *)assortments[indexPath.row];
    if ([theAssortment.image rangeOfString:@"^https?://" options:NSRegularExpressionSearch].location != NSNotFound) {
        [assortmentImage loadImage:theAssortment.image];
    }else{
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/placeholder.jpg"];
         assortmentImage.image = [UIImage imageWithContentsOfFile:fullpath];
    }
    cell.tag = indexPath.row;
    return cell;
}

@end
