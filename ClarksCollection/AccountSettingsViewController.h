//
//  AccountSettingsViewController.h
//  ClarksCollection
//
//  Created by Openly on 28/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface AccountSettingsViewController : UIViewController<UITextFieldDelegate,SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *currentPassField;
@property (weak, nonatomic) IBOutlet UITextField *updatePassField;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *passwordLbl;
@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;
@property (weak, nonatomic) IBOutlet UILabel *updatePassLbl;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *verifyLbl;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


- (void) processResult: (NSDictionary *)res i:(int) i;
@property NSString *email ;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString ;

- (IBAction)didClickVerify:(id)sender;
- (IBAction)didClickSave:(id)sender;
- (IBAction)didClickChange:(id)sender;


@end
