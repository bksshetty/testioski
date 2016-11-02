//
//  CollectionSelectViewController.h
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionSelectDataSource.h"
#import "Assortment.h"
#import "SWRevealViewController.h"

@interface CollectionSelectViewController : UIViewController<SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectAll;
- (IBAction)onSelectAll:(id)sender;
- (IBAction)onReset:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnApply;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (strong, nonatomic) IBOutlet CollectionSelectDataSource *collectionSelectDS;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;
-(void) setAssortment:(Assortment *)assortment;
- (IBAction)openMenu:(id)sender;
- (IBAction)goBack:(id)sender;
-(void)updateButtons:(BOOL)btnSelected;

@end
