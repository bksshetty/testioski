//
//  DeleteListViewController.h
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface DeleteListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmation;
- (IBAction)doPerformDelete:(id)sender;
- (IBAction)doNothing:(id)sender;
@property (weak, nonatomic) ListViewController *listVC;
@property int index;
@end
