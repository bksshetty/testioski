//
//  InAppRegistrationViewController.m
//  ClarksCollection
//
//  Created by Openly on 17/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "InAppRegistrationViewController.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "KeyboardInsetScrollView.h"
#import "API.h"
#import "ClarksUI.h"
#import "MixPanelUtil.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "SettingsUtil.h"
#import "RegisterAPI.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface InAppRegistrationViewController()
@end

@implementation InAppRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.regionDropDownBtn setTitle:@"S E L E C T  Y O U R  R E G I O N" forState:UIControlStateNormal];
    self.regionDropDownBtn.layer.cornerRadius = 3;
    
    [self setTextField:self.firstNameField];
    [self setTextField:self.lastNameField];
    [self setTextField:self.emailField];
    [self setTextField:self.passwordField];
    [self setTextField:self.reEnterField];

    [self disableRegisterBtn];
    self.dropdownView.hidden = YES;
    self.dropdownView.layer.borderWidth = 1 ;
    self.dropdownView.layer.borderColor = [ClarksColors gillsansBorderGray].CGColor;
    self.dropdownView.layer.cornerRadius = 3;
    
    self.confirmView.hidden = YES ;
    self.okBtn.layer.borderWidth = 1;
    self.okBtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.okBtn.layer.cornerRadius = 3;
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [[MixPanelUtil instance] track:@"inAppRegistrationButtonClicked"];
    NSDictionary *res = [RegisterAPI getRegions];
    self.region_res = res;
    [self createButton:res];
}

