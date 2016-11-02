//
//  HelpViewController.h
//  ClarksCollection
//
//  Created by Openly on 25/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface HelpViewController : UIViewController<SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *header1;
@property (weak, nonatomic) IBOutlet UILabel *header2;
@property (weak, nonatomic) IBOutlet UILabel *header3;
@property (weak, nonatomic) IBOutlet UILabel *header4;
@property (weak, nonatomic) IBOutlet UILabel *desc11;
@property (weak, nonatomic) IBOutlet UILabel *desc12;
@property (weak, nonatomic) IBOutlet UILabel *desc21;
@property (weak, nonatomic) IBOutlet UILabel *desc22;
@property (weak, nonatomic) IBOutlet UILabel *desc23;
@property (weak, nonatomic) IBOutlet UILabel *desc31;
@property (weak, nonatomic) IBOutlet UILabel *desc32;
@property (weak, nonatomic) IBOutlet UILabel *desc33;
@property (weak, nonatomic) IBOutlet UILabel *desc34;
@property (weak, nonatomic) IBOutlet UILabel *desc41;
@property (weak, nonatomic) IBOutlet UILabel *desc42;

@end
