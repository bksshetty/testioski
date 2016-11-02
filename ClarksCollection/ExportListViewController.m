//
//  ExportListViewController.m
//  ClarksCollection
//
//  Created by Openly on 13/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ExportListViewController.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "API.h"
#import "Lists.h"
#import "ItemList.h"
#import "AppDelegate.h"
#import "SettingsUtil.h"
#import "User.h"
#import "ClarksUI.h"
#import "SWRevealViewController.h"
#import "AccountSettingsViewController.h"

@interface ExportListViewController (){
    NSMutableArray *emailList;
    UIScrollView *scrollView;
    NSMutableArray *btnArray;
    NSMutableArray *exportUserList ;
    CGRect f ;
}

@end

@implementation ExportListViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [ClarksColors clarkLightGrey] ;
    [super viewDidLoad];
    f = self.btnSend.frame;
    emailList = [[NSMutableArray alloc] init];
    NSLog(@"Width: %f and Height :%f", self.containerView.bounds.size.width, self.containerView.bounds.size.height);
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 500, 160)];
    exportUserList = [[NSMutableArray alloc] init];
    
    [self.containerView addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width+60, scrollView.bounds.size.height*2)];
    scrollView.delegate = self;
    scrollView.directionalLockEnabled = YES ;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    self.containerView.hidden = YES;
    self.plusBtn.enabled = NO;
    self.btnSend.enabled = NO;
    
    [ClarksUI reposition:self.btnSend x:f.origin.x y:434-170];
    
    // Do any additional setup after loading the view.
    self.lbl1.font = [ClarksFonts clarksSansProThin:40.0f];
    self.txtEMail.font =[ClarksFonts clarksSansProThin:20.0f];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
    [self.txtEMail setLeftViewMode:UITextFieldViewModeAlways];
    
    UIColor *color = [ClarksColors clarksMediumGrey];
    
    [self.txtEMail setLeftView:spacerView2];
    self.txtEMail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter email address and tap on the ‘+’ button" attributes:@{NSForegroundColorAttributeName:color}];
    self.txtEMail.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
//    [self.revealViewController setFrontViewShadowOffset:CGSizeMake(-300, 300)];
//    self.revealViewController. = 0.85;
    
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
}

-(void) viewDidAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Swipe Up");
        [self.navigationController popViewControllerAnimated:YES];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"Swipe Down");
    }
}

-(void) clearView{
    NSArray * allSubviews = [scrollView subviews];
    for(UIView *view in allSubviews)
    {
        if([view isMemberOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
}

- (void) refreshView{
    int indexOfLeftmostButtonOnCurrentLine = 0;
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    float runningWidth = 0.0f;
    float maxWidth = 600.0f;
    float horizontalSpaceBetweenButtons = 10.0f;
    float verticalSpaceBetweenButtons = 10.0f;
    
    [self clearView];
    
    for (int i=0; i<emailList.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        NSString *email = [emailList objectAtIndex:i];
        [button setTitle:email forState:UIControlStateNormal];
        button.titleLabel.font = [ClarksFonts clarksSansProRegular:16.0f];
        [button sizeToFit];
        button.layer.borderColor = [ClarksColors clarksMediumGrey].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 3;
        button.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        [button setTintColor:[UIColor blackColor]];
        UIView *blocker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, button.bounds.size.width-12, button.bounds.size.height)];
        button.backgroundColor = [ClarksColors clarkLightGrey];
        //button.alpha = 0.7;
        [button addSubview:blocker];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:button];
        
        // check if first button or button would exceed maxWidth
        if ((i == 0) || (runningWidth + button.frame.size.width > maxWidth)) {
            // wrap around into next line
            runningWidth = button.frame.size.width;
            
            if (i== 0) {
                // first button (top left)
                // horizontal position: same as previous leftmost button (on line above)
                NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:horizontalSpaceBetweenButtons];
                [scrollView addConstraint:horizontalConstraint];
                
                // vertical position:
                NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop              multiplier:1.0f constant:verticalSpaceBetweenButtons];
                [scrollView addConstraint:verticalConstraint];
                
                
            } else {
                // put it in new line
                UIButton *previousLeftmostButton = [buttons objectAtIndex:indexOfLeftmostButtonOnCurrentLine];
                
                // horizontal position: same as previous leftmost button (on line above)
                NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
                [scrollView addConstraint:horizontalConstraint];
                
                // vertical position:
                NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:verticalSpaceBetweenButtons];
                [scrollView addConstraint:verticalConstraint];
                
                indexOfLeftmostButtonOnCurrentLine = i;
            }
        } else {
            // put it right from previous buttom
            runningWidth += button.frame.size.width + horizontalSpaceBetweenButtons;
            
            UIButton *previousButton = [buttons objectAtIndex:(i-1)];
            
            // horizontal position: right from previous button
            NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:horizontalSpaceBetweenButtons];
            [scrollView addConstraint:horizontalConstraint];
            
            // vertical position same as previous button
            NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
            [scrollView addConstraint:verticalConstraint];
        }
        
        [buttons addObject:button];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)didClickPlusBtn:(id)sender {
    self.containerView.hidden = NO;
    [ClarksUI reposition:self.btnSend x:f.origin.x y:434];
    if (![exportUserList containsObject:self.txtEMail.text]) {
        [exportUserList addObject:self.txtEMail.text];
        [emailList addObject:[self.txtEMail.text stringByAppendingString:@"  x"]];
        self.btnSend.enabled = YES;
        [self refreshView];
        [self.txtEMail resignFirstResponder];
    }
    self.plusBtn.enabled = NO;
    self.txtEMail.text = @"";
}

