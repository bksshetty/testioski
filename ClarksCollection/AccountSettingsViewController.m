//
//  AccountSettingsViewController.m
//  ClarksCollection
//
//  Created by Openly on 28/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "AccountSettingsViewController.h"
#import "ClarksColors.h"
#import "ClarksUI.h"
#import "SettingsScreenViewController.h"
#import "API.h"
#import "Reachability.h"
#import "MixPanelUtil.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"

@interface AccountSettingsViewController (){
    UIView *translucentView;
}
@end

@implementation AccountSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTextField:self.firstNameField enabled:YES];
    [self setTextField:self.lastNameField enabled:YES];
    [self setTextField:self.emailField enabled:YES];
    [self setTextField:self.passwordFiled enabled:NO];
    [self setTextField:self.updatePassField enabled:YES];
    [self setTextField:self.currentPassField enabled:YES];
    
    self.currentPassField.hidden = YES;
    self.updatePassField.hidden = YES ;
    self.updatePassLbl.hidden = YES ;
    self.forgotBtn.hidden = YES ;
    
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    self.revealViewController.delegate = self;
    
    self.saveBtn.layer.cornerRadius = 3;
    self.verifyBtn.layer.cornerRadius = 3;
    self.verifyLbl.hidden = YES ;
    self.verifyBtn.hidden = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect f = self.saveBtn.frame;
    [ClarksUI reposition:self.saveBtn x:f.origin.x y:523];
    [[MixPanelUtil instance] track:@"accountSetting"];
    
    UIView *loader = [ClarksUI showLoader:self.view];
    [[API instance] get:@"app-user/get-active-user" onComplete:^(NSDictionary *results) {
        [loader removeFromSuperview];
        if(results == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"No network connectivity or server down"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            NSDictionary *user = [results valueForKey:@"user"];
            self.firstNameField.text = [[user valueForKey:@"firstName"] uppercaseString];
            self.lastNameField.text = [[user valueForKey:@"lastName"] uppercaseString];
            self.emailField.text = [[user valueForKey:@"email"] uppercaseString];
            self.email = [user valueForKey:@"email"];
            appDelegate.verificationStatus = [user valueForKey:@"emailVerificationStatus"] ;
        }
    }];
    [self disableSaveBtn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void) setTextField:(UITextField *)textField enabled:(BOOL)b{
    textField.delegate = self;
    textField.layer.cornerRadius =3;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    [textField setLeftView:spacerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    [textField setEnabled:b];
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position{
    if (position == FrontViewPositionLeft) {
        self.view.alpha = 1;
        translucentView.hidden = YES;
    }else if(position == FrontViewPositionRight){
        self.view.alpha = 0.15;
        translucentView.hidden = NO;
    }
}
- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress{
    if (progress > 1) {
        self.view.alpha = 0.15;
    }else if(progress == 0){
        self.view.alpha = 1;
        translucentView.hidden = YES;
    }else{
        self.view.alpha = 1 - (0.85 * progress);
        translucentView.hidden = NO;
    }
    NSLog(@"%f - %f",progress, self.view.alpha);
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        if (translucentView.isHidden) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            SettingsScreenViewController *settings = [storyboard instantiateViewControllerWithIdentifier:@"setting_screen"];
            UINavigationController *navigationController = self.navigationController;
            [navigationController pushViewController:settings animated:YES];
        }
    }
}

- (void)textFieldDidChange:(NSNotification *)notification {
    if([self checkIfTextfieldsEmpty]){
        [self disableSaveBtn];
    }else{
        [self enableSaveBtn];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.revealViewController != nil) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    UIView *loader = [ClarksUI showLoader:self.view];
    [[API instance] get:@"app-user/get-email-verification-status" onComplete:^(NSDictionary *results) {
        [loader removeFromSuperview];
        if(results == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"No network connectivity or server down"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            NSLog(@"Verification Status: %@", [results valueForKey:@"emailVerificationStatus"]);
            appDelegate.verificationStatus  = [results valueForKey:@"emailVerificationStatus"];
        }else if([[results valueForKey:@"error"] isEqualToString:@"Session expired."]){
            [[API instance]logout:^{
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"sign_in"] animated:NO completion:nil];
            }];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logging out"
                                                            message:@"Logging you out as you are already logged in on another iPad. Please re-login"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    if ([appDelegate.verificationStatus isEqualToString:@"DONE"]){
        self.verifyBtn.enabled = NO ;
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/verified-btn-img.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
        [self.verifyBtn setTitle:@"" forState:UIControlStateNormal] ;
        self.verifyBtn.hidden = NO;
        [self.verifyBtn setBackgroundImage:image forState:UIControlStateNormal];
        self.verifyLbl.hidden = YES ;
    }else if([appDelegate.verificationStatus isEqualToString:@"INITIATED"]){
        self.verifyLbl.hidden = NO ;
    }else{
        self.verifyBtn.enabled = YES ;
        self.verifyLbl.hidden = YES ;
    }
    self.revealViewController.panGestureRecognizer.enabled = YES;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
}

// Method to validate a email string.
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/va ... l-address/
    NSString *stricterFilterString = @".*?[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)checkIfTextfieldsEmpty{
    if(self.passwordFiled.text.length > 0){
        if([self.updatePassField.text  isEqual: @""] ||
           [self.currentPassField.text isEqual:@""] ||
           ![self NSStringIsValidEmail:self.emailField.text] ||
           self.firstNameField.text.length == 0 ||
           self.lastNameField.text.length == 0 ||
           (self.updatePassField.text.length < 4)
           ) {
            return true;
        }else{
            return false ;
        }
    }else if(![self NSStringIsValidEmail:self.emailField.text] || self.firstNameField.text.length == 0 || self.lastNameField.text.length == 0){
        return true;
    }else{
        return false;
    }
   return false ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([self checkIfTextfieldsEmpty]){
        [self disableSaveBtn];
    }else{
        [self enableSaveBtn];
    }
    if([textField isEqual:self.emailField]){
        self.verifyBtn.enabled = false ;
        self.verifyLbl.hidden = YES ;
    }
    if (textField == self.updatePassField || textField == self.currentPassField || textField == self.passwordFiled)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - 320), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([textField isEqual:self.emailField]){
        if (([textField.text isEqualToString:self.email]) &&
            ([appDelegate.verificationStatus isEqualToString:@"NOT_INITIATED"])) {
            self.verifyBtn.enabled = false ;
            [self.verifyBtn setTitle:@"VERIFY" forState:UIControlStateNormal ];
        }
    }
    if (textField == self.updatePassField || textField == self.currentPassField || textField == self.passwordFiled)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 320), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)dismissKeyboard {
    [self.passwordFiled resignFirstResponder];
    [self.currentPassField resignFirstResponder];
    [self.updatePassField resignFirstResponder];
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

- (IBAction)didClickVerify:(id)sender {
    self.verifyLbl.hidden = NO ;
    self.verifyBtn.enabled = NO ;
    self.backButton.hidden = NO ;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                  message:@"You must be connected to the internet to update your password."
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alert show];
        return;
    }
    [[API instance] get:@"app-user/verify-email" onComplete:^(NSDictionary *results) {
        if(results == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"No network connectivity or server down"
                                                      delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verify Email"
                                                      message:@"Verification email sent successfully"
                                                      delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alert show];
            appDelegate.verificationStatus = [results valueForKey:@"emailVerificationStatus"];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Verification not successful"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.verifyBtn.enabled = true ;
            self.verifyLbl.hidden = YES ;
        }
    }];
}

