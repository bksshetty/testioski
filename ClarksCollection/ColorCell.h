//
//  ColorCell.h
//  ClarksCollection
//
//  Created by Openly on 22/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedImage.h"

@interface ColorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ManagedImage *image;
@property (weak, nonatomic) IBOutlet UILabel *lblColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblColorValue;
@property (weak, nonatomic) IBOutlet UILabel *lblProductCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblProductCodeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblWholesalePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblWholesalePriceValue;
@property (weak, nonatomic) IBOutlet UILabel *lblRetailPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblRetailPriceValue;
@property (weak, nonatomic) IBOutlet UILabel *lblAddBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblSockValue;
@property (weak, nonatomic) IBOutlet UILabel *lblLiningValue;

@property (weak, nonatomic) IBOutlet UILabel *lblUpperMaterialValue;
@property (weak, nonatomic) IBOutlet UILabel *lblConstructionValuie;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblSizeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblFittingValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSoleValue;
@property (weak, nonatomic) IBOutlet UILabel *lblHealHeightValue;

- (IBAction)toggleDetails:(id)sender;

- (void) selectColor;
- (void) deSelectColor;
@end
