//
//  MarketingCollectionViewDataSource.m
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "MarketingCollectionViewDataSource.h"
#import "MarketingCategory.h"
#import "MarketingMaterial.h"
#import "ManagedImage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation MarketingCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.parentVC.index >= [self.parentVC.marketingCategory count] ){
        return 0;
    }
    MarketingCategory *theCategory = [self.parentVC.marketingCategory objectAtIndex:self.parentVC.index];
    return [theCategory.marketingMaterials count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"marketing_cell";
     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ManagedImage *collectionImage = (ManagedImage *)[cell viewWithTag:100];
    MarketingCategory *theCategory = (MarketingCategory *)[self.parentVC.marketingCategory objectAtIndex:self.parentVC.index];
    MarketingMaterial *theMaterial =(MarketingMaterial *)[theCategory.marketingMaterials objectAtIndex:indexPath.row];
    NSString *imageName = theMaterial.headerImage;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.jpg"];
    collectionImage.image = [UIImage imageWithContentsOfFile:fullpath];
    [collectionImage loadImage:imageName];
    return cell;
}
@end
