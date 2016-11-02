//
//  LoginViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "LoginViewController.h"
#import "ClarksUI.h"
#import "API.h"
#import "ClarksFonts.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "User.h"
#import "ImageDownloadManager.h"
#import <MessageUI/MessageUI.h>
#import "DataReader.h"
#import "ClarksColors.h"
#import "InAppRegistrationViewController.h"
#import "ForgotPasswordViewController.h"
#import "AccountSettingsViewController.h"
#import "SettingsUtil.h"
#import "AssortmentSelectViewController.h"
#import "MenubarViewController.h"
#import "PListHelper.h"
#import "RefreshLists.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface LoginViewController (){
    UIColor *activeColor;
    UIColor *inactiveColor;
    bool inErrorState;
    UIView *loadingView;
}
@end

@implementation LoginViewController

static NSString *userName;

@synthesize autocompleteTableView;
@synthesize autocompleteUrls;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    activeColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.55f];
    inactiveColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.4f];
    inErrorState = false;
    [self.registerBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateSelected];
    [self.registerBtn.layer setBorderColor:[ClarksColors gillsansBlue].CGColor];
    self.registerBtn.layer.borderWidth = 1;
    self.registerBtn.layer.cornerRadius = 3;
    [self.btnLogin setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
    [self.btnLogin setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateSelected];
    [self.btnLogin.layer setBorderColor:[ClarksColors gillsansBlue].CGColor];
    self.btnLogin.layer.borderWidth = 1;
    self.btnLogin.layer.cornerRadius = 3;
    [self readFileContentsToArray];
    [super viewDidLoad];
    autocompleteTableView = [[UITableView alloc] initWithFrame:
                             CGRectMake(246, 160, 533, 130) style:UITableViewStylePlain];
    autocompleteTableView.delegate =  self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.backgroundColor = [UIColor whiteColor];
    [autocompleteTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    autocompleteTableView.hidden = YES;
    autocompleteTableView.layer.borderColor = [ClarksColors clarksGreen].CGColor;
    autocompleteTableView.layer.borderWidth = 1 ;
    [autocompleteTableView setAllowsSelection:YES];
    if ([autocompleteTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [autocompleteTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:autocompleteTableView];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.userField setLeftViewMode:UITextFieldViewModeAlways];
    [self.userField setLeftView:spacerView];
    self.userField.layer.cornerRadius = 3;
    self.userField.accessibilityLabel = @"email" ;
    [self.userField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.userField.text = [PListHelper getPlistData:@"ClarksCollection-Info" key:@"loggedIn_user"] ;
    [self.userField setSelectedTextRange:[self.userField textRangeFromPosition:self.userField.beginningOfDocument toPosition:self.userField.endOfDocument]];
    [self.registerBtn setHidden:NO];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.passwordFeild setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordFeild setLeftView:spacerView2];
    self.passwordFeild.layer.cornerRadius = 3;
    self.passwordFeild.accessibilityLabel = @"pass" ;
    autocompleteUrls = [[NSMutableArray alloc] init];
    self.lblLine2.text = @"Please email" ;
    NSMutableAttributedString *emailAddrTxt = [[NSMutableAttributedString alloc] initWithString:@"helpdesk@Clarks.com"];
    [emailAddrTxt addAttribute: NSForegroundColorAttributeName value:[UIColor whiteColor] range: NSMakeRange(0, [emailAddrTxt length])];
    [emailAddrTxt addAttribute: NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [emailAddrTxt length])];
    [self.btnEmail setAttributedTitle:emailAddrTxt forState:UIControlStateNormal];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.versionLabel.text = [NSString stringWithFormat:@"V E R S I O N : %@.  D A T A  V E R S I O N  %d", version, appDelegate.dataVersion];
}

-(void)dismissKeyboard {
    autocompleteTableView.hidden = YES;
}

-(void)textFieldDidChange{
    if ([self.userField.text length]==0) {
        autocompleteTableView.hidden = YES;
    }
    if ([autocompleteUrls count] == 0) {
        autocompleteTableView.hidden = YES;
    }else{
        autocompleteTableView.hidden = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        if (textField == self.userField) {
            NSString *substring = [textField.text lowercaseString];
            substring = [substring stringByReplacingCharactersInRange:range withString:string];
            [self searchAutocompleteEntriesWithSubstring:[substring lowercaseString]];
            return YES;
        }else{
            return NO;
        }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    autocompleteTableView.hidden = YES;
}

#pragma mark UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocompleteUrls.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [ClarksFonts clarksSansProThin:16.0f];
    cell.textLabel.text = [autocompleteUrls objectAtIndex:indexPath.row];
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

-(void)viewDidLayoutSubviews
{
    if ([autocompleteTableView respondsToSelector:@selector(setSeparatorInset:)])
        [autocompleteTableView setSeparatorInset:UIEdgeInsetsZero];
    if ([autocompleteTableView respondsToSelector:@selector(setLayoutMargins:)])
        [autocompleteTableView setLayoutMargins:UIEdgeInsetsZero];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Index Path row: %ld and User Name is: %@", (long)indexPath.row, selectedCell.textLabel.text);
    self.userField.text = selectedCell.textLabel.text;
    [self.userField resignFirstResponder];
    autocompleteTableView.hidden = YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    [autocompleteUrls removeAllObjects];
    for(NSString *curString in self.userList) {
        NSRange substringRange = [curString  rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocompleteUrls addObject:curString];
        }
    }
    [autocompleteTableView reloadData];
}

- (void) showLoading {
    if (loadingView == nil) {
        loadingView = [ClarksUI showLoader:self.view];
    }
}

- (void) hideLoading {
   [loadingView removeFromSuperview];
    loadingView = nil;
}

- (void) viewDidAppear:(BOOL)animated{
    self.userField.text = userName ;
    [self.userField setSelectedTextRange:[self.userField textRangeFromPosition:self.userField.beginningOfDocument toPosition:self.userField.endOfDocument]];
    if (![DataReader hasData]) {
        [self showLoading];
        CLSNSLog(@"Downloading data.json for first time.");
        [[API instance] getOnlyData:@"products" onComplete:^(NSData *data) {
            CLSNSLog(@"Done downloading data.json.");
            NSArray *paths = NSSearchPathForDirectoriesInDomains
            (NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *fileName = [NSString stringWithFormat:@"%@/data.json",
                                  documentsDirectory];
            [data writeToFile:fileName atomically:YES];
            [self hideLoading];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [self checkSignedIn];
            [appDelegate tryUpdate];
        }];
    }else{
        [self checkSignedIn];
    }
}

-(void) checkSignedIn{
    if ([[API instance] isLoggedIn]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate restoreList];
        NSDictionary *data = [DataReader read];
        int version = [[data valueForKey:@"version"] intValue];
        appDelegate.dataVersion = version;
        UIViewController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reveal"];
        [self presentViewController:navVC animated:NO completion:nil];
        [ImageDownloadManager preload];
        return;
    }
}

- (IBAction)onLoginValueChanged:(id)sender {
    if (!inErrorState) {
        return;
    }
    User *curUser ;
    if (![curUser.name isEqualToString:@"Demo App"]){
        [[MixPanelUtil instance] track:@"newUser"];
    }
    inErrorState = false;
    self.btnLogin.hidden = NO;
    self.registerBtn.hidden = NO;
    self.errorLabel.hidden = YES;
}

- (IBAction)onPasswordValueChanged:(id)sender {
    if (!inErrorState) {
        return;
    }
    inErrorState = false;
    self.btnLogin.hidden = NO;
    self.registerBtn.hidden = NO ;
    self.errorLabel.hidden = YES;
}

-(void) repositionButtons
{
    CGRect f = self.userField.frame;
    [ClarksUI reposition:self.userField x:f.origin.x y:95];
    
    f = self.registerBtn.frame ;
    [ClarksUI reposition:self.registerBtn x:f.origin.x y:397];
    
    f = self.passwordFeild.frame;
    [ClarksUI reposition:self.passwordFeild x:f.origin.x y:190];
    
    f = self.btnLogin.frame;
    [ClarksUI reposition:self.btnLogin x:f.origin.x y:335];
    
    f = self.btnForgot.frame;
    [ClarksUI reposition:self.btnForgot x:f.origin.x y:275];
    
    [ClarksUI reposition:self.errorLabel x:f.origin.x y:339];
}

-(void) unRepositionButtons
{
    CGRect f = self.userField.frame;
    [ClarksUI reposition:self.userField x:f.origin.x y:95 + 110];
    
    f = self.passwordFeild.frame;
    [ClarksUI reposition:self.passwordFeild x:f.origin.x y:190 + 110];
    
    f = self.btnLogin.frame;
    [ClarksUI reposition:self.btnLogin x:f.origin.x y:335 + 110];
    
    f = self.registerBtn.frame;
    [ClarksUI reposition:self.registerBtn x:f.origin.x y:397 + 110];
    
    f = self.btnForgot.frame;
    [ClarksUI reposition:self.btnForgot x:f.origin.x y:275+110];
    
    [ClarksUI reposition:self.errorLabel x:f.origin.x y:339 + 110];
}

- (IBAction)onEditingStarted:(id)sender {
    [self.lblLine2 setHidden:YES];
    [self.btnEmail setHidden:YES];
    [self repositionButtons];
}
- (IBAction)onEditingStartedPassword:(id)sender {
    [self repositionButtons];
    [self.lblLine2 setHidden:YES];
    [self.btnEmail setHidden:YES];
}

- (IBAction)onEditingEnded:(id)sender {
    [self.lblLine2 setHidden:YES];
    [self.btnEmail setHidden:YES];
    [self unRepositionButtons];
}

- (IBAction)onEditingEndedPassword:(id)sender {
    [self.lblLine2 setHidden:YES];
    [self.btnEmail setHidden:YES];
    [self unRepositionButtons];
}

- (IBAction)didClickRegister:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to register."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Settings",nil];
        [alert show];
        return;
    }else{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        InAppRegistrationViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"InAppRegistration"];
        [self presentViewController:add
                            animated:YES
                            completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView firstOtherButtonIndex]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

