//
//  DiscoverCollectionDataSource.h
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiscoverCollectionViewController.h"

@interface DiscoverCollectionDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet DiscoverCollectionViewController *parentVC;


@end
