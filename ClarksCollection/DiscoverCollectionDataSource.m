//
//  DiscoverCollectionDataSource.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DiscoverCollectionDataSource.h"
#import "DiscoverCollection.h"
#import "DiscoverCollectionViewController.h"
#import "ManagedImage.h"
#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation DiscoverCollectionDataSource{
    NSArray *allCollections;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        allCollections = [DiscoverCollection loadAll];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [allCollections count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"discover_cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [collectionView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    ManagedImage *collectionImage = (ManagedImage *)[cell viewWithTag:100];
    DiscoverCollection *theDiscoverCollection =[allCollections objectAtIndex:indexPath.row];
 
    NSString *imageName = theDiscoverCollection.headerImage;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.png"];
    collectionImage.image = [UIImage imageWithContentsOfFile:fullpath];
    [collectionImage loadImage:imageName];
    return cell;
}

@end
