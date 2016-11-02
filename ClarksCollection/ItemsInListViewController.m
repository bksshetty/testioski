//
//  ItemsinListViewController.m
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ItemsInListViewController.h"
#import "AppDelegate.h"
#import "DuplicateListViewController.h"
#import "ExportListViewController.h"
#import "SingleShoeViewController.h"
#import "Lists.h"
#import "ClarksColors.h"
#import "Region.h"
#import "Reachability.h"
#import "ClarksUI.h"
#import "Assortment.h"
#import "Collection.h"
#import "Item.h"
#import "DataReader.h"
#import "PreloadedListDataSource.h"
#import "AssortmentSelectViewController.h"
#import "SWRevealViewController.h"
#import "DiscoverCollectionDetailViewController.h"
#import "MenuView.h"
#import "API.h"
#import "AccountSettingsViewController.h"
#import "User.h"
#import "SearchView.h"
#import "SettingsUtil.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface ItemsInListViewController (){
    UIView *translucentView;
    NSMutableArray *emailList;
    UIScrollView *scrollView;
    NSMutableArray *btnArray;
    NSMutableArray *exportUserList ;
    CGRect f ;
}

@end

@implementation ItemsInListViewController {
    Lists *tmpList; // Unkown error :(
    BOOL *isTableView;
}

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
    @autoreleasepool {
        [super viewDidLoad];
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Potrait-icon.png"];
        UIImage *img = [UIImage imageWithContentsOfFile:fullpath];
        [self.btnTableView setImage:img forState:UIControlStateNormal];
        if(self.list == nil){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if([appDelegate.listofList count] > 0 && [appDelegate.listofList count] > self.listItemIndex){
                self.list=[appDelegate.listofList objectAtIndex:self.listItemIndex];
            }else{
                
            }
        }
        else{
            tmpList = self.list;
        }
        self.revealViewController.delegate = self;
        translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
        [self.view addSubview:translucentView];
        translucentView.hidden = YES;
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:swipeUp];
        self.gridView.layer.borderWidth = 1;
        self.gridView.layer.borderColor = [ClarksColors gillsansBorderGray].CGColor;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.preloadedOrAssortmentEdit) {
            self.addMoreBtn.enabled = NO;
            self.addMoreBtn.alpha = 0.5;
        }else{
            self.addMoreBtn.alpha = 1;
            self.addMoreBtn.enabled = YES;
        }
        // Export List View
        [self disableSendBtn];
        self.exportView.hidden = YES;
        self.exportListField.layer.cornerRadius = 3;
        self.containerView.layer.cornerRadius = 3 ;
        UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
        [self.exportListField setLeftViewMode:UITextFieldViewModeAlways];
        [self.exportListField setLeftView:spacerView2];
        f = self.sendBtn.frame;
        emailList = [[NSMutableArray alloc] init];
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 678, 160)];
        exportUserList = [[NSMutableArray alloc] init];
        [self.containerView addSubview:scrollView];
        [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width+60, scrollView.bounds.size.height*2)];
        scrollView.delegate = self;
        scrollView.directionalLockEnabled = YES ;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        self.containerView.hidden = YES;
        self.plusBtn.enabled = NO;
        [ClarksUI reposition:self.sendBtn x:f.origin.x y:464-160];
        
        [self updateProductLabels];
        
        self.btnGridView.enabled = NO;
        NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                    target: self
                                    selector: @selector(updateProductLabels)userInfo: nil repeats: YES];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            self.exportView.hidden = YES;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.isDuplicateView = @"NO";
            [exportUserList removeAllObjects];
            [emailList removeAllObjects];
            self.containerView.hidden = YES;
            self.plusBtn.enabled = NO;
            self.exportListField.text = @"";
            [self disableSendBtn];
            [ClarksUI reposition:self.sendBtn x:f.origin.x y:464-160];
            self.revealViewController.panGestureRecognizer.enabled = YES;
        }
    }
}

