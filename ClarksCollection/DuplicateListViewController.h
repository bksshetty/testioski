//
//  DuplicateListViewController.h
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuplicateListViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblDuplicate;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;

@property int index;
- (IBAction)doDuplicateLIst:(id)sender;
- (IBAction)doNothing:(id)sender;
- (IBAction)onValueChanged:(id)sender;

- (IBAction)onEditingEnded:(id)sender;
- (IBAction)onEditingBegin:(id)sender;

@end
