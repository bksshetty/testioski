//
//  MarketingCollectionViewDataSource.h
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarketingViewController.h"
@interface MarketingCollectionViewDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet MarketingViewController *parentVC;

@end
