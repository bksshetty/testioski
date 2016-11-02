
//
//  ForgotPasswordViewController.m
//  ClarksCollection
//
//  Created by Openly on 13/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "ClarksUI.h"
#import "API.h"
#import "MixPanelUtil.h"
#import "Reachability.h"
#import "SettingsUtil.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [ClarksColors clarkLightGrey] ;
    [super viewDidLoad];
    [[MixPanelUtil instance] track:@"forgotPasswordClicked"];
    self.sendBtn.layer.borderWidth = 1 ;
    self.sendBtn.layer.borderColor = [ClarksColors clarksButtonGreen].CGColor;
    self.btnOk.layer.borderWidth = 1 ;
    self.btnOk.layer.borderColor = [ClarksColors clarksButtonGreen].CGColor;
    self.forgotLbl.font = [ClarksFonts clarksSansProThin:40.0f];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.forgotTextfield setLeftViewMode:UITextFieldViewModeAlways];
    [self.forgotTextfield setLeftView:spacerView2];
    self.sendBtn.enabled = NO  ;
    self.sendBtn.alpha = 0.5 ;
    self.confirmVIew.backgroundColor = [ClarksColors clarkLightGrey] ;
    [self.confirmVIew setHidden:YES];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Swipe Up");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)dismissKeyboard {
    [self unRepositionButtons];
    [self.forgotTextfield resignFirstResponder];
}

- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)didClickClose:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)didClickSend:(id)sender {
    [[[SettingsUtil alloc]init] networkRechabilityMethod];
    [self.forgotTextfield resignFirstResponder ];
    [self unRepositionButtons];
    NSString *emailString = self.forgotTextfield.text ;
    UIView *loader = [ClarksUI showLoader:self.view];
    
    [[API instance] post:@"app-user/forgot-password" params:@{@"email":emailString} onComplete:^(NSDictionary *results) {
        [loader removeFromSuperview];
        if(results == nil) {
            [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            [self.confirmVIew setHidden:NO];
        }
        else if ([strResult isEqualToString:@"failed"]){
            NSArray *errors  = [results valueForKey:@"errors"] ;
            NSString *error_msg = @"";
            for (NSString *error in errors){
                error_msg = [NSString stringWithFormat:@"%@ %@",error,error_msg];
                CLSNSLog(@"%@", error);
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password"
                                                            message: error_msg
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }] ;
}

- (IBAction)didClickConfirmCloseBtn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:Nil];
}

- (IBAction)didClickOkBtn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) repositionButtons
{
    CGRect f;
    f = self.forgotLbl.frame;
    [ClarksUI reposition:self.forgotLbl x:f.origin.x y:76];
    
    f = self.forgotTextfield.frame;
    [ClarksUI reposition:self.forgotTextfield x:f.origin.x y:168];
    
    f = self.sendBtn.frame;
    [ClarksUI reposition:self.sendBtn x:f.origin.x y:244];
}

-(void) unRepositionButtons
{
    CGRect f = self.forgotLbl.frame;
    [ClarksUI reposition:self.forgotLbl x:f.origin.x y:76+135];
    
    f = self.forgotTextfield.frame;
    [ClarksUI reposition:self.forgotTextfield x:f.origin.x y:168+135];
    
    f = self.sendBtn.frame;
    [ClarksUI reposition:self.sendBtn x:f.origin.x y:244+135];
}

- (IBAction)didEditingBegin:(id)sender {
    [self repositionButtons];
}

- (IBAction)didEditingEnd:(id)sender {
    [self unRepositionButtons];
}

- (IBAction)onValueChanged:(id)sender {
    [self repositionButtons];
    NSString *email = self.forgotTextfield.text;
    if([self NSStringIsValidEmail:email]){
        self.sendBtn.enabled = YES  ;
        self.sendBtn.alpha = 1 ;
    }else{
        self.sendBtn.enabled = NO  ;
        self.sendBtn.alpha = 0.5 ;
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/va ... l-address/
    NSString *stricterFilterString = @".*?[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end
