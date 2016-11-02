//
//  ForgotPasswordViewController.h
//  ClarksCollection
//
//  Created by Openly on 13/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
- (IBAction)didClickBack:(id)sender;
- (IBAction)didClickClose:(id)sender;
- (IBAction)didClickSend:(id)sender;
- (IBAction)didClickConfirmCloseBtn:(id)sender;
- (IBAction)didClickOkBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *forgotLbl;
@property (weak, nonatomic) IBOutlet UITextField *forgotTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)didEditingBegin:(id)sender;
- (IBAction)didEditingEnd:(id)sender;
- (IBAction)onValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *confirmVIew;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UIButton *confirmScreenCloseBtn;

@end
