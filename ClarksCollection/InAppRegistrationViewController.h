//
//  InAppRegistrationViewController.h
//  ClarksCollection
//
//  Created by Openly on 17/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InAppRegistrationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *lastNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *regionLbl;
@property (weak, nonatomic) IBOutlet UILabel *passwordLbl;
@property (weak, nonatomic) IBOutlet UILabel *reEnterLbl;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *regionDropDownBtn;
@property (weak, nonatomic) IBOutlet UIView *dropdownView;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImage;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property NSString *region_name ;
@property NSDictionary *region_res ;
@property NSMutableArray *btnArray ;

- (IBAction)didClickRegionDropDown:(id)sender;
- (IBAction)didClickClose:(id)sender;
- (IBAction)didClickOk:(id)sender;
- (IBAction)onClickRegister:(id)sender;

- (BOOL)checkIfTextfieldsEmpty ;

@end
