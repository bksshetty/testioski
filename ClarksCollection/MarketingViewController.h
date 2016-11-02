//
//  MarketingViewController.h
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MarketingViewController : UIViewController<SWRevealViewControllerDelegate>
@property NSMutableArray* btnArray ;
@property (weak, nonatomic) IBOutlet UICollectionView *marketingCollectionView;
@property (strong,nonatomic)   NSArray *marketingCategory;
@property int index;

@end