- (IBAction)onListSend:(id)sender {
    
    // Checking for internet connection.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to export a list."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.view endEditing:YES];
    [self.txtEMail resignFirstResponder];
    Lists *listToBeExported;
    NSLog(@"Self List Name :%@", self.list.listName);
    if (self.list == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        listToBeExported = [appDelegate.listofList objectAtIndex: self.index];
    }else{
        listToBeExported = self.list;
    }
    if (![self.txtEMail.text isEqualToString:@""] && [self NSStringIsValidEmail:self.txtEMail.text]){
        [exportUserList addObject:self.txtEMail.text];
    }
    NSString *itemNumbers=@"";
    BOOL firstTime = YES;
    for(ListItem *theListItems in listToBeExported.listOfItems) {
        if(firstTime) {
            firstTime = NO ;
            itemNumbers = theListItems.itemNumber;
        } else {
            itemNumbers = [NSString stringWithFormat:@"%@,%@", itemNumbers, theListItems.itemNumber];
        }
    }
    
    NSMutableSet* existingNames = [NSMutableSet set];
    NSMutableArray* mutable_user_ids = [NSMutableArray array];
    for (NSString *object in exportUserList) {
        if (![existingNames containsObject:object]) {
            [existingNames addObject:object];
            [mutable_user_ids addObject:object];
        }
    }
    
    UIView *loader = [ClarksUI showLoader:self.view];
    
    [[API instance] get:@"app-user/get-email-verification-status" onComplete:^(NSDictionary *results) {
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
            NSLog(@"Success!!!");
            [loader removeFromSuperview];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.verificationStatus  = [results valueForKey:@"emailVerificationStatus"];
            if([[results valueForKey:@"emailVerificationStatus"] isEqualToString:@"BLOCKED"]){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                AccountSettingsViewController *accountSetting = [storyboard instantiateViewControllerWithIdentifier:@"accountSettings"];
                UINavigationController *navigationController = self.navigationController;
                
                [navigationController pushViewController:accountSetting animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verification Status"
                                                                message:@"Please verify your email address"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }else{
                [[API instance] post:@"export-list" params:@{@"name":listToBeExported.listName, @"emails":[mutable_user_ids componentsJoinedByString:@","], @"items":itemNumbers} onComplete:^(NSDictionary *results) {
                    
                    if(results == nil) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"No network connectivity or server down"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        return;
                    }
                    NSString *strMsg;
                    NSString *strResult = [results valueForKey:@"status"];
                    if ([strResult isEqualToString:@"success"]) {
                        strMsg = [NSString stringWithFormat:@"Your list has successfully been exported to recipients and should be in their inbox shortly. You will also receive an email in your inbox to confirm successfully receipt."];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Export list"
                                                                        message:strMsg
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        alert.tag = 100;
                    }
                    else {
                        NSArray *errors  = [results valueForKey:@"errors"] ;
                        NSString *error_msg = @"";
                        for (NSString *error in errors){
                            error_msg = [NSString stringWithFormat:@"%@ %@",error,error_msg];
                        }
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Export list Failed"
                                                                        message: error_msg
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    
                }];
            }
        }
        else if([[results valueForKey:@"error"] isEqualToString:@"Session expired."]){
            
            NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
            NSData *data = [NSData dataWithContentsOfFile:appFile];
            NSString *content = [data base64EncodedStringWithOptions:0];
            
            if(content != nil){
                [[API instance] post:@"update-lists"
                              params:@{@"listsData": content
                                       }
                          onComplete:^(NSDictionary *results) {
                              if(results == nil) {
                                  [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
                              }
                              NSString *strResult = [results valueForKey:@"status"];
                              if ([strResult isEqualToString:@"success"]) {
                                  NSFileManager *fileManager = [NSFileManager defaultManager];
                                  NSError *error;
                                  BOOL success = [fileManager removeItemAtPath:appFile error:&error];
                                  if (success) {
                                      NSLog(@"Success!!!");
                                  }
                              }
                              else{
                                  NSLog(@"Failed");
                              }
                          }
                 ];
            }
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
    }] ;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [self goBack];
        }
    }
}