-(void) onBtnClick: (UIButton *)btn{
    [btn removeFromSuperview];
    [exportUserList removeObject:[[btn.titleLabel.text componentsSeparatedByString:@"  "] objectAtIndex: 0]];
    [emailList removeObject:btn.titleLabel.text];
    [self refreshView];
    
    if ([emailList count] == 0) {
        [self disableSendBtn];
        self.containerView.hidden = YES;
        [ClarksUI reposition:self.sendBtn x:f.origin.x y:464-170];
    }else{
        self.containerView.hidden = NO;
        [self enableSendBtn];
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
    float verticalSpaceBetweenButtons = 15.0f;
    int cnt = 0;
    [self clearView];
    for (int i=0; i<emailList.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        NSString *email = [emailList objectAtIndex:i];
        [button setTitle:email forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:13];
        [button sizeToFit];
        button.layer.borderColor = [ClarksColors gillsansGray].CGColor;
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
            cnt++;
            if (cnt <4) {
                scrollView.scrollEnabled = NO;
                CGRect newFrame = self.containerView.frame;
                self.containerView.translatesAutoresizingMaskIntoConstraints = YES;
                newFrame.size.height = 50*cnt;
                [ClarksUI reposition:self.sendBtn x:f.origin.x y:304+(50*cnt)];
                if (cnt>1) {
                    verticalSpaceBetweenButtons = 22;
                }
                self.containerView.frame = newFrame;
            }else{
                scrollView.scrollEnabled = YES;
                CGRect newFrame = self.containerView.frame;
                self.containerView.translatesAutoresizingMaskIntoConstraints = YES;
                newFrame.size.height = 175;
                [ClarksUI reposition:self.sendBtn x:f.origin.x y:304+(175)];
                verticalSpaceBetweenButtons = 22;
                self.containerView.frame = newFrame;
            }
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

- (IBAction)didClickClose:(id)sender {
    self.exportView.hidden = YES;
    [self.exportListField resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isDuplicateView = @"NO";
    [exportUserList removeAllObjects];
    [emailList removeAllObjects];
    self.containerView.hidden = YES;
    self.plusBtn.enabled = NO;
    self.exportListField.text = @"";
    [self disableSendBtn];
    [scrollView setContentOffset:
     CGPointMake(0, -scrollView.contentInset.top) animated:YES];
    [ClarksUI reposition:self.sendBtn x:f.origin.x y:464-160];
    self.revealViewController.panGestureRecognizer.enabled = YES;
}

- (IBAction)didEndEditing:(id)sender {
    if([self.exportListField.text isEqualToString:@""] && [exportUserList count]==0 && ![self NSStringIsValidEmail:self.exportListField.text]){
        [self disableSendBtn];
    }else{
        [self enableSendBtn];
    }
    if ([self.exportListField.text isEqualToString:@""]) {
        self.plusBtn.enabled = NO;
    }else{
        self.plusBtn.enabled = YES;
    }
}

- (IBAction)didValueChange:(id)sender {
    if ([exportUserList count] !=0 ) {
        if ([self NSStringIsValidEmail :self.exportListField.text]|| [self.exportListField.text isEqualToString:@""]) {
            [self enableSendBtn];
        }else{
            [self disableSendBtn];
        }
    }else{
        if ([self NSStringIsValidEmail:self.exportListField.text]) {
            [self enableSendBtn];
        }else{
            [self disableSendBtn];
        }
    }
    if ([self NSStringIsValidEmail:self.exportListField.text] && ![self.exportListField.text isEqualToString:@""]) {
        self.plusBtn.enabled = YES;
    }else{
        self.plusBtn.enabled = NO;
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @".*?[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)didClickSend:(id)sender {
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
    [self.exportListField resignFirstResponder];
    Lists *listToBeExported;
    if (self.list == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        listToBeExported = [appDelegate.listofList objectAtIndex: self.index];
    }else{
        listToBeExported = self.list;
    }
    if (![self.exportListField.text isEqualToString:@""] && [self NSStringIsValidEmail:self.exportListField.text]){
        [exportUserList addObject:self.exportListField.text];
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

- (IBAction)didClickPlus:(id)sender {
    self.containerView.hidden = NO;
    [self enableSendBtn];
    if (![exportUserList containsObject:self.exportListField.text]) {
        [exportUserList addObject:self.exportListField.text];
        [emailList addObject:[self.exportListField.text stringByAppendingString:@"  x"]];
        self.exportListField.enabled = YES;
        [self refreshView];
        [self.exportListField resignFirstResponder];
    }
    self.plusBtn.enabled = NO;
    self.exportListField.text = @"";
}

- (IBAction)didClickExport:(id)sender {
    self.exportView.hidden = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isDuplicateView = @"YES";
    self.revealViewController.panGestureRecognizer.enabled = NO;
}

-(void) updateProductLabels{
    UIFont *font1 = [UIFont fontWithName:@"GillSans-Light" size:15];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: font1 forKey:NSFontAttributeName];
    float spacing = 2.0f;
    NSMutableAttributedString *aAttrString1 = [[NSMutableAttributedString alloc] initWithString:[self.list.listName uppercaseString] attributes: arialDict];
    [aAttrString1 addAttribute:NSKernAttributeName
                         value:@(spacing)
                         range:NSMakeRange(0, [self.list.listName length])];
    NSString *count = [NSString stringWithFormat:@"   (%lu products)",(unsigned long)[self.list.listOfItems count]];
    
    UIFont *font2 = [UIFont fontWithName:@"GillSans" size:7];
    NSDictionary *arialDict2 = [NSDictionary dictionaryWithObject: font2 forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString2 = [[NSMutableAttributedString alloc] initWithString:[count uppercaseString] attributes: arialDict2];
    [aAttrString2 addAttribute:NSKernAttributeName
                         value:@(spacing)
                         range:NSMakeRange(0, [count length])];
    [aAttrString1 appendAttributedString:aAttrString2];
    self.lblListTitel.attributedText  = aAttrString1;
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        if (!translucentView.isHidden) {
        }
        if (!self.exportView.isHidden) {
            self.exportView.hidden = YES;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            self.plusBtn.enabled = NO;
            appDelegate.isDuplicateView = @"NO";
            [exportUserList removeAllObjects];
            [emailList removeAllObjects];
            self.containerView.hidden = YES;
            self.exportListField.text = @"";
            [self disableSendBtn];
            [scrollView setContentOffset:
             CGPointMake(0, -scrollView.contentInset.top) animated:YES];
            [ClarksUI reposition:self.sendBtn x:f.origin.x y:464-160];
            [self.exportListField resignFirstResponder];
            self.revealViewController.panGestureRecognizer.enabled = YES;
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    @autoreleasepool {
        [super viewDidAppear:animated];
        self.revealViewController.delegate = self;
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        if (tmpList !=nil) {
            self.list = tmpList;
        }
        self.gridView.layer.borderColor = [ClarksColors gillsansBorderGray].CGColor;
        self.revealViewController.panGestureRecognizer.enabled = YES;
        CLSNSLog(@"Count: %lu", (unsigned long)[self.list.listOfItems count]);
        if(self.gridView.hidden == NO)
            [self.gridView reloadData];
        
        if(self.tableView.hidden == NO)
            [self.tableView reloadData];
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    Item *theItem = nil;
    BOOL itemFound = NO;
    if(([identifier isEqualToString:@"grid_view_to_single_shoe"]) || ([identifier isEqualToString:@"table_view_to_single_shoe"])) {
        NSIndexPath *indexPath;
        if([identifier isEqualToString:@"grid_view_to_single_shoe"]) {
            UICollectionViewCell *cell = (UICollectionViewCell *) sender;
            indexPath = [self.gridView indexPathForCell:cell];
        } else {
            UITableViewCell *cell = (UITableViewCell *) sender;
            indexPath = [self.tableView indexPathForCell:cell];
        }
        ListItem *theListItem = self.list.listOfItems[indexPath.row];
        Region *region = [Region getCurrent];
        for(Assortment *theAssortment in region.assortments) {
            for (Collection *theCollection in theAssortment.collections) {
                for(theItem in theCollection.items) {
                    if([theItem.name isEqualToString:theListItem.name]) {
                        itemFound = YES;
                        return YES; // item
                    }
                }
            }
        }
        NSString *message= [NSString stringWithFormat:@"%@ not found",theListItem.name];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not found"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES; // No validationfor other segues
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([segue.identifier isEqualToString:@"assortmentSelect"]) {
        [appDelegate markListAsActive:self.list];
    }
    if([segue.identifier isEqualToString:@"exportList"]) {
        ExportListViewController *exportListVC = (ExportListViewController *)segue.destinationViewController;
        exportListVC.list = self.list;
    }
    
    if([segue.identifier isEqualToString:@"discover_collection"]) {
        DiscoverCollectionDetailViewController *destVC = (DiscoverCollectionDetailViewController *)segue.destinationViewController;
        [destVC setupTransitionFromShoeDetail:appDelegate.discoverColl];
    }
    
    if(([segue.identifier isEqualToString:@"grid_view_to_single_shoe"]) || ([segue.identifier isEqualToString:@"table_view_to_single_shoe"])) {
        NSIndexPath *indexPath;
        if([segue.identifier isEqualToString:@"grid_view_to_single_shoe"]) {
            UICollectionViewCell *cell = (UICollectionViewCell *) sender;
            indexPath = [self.gridView indexPathForCell:cell];
        } else {
            UITableViewCell *cell = (UITableViewCell *) sender;
            indexPath = [self.tableView indexPathForCell:cell];
        }
        SingleShoeViewController *singleShoeViewController = (SingleShoeViewController *) segue.destinationViewController;
        ListItem *theListItem = self.list.listOfItems[indexPath.row];
        Region *region = [Region getCurrent];
        Item *theItem = nil;
        BOOL itemFound = NO;
        for(Assortment *theAssortment in region.assortments) {
            for (Collection *theCollection in theAssortment.collections) {
                for(theItem in theCollection.items) {
                    if([theItem.name isEqualToString:theListItem.name]) {
                        itemFound = YES;
                        theItem.collectionName = theCollection.name;
                        break; // item
                    }
                }
                if(itemFound)
                    break; // Collection
            }
            if(itemFound)
                break; // Assortment
        }
        int i=0;
        ItemColor *theColor;
        for(i=0; i<[theItem.colors count]; i++) {
            theColor = [theItem.colors objectAtIndex:i];
            if([theColor.colorId isEqualToString:theListItem.itemNumber]) {
                break;
            }
        }
        [singleShoeViewController setItem:theItem withColorIndex:i ];
    }
}

-(void)setListIndex:(int)index {
    self.listItemIndex = index;
}

-(void) showTableOrGridView{
    if (isTableView) {
        self.gridView.hidden = YES;
        self.tableView.hidden=NO;
        [self.tableView reloadData];
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/landscape-icon.png"];
        UIImage *img = [UIImage imageWithContentsOfFile:fullpath];
        [self.btnTableView setImage:img forState:UIControlStateNormal];
        self.tableView.layer.borderColor = [ClarksColors gillsansBorderGray].CGColor;
    }else{
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Potrait-icon.png"];
        UIImage *img = [UIImage imageWithContentsOfFile:fullpath];
        [self.btnTableView setImage:img forState:UIControlStateNormal];
        self.gridView.hidden = NO;
        self.gridView.layer.borderWidth = 1;
        self.gridView.layer.borderColor = [ClarksColors gillsansBorderGray].CGColor;
        
        self.tableView.hidden=YES;
        [self.gridView reloadData];
    }
}

- (IBAction)onTableView:(id)sender {
    isTableView = !isTableView;
    [self showTableOrGridView];
}

-(void) enableSendBtn{
    self.sendBtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.sendBtn.layer.borderWidth = 1;
    self.sendBtn.layer.cornerRadius = 3;
    [self.sendBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
    self.sendBtn.enabled = YES;
}

-(void) disableSendBtn{
    self.sendBtn.layer.borderColor = [ClarksColors gillsansGray].CGColor;
    self.sendBtn.layer.borderWidth = 1;
    self.sendBtn.layer.cornerRadius = 3;
    [self.sendBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
    self.sendBtn.enabled = NO;
}
@end
