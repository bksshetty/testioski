//
//  MarketingMaterialViewController.h
//  ClarksCollection
//
//  Created by Adarsh on 29/05/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketingCategory.h"
#import "SWRevealViewController.h"

@interface MarketingMaterialViewController : UIViewController<SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *marketingLbl;
@property (strong,nonatomic)   NSArray *marketingCategory;
@property MarketingCategory *cat;
@property (weak, nonatomic) IBOutlet UICollectionView *marketingColView;
-(void) setCategory: (MarketingCategory *)cat1 ;
//@property NSArray *marketingCategory;

@property int index;
@end