- (void) processResult: (NSDictionary *)res i:(int) i{
    if(res == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No network connectivity or server down"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *strResult = [res valueForKey:@"status"];
    if ([strResult isEqualToString:@"success"]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.verificationStatus = @"INITIATED" ;
        [[MixPanelUtil instance] track:@"userUpdated"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update User"
                                                        message:@"User Updated Successfully"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        if(![self.email isEqualToString:self.emailField.text]&& i!=0){
            self.verifyBtn.enabled = NO ;
            self.verifyLbl.hidden = NO ;
            [self.verifyBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [self.verifyBtn setTitle:@"V E R I F Y" forState:UIControlStateNormal];
        }else if([self.email isEqualToString:self.emailField.text]&& i!=0){
            self.verifyBtn.enabled = NO ;
            self.verifyLbl.hidden = NO ;
        }
    }else if ([strResult isEqualToString:@"failed"]){
        [[MixPanelUtil instance] track:@"userUpdateFailed"];
        NSArray *errors  = [res valueForKey:@"errors"] ;
        NSString *error_msg = @"";
        for (NSString *error in errors){
            error_msg = [NSString stringWithFormat:@"%@ %@",error,error_msg];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update User"
                                                        message: error_msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)didClickSave:(id)sender {
    [self.currentPassField resignFirstResponder];
    [self.updatePassField resignFirstResponder];
    self.verifyBtn.hidden = NO ;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                  message:@"You must be connected to the internet to update your password."
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIView *loader = [ClarksUI showLoader:self.view];
    if (self.currentPassField.text.length == 0) {
        [[API instance] post:@"app-user/update-user"
                      params:@{
                               @"firstName" : [self.firstNameField.text lowercaseString] ,
                               @"lastName" : [self.lastNameField.text lowercaseString],
                               @"email" : [self.emailField.text lowercaseString]
                               }
                  onComplete:^(NSDictionary *results) {
                      [loader removeFromSuperview];
                      [self processResult:results i:(int)self.currentPassField.text.length];
                  }
         ];
    }else{
        [[API instance] post:@"app-user/update-user"
                      params:@{
                               @"firstName" : [self.firstNameField.text lowercaseString],
                               @"lastName" : [self.lastNameField.text lowercaseString],
                               @"email" : [self.emailField.text lowercaseString],
                               @"currentPassword": self.currentPassField.text,
                               @"newPassword":self.updatePassField.text
                               }
                  onComplete:^(NSDictionary *results) {
                      [loader removeFromSuperview];
                      [self processResult:results i:(int)self.currentPassField.text.length];
                  }
         ];
    }
}

- (IBAction)didClickChange:(id)sender {
    CGRect f = self.saveBtn.frame;
    [ClarksUI reposition:self.saveBtn x:f.origin.x y:673];
    self.currentPassField.text = self.passwordFiled.text ;
    [self.passwordFiled resignFirstResponder];
    [self.currentPassField resignFirstResponder];
    self.changeBtn.hidden = YES ;
    self.currentPassField.hidden = NO;
    self.updatePassField.hidden = NO ;
    self.updatePassLbl.hidden = NO ;
    self.forgotBtn.hidden = NO ;
    self.passwordLbl.text = @"CURRENT PASSWORD" ;
    [self.currentPassField becomeFirstResponder];
}

-(void) enableSaveBtn{
    [self.saveBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateSelected];
    self.saveBtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.saveBtn.layer.borderWidth = 1;
    self.saveBtn.layer.cornerRadius = 3;
    self.saveBtn.enabled = YES;
}

-(void) disableSaveBtn{
    [self.saveBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateSelected];
    self.saveBtn.layer.cornerRadius = 3;
    [self.saveBtn.layer setBorderColor:[ClarksColors gillsansGray].CGColor];
    self.saveBtn.layer.borderWidth = 1;
    self.saveBtn.enabled = NO;
}
@end