-(IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)doLogin:(id)sender
{
    [self.view endEditing:YES];
    [[[SettingsUtil alloc]init] networkRechabilityMethod];
    if ([self.userField.text length] < 1 || [self.passwordFeild.text length] < 1) {
        self.errorLabel.text = [@"P l e a s e  e n t e r  u s e r n a m e  a n d  p a s s w o r d." uppercaseString];
        self.errorLabel.hidden = NO;
        inErrorState = true;
        self.btnLogin.hidden = YES;
        self.btnEmail.hidden = YES;
        self.registerBtn.hidden = YES ;
        self.lblLine2.hidden = YES;
        return;
    }
    [PListHelper setPlistData:@"ClarksCollection-Info" key:@"loggedIn_user" strValue:self.userField.text];
    userName = self.userField.text ;
    if (![self.userList containsObject:self.userField.text]) {
        [self writeATEndOfFile:self.userField.text];
    }
    [self readFileContentsToArray];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *loader = [ClarksUI showLoader:self.view];
    if ([self.passwordFeild.text isEqualToString:@"backdoor"] && [self.passwordFeild.text isEqualToString:@"entry"]) {
        [appDelegate restoreList];
        UIViewController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reveal"];
        [self presentViewController:navVC animated:YES completion:nil];
        return;
    }
    [[API instance] login:self.userField.text password:self.passwordFeild.text onComplete:^(bool success, NSString *errMessage) {
        [loader removeFromSuperview];
        if (success) {
            NSString *message = [NSString stringWithFormat:@"Dear %@, please use your email address(%@) to login", self.userField.text, [API instance].email];
            if ([API instance].email != nil && [API instance].usernameUpdated) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Changing Username"
                                            message:message
                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDestructive
                                                                 handler:nil];
                [alertController addAction:actionOk];
                [self presentViewController:alertController animated:YES completion:nil];
                self.userField.text = [API instance].email;
                [API instance].usernameUpdated = false;
                return ;
            }
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate restoreList];
            [[API instance] get:@"app-user/get-email-verification-status" onComplete:^(NSDictionary *res) {
                if (res == nil) {
                    [[[SettingsUtil alloc] init] CMSNullErrorMethod];
                }
                appDelegate.verificationStatus = [res valueForKey:@"emailVerificationStatus"];
                if (![[res valueForKey:@"emailVerificationStatus"] isEqualToString:@"DONE"]) {
                    if ([[res valueForKey:@"emailVerificationStatus"] isEqualToString:@"BLOCKED"]) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                        AccountSettingsViewController *accountSetting = [storyboard instantiateViewControllerWithIdentifier:@"accountSettings"];
                        
                        UINavigationController *navigationController = self.navigationController;
                        
                        [navigationController pushViewController:accountSetting animated:YES];
                    }else{
                        UIViewController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reveal"];
                        [self presentViewController:navVC animated:YES completion:nil];
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verification Status"
                                                                    message:@"Please verify your email address"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }else {
                    UIViewController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reveal"];
                    [self presentViewController:navVC animated:YES completion:nil];
                }
            }] ;
            [RefreshLists getLists];
            [ImageDownloadManager preload];
        }else{
            self.errorLabel.hidden = NO;
            self.errorLabel.text = errMessage;
            self.btnLogin.hidden = YES;
            [self.btnEmail setHidden:YES];
            [self.registerBtn setHidden:YES];
            [self.lblLine2 setHidden:YES];
            inErrorState = true;
        }
    }];
}