-(void) setTextField:(UITextField *)textField{
    textField.delegate = self;
    textField.layer.cornerRadius =3;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    [textField setLeftView:spacerView];
    [textField addTarget:self action:@selector(didEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void)didEditingChanged:(UITextField *)textField{
    if([self checkIfTextfieldsEmpty])
        [self disableRegisterBtn];
    else
        [self enableRegisterBtn];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        if (self.confirmView.isHidden)
            [self dismissViewControllerAnimated:YES completion:nil];
        else
            self.confirmView.hidden = YES;
    }
}

-(void)createButton: (NSDictionary *)results {
    int i = 0 ;
    self.btnArray = [[NSMutableArray alloc] init];
    for (NSDictionary *regions in results) {
        if(![[regions valueForKey:@"name"]isEqualToString:@"GLOBAL"] && ![[regions valueForKey:@"name"]isEqualToString:@"UK & ROI"]){
            CGRect rect = CGRectMake(0,65+i*65, 680, 65);
            UIButton *btn = [[UIButton alloc] initWithFrame: rect];
            btn.backgroundColor = [ClarksColors clarksWhite] ;
            [btn setAttributedTitle:[ClarksFonts addSpaceBwLetters:[[regions valueForKey:@"display_name"] uppercaseString] alpha:2.0] forState:UIControlStateNormal];
            NSLog(@"Region Name: %@",[regions valueForKey:[regions valueForKey:@"name"]]);
            btn.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:15];
            btn.accessibilityHint = [regions valueForKey:@"name"];
            [btn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
            [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnArray addObject:btn];
            [self.dropdownView addSubview:btn];
            i++;
        }
    }
}

-(void) onBtnClick: (UIButton *)btn{
    for (UIButton *button in self.btnArray) {
        if([button.titleLabel.text isEqualToString: btn.titleLabel.text]){
            button.backgroundColor = [ClarksColors gillsansBlue];
            [button setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
        }else{
            button.backgroundColor = [ClarksColors clarksWhite];
            [button setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
        }
    }
    self.dropdownView.hidden = YES;
    [btn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
    [self.regionDropDownBtn setAttributedTitle:[ClarksFonts addSpaceBwLetters:[btn.titleLabel.text uppercaseString] alpha:2.0] forState:UIControlStateNormal];
    self.region_name = btn.accessibilityHint ;
}

-(void)dismissKeyboard {
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.reEnterField resignFirstResponder];
    self.dropdownView.hidden = YES;
    if([self checkIfTextfieldsEmpty])
        [self disableRegisterBtn];
    else
        [self enableRegisterBtn];
}

- (BOOL)checkIfTextfieldsEmpty{
    if([self.firstNameField.text isEqual: @""] ||
       [self.lastNameField.text isEqual: @""] ||
       [self.emailField.text  isEqual: @""] ||
       [self.passwordField.text  isEqual: @""] ||
       [self.reEnterField.text  isEqual: @""]||
       ![self NSStringIsValidEmail:self.emailField.text] ||
       ![self.passwordField.text isEqualToString:self.reEnterField.text] ||
       (self.passwordField.text.length < 4) ||
       [self.regionDropDownBtn.titleLabel.text isEqualToString: @"S E L E C T  Y O U R  R E G I O N"]||
       [self.regionDropDownBtn.titleLabel.text isEqualToString: @" "]) {
            return true;
        }else{
            return false ;
    }
    return true;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if([self checkIfTextfieldsEmpty])
        [self disableRegisterBtn];
    else
        [self enableRegisterBtn];
    self.dropdownView.hidden = YES ;
    if([self.region_name isEqualToString: @""]|| [self.region_name isEqualToString:@"SELECT YOUR REGION"]||self.region_name == nil)
        [self.regionDropDownBtn setTitle:@"SELECT YOUR REGION" forState:UIControlStateNormal];
    else
        [self.regionDropDownBtn setTitle:self.region_name forState:UIControlStateNormal];
    if (textField == self.passwordField|| textField == self.reEnterField){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - 320), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.passwordField || textField == self.reEnterField){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 320), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if([self.region_name isEqualToString: @""]|| [self.region_name isEqualToString:@"S E L E C T  Y O U R  R E G I O N"]||self.region_name == nil)
        [self.regionDropDownBtn setTitle:@"S E L E C T  Y O U R  R E G I O N" forState:UIControlStateNormal];
    else
        [self.regionDropDownBtn setTitle:self.region_name forState:UIControlStateNormal];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @".*?[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)didClickRegionDropDown:(id)sender {
    [self.emailField resignFirstResponder];
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    NSDictionary *res = [RegisterAPI getRegions];
    NSLog(@"%@", res);
    [self createButton:res];
    self.dropdownView.hidden = NO ;
}

- (IBAction)didClickClose:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)didClickOk:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onClickRegister:(id)sender {
    [[[SettingsUtil alloc] init] networkRechabilityMethod];
    UIView *loader = [ClarksUI showLoader:self.view];
    NSString *userName = [NSString stringWithFormat:@"%@ %@", self.firstNameField.text, self.lastNameField.text];
    NSString *region_name ;
    for (NSDictionary *region in self.region_res){
        if([[region valueForKey:@"name"] isEqualToString:self.region_name]){
            region_name = [region valueForKey:@"name"];
            [[API instance] post:@"app-user/create"
                    params:@{@"userName":self.emailField.text,
                         @"password": self.passwordField.text,
                         @"confirmPassword":self.reEnterField.text,
                         @"firstName":self.firstNameField.text,
                         @"lastName":self.lastNameField.text,
                         @"region":region_name,
                         @"email":self.emailField.text
                        }
                    onComplete:^(NSDictionary *results) {
                        [loader removeFromSuperview];
                        if(results == nil) {
                            [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
                        }
                        NSString *strResult = [results valueForKey:@"status"];
                        if ([strResult isEqualToString:@"success"]) {
                            [[MixPanelUtil instance] track:@"userRegistered" args:((NSString *) userName)];
                            [self.confirmView setHidden:NO];
                        }
                        else if ([strResult isEqualToString:@"failed"]){
                            [[MixPanelUtil instance] track:@"registrationFailed"];
                            NSArray *errors  = [results valueForKey:@"errors"] ;
                            NSString *error_msg = @"";
                            for (NSString *error in errors)
                                error_msg = [NSString stringWithFormat:@"%@ %@",error,error_msg];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In-App Registration"
                                                                            message: error_msg
                                                                            delegate:self
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                            [alert show];
                        }
                }
             ];
        }
    }
}

-(void) enableRegisterBtn{
    [self.registerButton setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateSelected];
    self.registerButton.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.registerButton.layer.borderWidth = 1;
    self.registerButton.enabled = YES;
}

-(void) disableRegisterBtn{
    [self.registerButton setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateSelected];
    [self.registerButton.layer setBorderColor:[ClarksColors gillsansGray].CGColor];
    self.registerButton.layer.borderWidth = 1;
    self.registerButton.enabled = NO;
}
@end