- (IBAction)doNothing:(id)sender {
    [self goBack];
}

- (IBAction)onValueChanged:(id)sender {
    if ([exportUserList count] !=0 ) {
        if ([self NSStringIsValidEmail :self.txtEMail.text]|| [self.txtEMail.text isEqualToString:@""]) {
            self.btnSend.enabled = YES;
        }else{
            self.btnSend.enabled = NO;
        }
    }else{
        if ([self NSStringIsValidEmail:self.txtEMail.text]) {
            self.btnSend.enabled = YES;
        }else{
            self.btnSend.enabled = NO;
        }
    }
    
    if ([self NSStringIsValidEmail:self.txtEMail.text] && ![self.txtEMail.text isEqualToString:@""]) {
        self.plusBtn.enabled = YES;
    }else{
        self.plusBtn.enabled = NO;
    }

    
}

-(void) onBtnClick: (UIButton *)btn{
    [btn removeFromSuperview];
    [exportUserList removeObject:[[btn.titleLabel.text componentsSeparatedByString:@"  "] objectAtIndex: 0]];
    [emailList removeObject:btn.titleLabel.text];
    [self refreshView];
    
    if ([emailList count] == 0) {
        self.btnSend.enabled = NO;
        self.containerView.hidden = YES;
        [ClarksUI reposition:self.btnSend x:f.origin.x y:434-170];
    }else{
        self.containerView.hidden = NO;
        self.btnSend.enabled = YES;
        [ClarksUI reposition:self.btnSend x:f.origin.x y:434];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/va ... l-address/
    NSString *stricterFilterString = @".*?[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    //NSString *stricterFilterString1 = @" [A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)onEditingBegin:(id)sender {
    //[self repositionButtons];
    
    
}

-(void) repositionButtons
{
    CGRect f1 = self.lbl1.frame;
    [ClarksUI reposition:self.lbl1 x:f1.origin.x y:56];
    
    f1 = self.txtEMail.frame;
    [ClarksUI reposition:self.txtEMail x:f1.origin.x y:58];
    
    f1 = self.btnSend.frame;
    [ClarksUI reposition:self.btnSend x:f1.origin.x y:230];
    
    f1= self.plusBtn.frame;
    [ClarksUI reposition:self.plusBtn x:f1.origin.x y:58];
}

-(void) unRepositionButtons
{
    CGRect f1 = self.lbl1.frame;
    [ClarksUI reposition:self.lbl1 x:f1.origin.x y:56+30];
    
    f1 = self.txtEMail.frame;
    [ClarksUI reposition:self.txtEMail x:f1.origin.x y:58+125];
    
    f1 = self.btnSend.frame;
    [ClarksUI reposition:self.btnSend x:f1.origin.x y:230+135];
    
    f1 = self.plusBtn.frame;
    [ClarksUI reposition:self.plusBtn x:f1.origin.x y:58+125];
}

- (IBAction)onEditingEnded:(id)sender {
    //[self unRepositionButtons];
    if([self.txtEMail.text isEqualToString:@""] && [exportUserList count]==0 && ![self NSStringIsValidEmail:self.txtEMail.text]){
        self.btnSend.enabled = NO;
    }else{
        self.btnSend.enabled = YES;
    }
    if ([self.txtEMail.text isEqualToString:@""]) {
        self.plusBtn.enabled = NO;
    }else{
        self.plusBtn.enabled = YES;
    }
}


@end