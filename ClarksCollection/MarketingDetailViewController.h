//
//  MarketingDetailViewController.h
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketingMaterial.h"
#import "MarketingCategory.h"
#import "SwipeView.h"
#import "SWRevealViewController.h"

@interface MarketingDetailViewController : UIViewController<SWRevealViewControllerDelegate>

@property MarketingMaterial *theMarketingData;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
@property MarketingCategory *theMarketingCategory;
@property int idx;

@end
