//
//  ListViewController.m
//  ClarksCollection
//
//  Created by Openly on 09/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ListViewController.h"
#import "SWRevealViewController.h"
#import "ItemsinListViewController.h"
#import "AppDelegate.h"
#import "DeleteListViewController.h"
#import "DuplicateListViewController.h"
#import "ExportListViewController.h"
#import "RenameListViewController.h"
#import "MixPanelUtil.h"
#import "ClarksColors.h"
#import "Region.h"
#import "ClarksUI.h"
#import "RenameView.h"
#import "DeleteView.h"
#import "PreloadedListDataSource.h"
#import "SWRevealViewController.h"
#import "AssortmentPlanningListDataSource.h"
#import "AssortmentSelectViewController.h"
#import "API.h"
#import "DuplicateView.h"
#import "CreateListView.h"
#import "ShoeListViewController.h"
#import "Reachability.h"
#import "AccountSettingsViewController.h"
#import "SettingsUtil.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

enum ListType { USER, PRELOADED, ASSORTMENT_PLAN };
@interface ListViewController () {
    enum ListType currentSelectedType;
    UIView *translucentView;
    CreateListView *clv;
    NSString *createListView;
    NSMutableArray *emailList;
    UIScrollView *scrollView;
    NSMutableArray *btnArray;
    NSMutableArray *exportUserList ;
    CGRect f ;
}
@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)didClickEditClose:(id)sender {
    self.editView.hidden = YES;
    self.revealViewController.panGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.editView setHidden:YES ] ;
    self.yesBtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor ;
    self.yesBtn.layer.borderWidth = 1 ;
    self.yesBtn.layer.cornerRadius = 3 ;
    self.maybeLaterbtn.layer.borderWidth = 1 ;
    self.maybeLaterbtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.maybeLaterbtn.layer.cornerRadius = 3;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCreateView = @"NO";
    self.editContainerView.layer.cornerRadius =3;
    self.revealViewController.delegate = self;
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    currentSelectedType = USER;
    createListView = @"NO";
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
    NSLog(@"Width: %f and Height :%f", self.containerView.bounds.size.width, self.containerView.bounds.size.height);
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 678, 160)];
    exportUserList = [[NSMutableArray alloc] init];
    [self.containerView addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*2)];
    scrollView.delegate = self;
    scrollView.directionalLockEnabled = YES ;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    self.containerView.hidden = YES;
    self.plusBtn.enabled = NO;
    [ClarksUI reposition:self.sendBtn x:f.origin.x y:464-160];
    [self registerForNotifications];
    [self updateListButtons];
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
        [button addSubview:blocker];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        // check if first button or button would exceed maxWidth
        if ((i == 0) || (runningWidth + button.frame.size.width > maxWidth)) {
            // wrap around into next line
            runningWidth = button.frame.size.width;
            cnt++;
            NSLog(@"Count is %d", cnt);
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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/va ... l-address/
    NSString *stricterFilterString = @".*?[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void) updateListButtons{
    if (currentSelectedType != USER) {
        [self.yourListsBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
        [self.yourListsBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateHighlighted];
    }else{
        [self.staticLable setText:@"Y O U R  L I S T S"];
        self.tableView.dataSource = self.yourListDS;
        self.tableView.delegate = self.yourListDS;
        [self.yourListsBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        [self.yourListsBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateHighlighted];
    }
    if (currentSelectedType != PRELOADED) {
        [self.preloadedListsBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
        [self.preloadedListsBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateHighlighted];
    }else{
        self.staticLable.text = @"P R E - L O A D E D  L I S T S";
        self.tableView.dataSource = self.preloadedListDS;
        self.tableView.delegate = self.preloadedListDS;
        [[MixPanelUtil instance] track:@"preloadedLists"];
        [self.preloadedListsBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        [self.preloadedListsBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateHighlighted];
    }
    
    if (currentSelectedType != ASSORTMENT_PLAN) {
        [self.assortmentPlanListBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
        [self.assortmentPlanListBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateHighlighted];
    }else{
        self.staticLable.text = @"A S S O R T M E N T  P L A N N I N G  L I S T S";
        self.tableView.dataSource = self.assortmentPlanningListDS;
        self.tableView.delegate = self.assortmentPlanningListDS;
        [[MixPanelUtil instance] track:@"assortmentPlanningLists"];
        [self.assortmentPlanListBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        [self.assortmentPlanListBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateHighlighted];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isDeleteView = @"NO";
    appDelegate.isDuplicateView = @"NO";

    self.revealViewController.delegate = self;
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    [self.tableView reloadData];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
        clv.hidden = YES;
        self.revealViewController.panGestureRecognizer.enabled = YES;
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!clv.isHidden) {
            clv.hidden = YES;
            self.revealViewController.panGestureRecognizer.enabled = YES;
        }
        if (![self.exportView isHidden]) {
            self.exportView.hidden = YES;
            appDelegate.isDuplicateView = @"NO";
            [exportUserList removeAllObjects];
            self.plusBtn.enabled = NO;
            [emailList removeAllObjects];
            self.containerView.hidden = YES;
            self.exportListField.text = @"";
            [self disableSendBtn];
            [self clearView];
            [scrollView setContentOffset:
             CGPointMake(0, -scrollView.contentInset.top) animated:YES];
            [ClarksUI reposition:self.sendBtn x:f.origin.x y:464-160];
            self.revealViewController.panGestureRecognizer.enabled = YES;
        }
        self.editView.hidden = YES;
        if (self.editView.isHidden) {
            self.revealViewController.panGestureRecognizer.enabled = YES;
        }
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if([segue.identifier isEqualToString:@"displayListItems"]) {
       ItemsInListViewController *itemsInListVC = (ItemsInListViewController *)segue.destinationViewController;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[MixPanelUtil instance] track:@"displayList"];
        if (currentSelectedType == USER) {
            [itemsInListVC setListIndex:(int)indexPath.row];
            appDelegate.preloadedOrAssortmentEdit = FALSE;
        }else if (currentSelectedType == PRELOADED){
            itemsInListVC.list = [self getList:self.preloadedListDS.list[indexPath.row]];
            appDelegate.preloadedOrAssortmentEdit = TRUE;
            itemsInListVC.readOnly = YES;
        }else{
            itemsInListVC.list = [self getList:self.assortmentPlanningListDS.list[indexPath.row]];
            appDelegate.preloadedOrAssortmentEdit = TRUE;
            itemsInListVC.readOnly = YES;
        }
    }
}

- (IBAction)didClickCreate:(id)sender {
    clv = [[CreateListView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    createListView = @"YES";
    appDelegate.isDuplicateView = @"YES";
    self.revealViewController.panGestureRecognizer.enabled = NO;
    [self.view addSubview:clv];
}

-(void)actionDelete:(int) listIndex {
    self.savedListIndex = listIndex;
    DeleteView *delView = [[DeleteView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
    self.revealViewController.panGestureRecognizer.enabled = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isDeleteView = @"YES";
    [delView getIndex:listIndex];
    [self.view addSubview:delView];
}

- (IBAction)didClickYesBtn:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.activeList = [appDelegate.listofList objectAtIndex:self.savedListIndex];
    self.revealViewController.panGestureRecognizer.enabled = YES;
}

-(void)actionDuplicate:(int) listIndex {
    self.savedListIndex = listIndex;
    DuplicateView *dupView1 = [[DuplicateView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    self.revealViewController.panGestureRecognizer.enabled = NO;
    [dupView1 getIndex:listIndex];
    [self.view addSubview:dupView1];
}

-(void)actionExport:(int) listIndex {
    self.exportView.hidden = NO;
    self.savedListIndex = listIndex;
    self.revealViewController.panGestureRecognizer.enabled = NO;
    if (currentSelectedType == USER) {
        self.index = listIndex;
    }else if (currentSelectedType == PRELOADED){
        self.list = [self getList:self.preloadedListDS.list[listIndex]];
        self.index = listIndex ;
    }else{
        self.list = [self getList:self.assortmentPlanningListDS.list[listIndex]];
    }
}

-(void)actionRename:(int) listIndex {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RenameView *rnv = [[RenameView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    self.savedListIndex = listIndex;
    if (currentSelectedType == PRELOADED){
        appDelegate.preloadedOrAssortmentEdit = TRUE;
        Lists *list = [self getList:self.preloadedListDS.list[listIndex]];
        rnv.list = list;
        [self.view addSubview:rnv];
    }else if (currentSelectedType == ASSORTMENT_PLAN){
        appDelegate.preloadedOrAssortmentEdit = TRUE;
        Lists *list = [self getList:self.assortmentPlanningListDS.list[listIndex]];
        rnv.list = list;
        [self.view addSubview:rnv];
    }else{
        [rnv getIndex:listIndex];
        [self.view addSubview:rnv];
    }
    self.revealViewController.panGestureRecognizer.enabled = NO;
}

-(void)actionAddToList:(int) listIndex {
    self.savedListIndex = listIndex;
    self.revealViewController.panGestureRecognizer.enabled = NO;
    [self.editView setHidden:NO];
}

- (IBAction)selectYourList:(id)sender {
    currentSelectedType = USER;
    [self updateListButtons];
    [self.tableView reloadData];
}

- (IBAction)selectPreloadedList:(id)sender {
    currentSelectedType = PRELOADED;
    [self updateListButtons];
    [self.tableView reloadData];
}

- (IBAction)selectAssPlanList:(id)sender {
    currentSelectedType = ASSORTMENT_PLAN;
    [self updateListButtons];
    [self.tableView reloadData];
}

- (Lists *) getList:(NSDictionary *) dict{
    Lists *theList = [[Lists alloc]init];
    theList.listName = [dict valueForKey:@"name"];
    NSArray *cols = [dict valueForKey:@"color_ids"];
    for (NSString *colId in cols) {
        NSArray *itemAndCol = [self getItemColor:colId region:[Region getCurrent] ];
        ListItem *theItem = [[ListItem alloc] initWithItemAndColor:itemAndCol[0] withColor:itemAndCol[1]];
        theItem.collectionName = [NSString stringWithFormat:@"%@ - %@",itemAndCol[3], itemAndCol[2]];
        [theList addItemColorToList:theItem withPositionCheck:YES];
        
    }
    return theList;
}

- (NSArray *) getItemColor: (NSString *) colorid region:(Region *)region{
    for (Assortment *ass in region.assortments) {
        for (Collection *coll in ass.collections) {
            for (Item *item in coll.items) {
                for (ItemColor *col in item.colors) {
                    if ([col.colorId isEqualToString:colorid]) {
                        return @[ item, col, coll.name, ass.name ];
                    }
                }
            }
        }
    }
    return nil;
}

- (IBAction)didClickLater:(id)sender {
    [self.editView setHidden:YES ] ;
    self.revealViewController.panGestureRecognizer.enabled = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ItemsInListViewController *itemsInListVC = [storyboard instantiateViewControllerWithIdentifier:@"itemInList"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController pushViewController:itemsInListVC animated:YES];
    [[MixPanelUtil instance] track:@"displayList"];
    if (currentSelectedType == USER) {
        [itemsInListVC setListIndex:self.savedListIndex];
    }else if (currentSelectedType == PRELOADED){
        itemsInListVC.list = [self getList:self.preloadedListDS.list[self.savedListIndex]];
        itemsInListVC.readOnly = YES;
    }else{
        itemsInListVC.list = [self getList:self.assortmentPlanningListDS.list[self.savedListIndex]];
        itemsInListVC.readOnly = YES;
    }
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod:) name:@"delete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod:) name:@"export" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod:) name:@"duplicate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod:) name:@"edit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod:) name:@"rename" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod:) name:@"create" object:nil];
}

-(void) yourCustomMethod:(NSNotification*)_notification{
    [self.tableView reloadData];
    self.revealViewController.panGestureRecognizer.enabled = YES;
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

- (IBAction)didClickClose:(id)sender {
    self.exportView.hidden = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isDuplicateView = @"NO";
    [exportUserList removeAllObjects];
    [emailList removeAllObjects];
    self.containerView.hidden = YES;
    self.plusBtn.enabled = NO;
    self.exportListField.text = @"";
    [ClarksUI reposition:self.sendBtn x:f.origin.x y:464-160];
    [self disableSendBtn];
    [scrollView setContentOffset:
     CGPointMake(0, -scrollView.contentInset.top) animated:YES];
    [self clearView];
    self.revealViewController.panGestureRecognizer.enabled = YES;
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            self.exportView.hidden = YES;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.isDuplicateView = @"NO";
            [exportUserList removeAllObjects];
            [emailList removeAllObjects];
            self.containerView.hidden = YES;
            self.exportListField.text = @"";
            self.plusBtn.enabled = NO;
            [self disableSendBtn];
            [ClarksUI reposition:self.sendBtn x:f.origin.x y:464-160];
            self.revealViewController.panGestureRecognizer.enabled = YES;
        }
    }
}

- (IBAction)didClickPlus:(id)sender {
    [self enableSendBtn];
    if (![exportUserList containsObject:self.exportListField.text]) {
        [exportUserList addObject:self.exportListField.text];
        [emailList addObject:[self.exportListField.text stringByAppendingString:@"  x"]];
        self.exportListField.enabled = YES;
        [self refreshView];
        [self.exportListField resignFirstResponder];
    }
    self.containerView.hidden = NO;
    self.plusBtn.enabled = NO;
    self.exportListField.text = @"";

}
- (IBAction)onEditingBegin:(id)sender {
}

- (IBAction)onEditingEnd:(id)sender {
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

- (IBAction)onEditingChanged:(id)sender {
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
@end