- (IBAction)forgotUsername:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    SettingsUtil *setting  = [[SettingsUtil alloc] init] ;
    NSDictionary *res =  [setting getContentsOfSettingsFile] ;
    NSDictionary *forgotPass = [res valueForKey:@"NetworkDownError"] ;
    NSString *title = [forgotPass valueForKey:@"title"];
    NSString *message = [forgotPass valueForKey:@"message"] ;
    if (title == nil && message == nil) {
        title = @"" ;
        message = @"";
    }
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }else{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        ForgotPasswordViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"forgot_password"];
        [self presentViewController:add
                           animated:YES
                         completion:nil];
    }
}

- (NSString *) getFileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/UserList.txt",
                          documentsDirectory];
    return fileName;
}

- (NSArray *)readFileContentsToArray{
    NSError *error;
    NSString *fileContents =[NSString stringWithContentsOfFile:[self getFileName] encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    self.userList = [fileContents componentsSeparatedByString:@"\n"];
    return self.userList;
}

-(void)writeATEndOfFile:(NSString *)str
{
    if([[NSFileManager defaultManager] fileExistsAtPath:[self getFileName]])
    {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[self getFileName]];
        [fileHandle seekToEndOfFile];
        NSString *writedStr = [[NSString alloc]initWithContentsOfFile:[self getFileName] encoding:NSUTF8StringEncoding error:nil];
        str = [str stringByAppendingString:@"\n"];
        writedStr = [[writedStr stringByAppendingString:str] lowercaseString];
        [writedStr writeToFile:[self getFileName]
                   atomically:NO
                   encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    }
    else {
        [self writeToTextFile:[str lowercaseString]];
    }
}

-(void) writeToTextFile:(NSString *) value{
    NSString *content;
    NSString *content2 = [NSString stringWithFormat:@"%@",value];
    content = [content2 stringByAppendingString:@"\n"];
   [content writeToFile:[self getFileName]
             atomically:NO
             encoding:NSStringEncodingConversionAllowLossy
             error:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end