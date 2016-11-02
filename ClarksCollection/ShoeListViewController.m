		//
//  ShoeListViewController.m
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ShoeListViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "AppDelegate.h"
#import "SingleShoeViewController.h"
#import "ListItem.h"
#import "ItemsinListViewController.h"
#import "ClarksUI.h"
#import "Filters.h"
#import "MixPanelUtil.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define kMaxIdleTimeSeconds 3.0

@interface ShoeListViewController (){
    NSArray *selectedCollections;
    BOOL isSlidePanelOpen;
    UIView *translucentView;
    UIView *translucentView1;
    UIView *translucentView2;
    NSString *isFilterView;
    NSString *isSearchView;
    NSString *isListView;
    NSString *handleTimer;
    NSTimer *idleTimer;
}
@end

@implementation ShoeListViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isSlidePanelOpen = NO;
        // Custom initialization
    }
    return self;
}


- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        isSlidePanelOpen = NO;
    }
    return self;
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left");
        if (self.filterView.isHidden) {
            self.navBar.hidden = NO;
            isListView = @"YES";
            self.revealViewController.panGestureRecognizer.enabled = NO;
            translucentView2.hidden = NO;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            Lists *activeList = appDelegate.activeList;
            if(activeList == nil) {
                [self hideAllSlideOutViews];
                [self slideOutCollectionView];
                self.selectListView.hidden = NO;
                [self.itemListTableView reloadData];
            }else {
                if(isSlidePanelOpen) {
                    [self slideBackInCollectionView];
                    [self hideAllSlideOutViews];
                    self.tmpItem = nil;
                    isSlidePanelOpen = NO;
                    return;
                }
                [self hideAllSlideOutViews];
                [self slideOutCollectionView];
                self.itemListView.hidden = NO;
                [self.listItemDS setUpData];
                [self.listTable reloadData];
                [self updateListViewListNameLabel];
                self.backFromListChange.hidden = NO;
            }
        }
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
        isListView = @"NO";
        translucentView2.hidden = YES;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.isDuplicateView = @"NO";
        if (self.btnTopBarFilter.isHidden) {
            if (self.isActiveList ) {
                self.listLbl.hidden = NO;
            }else{
                self.listLbl.hidden = YES;
            }
        }else{
            self.listLbl.hidden = YES;
        }
        self.itemListView.hidden = YES;
        self.saveListView.hidden = YES;
        self.selectListView.hidden = YES;
        self.theNewListView.hidden = YES;
        self.noListView.hidden = YES;
        
        if ([isSearchView isEqualToString:@"YES"] || [isFilterView isEqualToString:@"YES"]) {
            self.revealViewController.panGestureRecognizer.enabled = NO;
            self.navBar.hidden = YES;
        }else{
            self.revealViewController.panGestureRecognizer.enabled = YES;
            self.navBar.hidden = NO;
        }
        [self slideBackInCollectionView];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        handleTimer = @"NO";
        if (![isSearchView isEqualToString:@"YES"] && !(self.revealViewController.frontViewPosition == FrontViewPositionRight)&&
            self.filterView.isHidden &&
            self.selectListView.isHidden &&
            self.itemListView.isHidden &&
            self.noListView) {
            self.btnTopBarFilter.hidden = NO;
            self.backBtn.hidden = NO;
            self.menuBtn.hidden = YES;
            self.btnSearch.hidden = YES;
            self.btnOpenList.hidden = YES;
            self.logo.hidden = YES;
            self.listLbl.hidden = YES;
        }
        NSLog(@"Swipe Up");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown ) {
        NSLog(@"Swipe Down");
        handleTimer = @"YES";
        if (!(self.revealViewController.frontViewPosition == FrontViewPositionRight) &&
            self.filterView.isHidden &&
            self.selectListView.isHidden &&
            self.itemListView.isHidden &&
            self.noListView) {
            if (self.isActiveList ) {
                self.listLbl.hidden = NO;
            }else{
                self.listLbl.hidden = YES;
            }
            self.btnTopBarFilter.hidden = YES;
            self.backBtn.hidden = YES;
            self.menuBtn.hidden = NO;
            self.btnSearch.hidden = NO;
            self.btnOpenList.hidden = NO;
            self.logo.hidden = NO;
        }
    }
}

#pragma mark - Search

- (IBAction)onSearch:(id)sender {
    [self closeLeftSlideOut:sender];
    [self.searchView setHidden:NO];
    isSearchView = @"YES";
    self.revealViewController.panGestureRecognizer.enabled = NO;
    [self.topBarView setHidden:YES];
    [self.navBar setHidden: YES];
    [self.filterView setHidden:YES];
}

- (IBAction)performSearch:(id)sender {
    self.revealViewController.panGestureRecognizer.enabled = YES;
    [self searchHelper:self.txtSearch.text];
    [self.navBar setHidden: NO];
    isSearchView = @"NO";
}

-(void) unRepositionSearchViewButtons {
    CGRect f = self.txtSearch.frame;
    [ClarksUI reposition:self.txtSearch x:f.origin.x y:318];
    f = self.btnSearchViewSearch.frame;
    [ClarksUI reposition:self.btnSearchViewSearch x:f.origin.x y:338];
}

-(void) repositionSearchViewButtons {
    CGRect f = self.txtSearch.frame;
    [ClarksUI reposition:self.txtSearch x:f.origin.x y:318-100];
    f = self.btnSearchViewSearch.frame;
    [ClarksUI reposition:self.btnSearchViewSearch x:f .origin.x y:338-100];
}

-(void)searchHelper:(NSString *)searchString{
    self.shoeListDS.searchTerm = searchString;
    [self.shoeListDS setupFilterArray];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[MixPanelUtil instance] track:@"search"];
    if([appDelegate.filtereditemArray count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"
                                                        message:@"No results found."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self.shoeListCollectionView reloadData];
    [self.filterTable reloadData];
    [self.txtSearch resignFirstResponder];
    [self.searchView setHidden:YES];
    [self.topBarView setHidden:NO];
}

- (IBAction)closeSearchView:(id)sender {
    isSearchView = @"NO";
    [self.txtSearch setText:@""];
    [self searchHelper:@""];
    [self.navBar setHidden: NO];
    self.revealViewController.panGestureRecognizer.enabled = YES;
}

#pragma mark - Filter
- (IBAction)onCloseFilter:(id)sender {
    self.revealViewController.panGestureRecognizer.enabled = YES;
    isFilterView = @"NO";
    [self.filterView setHidden:YES];
    [self.topBarView setHidden:NO];
    translucentView1.hidden = YES;
    self.navBar.hidden = NO;
}

- (IBAction)onFilterClearAll:(id)sender {
    self.txtSearch.text= @"";
    [self.shoeListDS resetFilterArrayFromFilterList];
    [self.filterTable reloadData];
    [self.shoeListCollectionView reloadData];
}

-(void) viewDidUnload{
    [self.view removeFromSuperview];
    self.view = nil;
    [super viewDidUnload];
}

-(void) dealloc{
        [self.view removeFromSuperview];
        self.view = nil ;
        self.shoeListCollectionView = nil ;
        [self.shoeListCollectionView removeFromSuperview];
    
        self.searchView = nil ;
        [self.searchView removeFromSuperview];
    
        self.saveListView = nil;
        [self.saveListView removeFromSuperview];
    
        self.itemListView = nil ;
        [self.itemListView removeFromSuperview];
    
        self.selectListView = nil ;
}

- (IBAction)onFilter:(id)sender {
    self.revealViewController.panGestureRecognizer.enabled = NO;
    [self closeLeftSlideOut:sender];
    isFilterView = @"YES";
    [self.filterView setHidden:NO];
    self.filterTable.layer.cornerRadius = 5;
    translucentView1.hidden = NO;
    self.btnApply.layer.borderColor = [ClarksColors gillsansGray].CGColor;
    self.btnApply.layer.borderWidth = 1;
    self.btnApply.layer.cornerRadius = 5;
}

- (IBAction)onFilterApply:(id)sender {
    self.revealViewController.panGestureRecognizer.enabled = YES;
    isFilterView = @"NO";
    self.navBar.hidden = NO;
    NSArray *selectedFilters = [self.filterTable indexPathsForSelectedRows];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[MixPanelUtil instance] track:@"filter"];
    if(selectedFilters == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No filter selected"
                                                        message:@"No filter selected to proceed."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.txtSearch.text= @"";
    NSMutableDictionary *appliedFilters = [[NSMutableDictionary alloc] init];
    for (NSIndexPath *thisPath in selectedFilters) {
        NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)thisPath.section ];
        NSString *predicate = [[self.filterDS.filters[thisPath.section] valueForKey:@"options"][thisPath.row] valueForKey:@"query"];
        if ([appliedFilters valueForKey: sectionStr] != nil) {
            [[appliedFilters valueForKey: sectionStr] addObject: predicate];
        }else{
            NSMutableArray *sectOpts = [[NSMutableArray alloc] init];
            [sectOpts addObject:predicate];
            [appliedFilters setObject:sectOpts forKey:sectionStr];
        }
    }
    self.shoeListDS.filters = appliedFilters;
    [self.shoeListDS setupFilterArrayFromFilterList];
    if([appDelegate.filtereditemArray count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Filter"
                                                        message:@"No results found for your filter criteria."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [self.shoeListDS resetFilterArrayFromFilterList];
        translucentView1.hidden = NO;
        [alert show];
        return;
    }else{
        translucentView1.hidden = YES;
    }
    
    [self.filterView setHidden:YES];
    [self.shoeListCollectionView reloadData];
}

#pragma mark - List
- (IBAction)onListClearAll:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    [curList emptyList];
    [self.listItemDS setUpEmptyData];
    [self updateListViewListNameLabel];
    for(Item *theItem in appDelegate.filtereditemArray)
        [theItem markItemAsDeselected];
    [appDelegate saveList];
    [self.shoeListCollectionView reloadData];
    [self.listTable reloadData];
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

- (IBAction)onPerformCreateNewList:(id)sender {
    NSString *newListName = [self.txtNewList.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.view endEditing:YES];
    [self.txtNewList resignFirstResponder];
    BOOL uniqueListName = YES;
    for(Lists *theList in appDelegate.listofList) {
        if([theList.listName isEqualToString:newListName]) {
            uniqueListName = NO;
            break;
        }
    }
    if(uniqueListName == NO){
        NSString *message= [NSString stringWithFormat:@"%@ already exits",newListName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already exists"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self hideAllSlideOutViews];
    Lists *newList = [[Lists alloc]init];
    newList.listName = newListName;
    if(self.tmpItem != nil) { // We had a parked item to add
        [newList addItemToList:self.tmpItem];
        self.tmpItem = nil;
    }
    [appDelegate.listofList addObject:newList];
    [appDelegate markListAsActive:newList];
    [appDelegate saveList];
    [self.shoeListCollectionView reloadData];
    [self updateListViewListNameLabel];
    [self showListView];
}

- (IBAction)goBackToListInShoeList:(id)sender{
    [self hideAllSlideOutViews];
    [self showListView];
}

- (IBAction)onChangeList:(id)sender {
    [self onOpenAList:sender];
}

- (IBAction)onOpenAList:(id)sender {
    handleTimer = @"NO";
    isListView = @"YES";
    self.listLbl.hidden = NO;
    translucentView2.hidden = NO;
    self.revealViewController.panGestureRecognizer.enabled = NO;
    [self hideAllSlideOutViews];
    [self slideOutCollectionView];
    self.selectListView.hidden = NO;
    self.listLbl.hidden = NO;
    if (self.isActiveList ) {
        self.listLbl.hidden = NO;
    }else{
        self.listLbl.hidden = YES;
    }
    self.btnTopBarFilter.hidden = YES;
    self.backBtn.hidden = YES;
    self.menuBtn.hidden = NO;
    self.btnSearch.hidden = NO;
    self.btnOpenList.hidden = NO;
    self.logo.hidden = NO;
    [self.itemListTableView reloadData];
}

- (IBAction)onCollectionChange:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCreateNewList:(id)sender {
    self.revealViewController.panGestureRecognizer.enabled = NO;
    translucentView2.hidden = NO;
    [self hideAllSlideOutViews];
    self.txtNewList.text = @"";
    self.theNewListView.hidden = NO;
}

-(void)updateListTable {
    [self updateListViewListNameLabel];
    [self.listItemDS setUpData];
    if(self.itemListView.hidden)
        return;
   [self.listTable reloadData];
}

- (IBAction)onEditingBegin:(id)sender {
    [self repositionNewListViewButtons];
}

- (IBAction)onEditingEnded:(id)sender {
    [self unRepositionNewListViewButtons];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   [self repositionSearchViewButtons ];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self unRepositionSearchViewButtons] ;
}

- (IBAction)closeLeftSlideOut:(id)sender {
    [self slideBackInCollectionView];
    [self hideAllSlideOutViews];
    self.tmpItem = nil;
}

-(void)setupCollections:(NSArray *)collections {
    selectedCollections = collections;
    [self.shoeListDS setupCollections:collections];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.itemList = self.shoeListDS.itemArray;
    NSArray *filters = [Filters filtersForCollections:selectedCollections];
    [self.filterDS setFilters:filters];
}

#pragma mark Handling idle timeout

- (void)resetIdleTimer {
    if (!idleTimer) {
        idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds
                                                      target:self
                                                    selector:@selector(idleTimerExceeded)
                                                    userInfo:nil
                                                     repeats:NO];
    }
    else {
        if (fabs([idleTimer.fireDate timeIntervalSinceNow]) < kMaxIdleTimeSeconds-1.0) {
            [idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
        }
    }
}

- (void)idleTimerExceeded {
    idleTimer = nil;
    if (![handleTimer isEqualToString:@"YES"]) {
        self.btnTopBarFilter.hidden = NO;
        self.backBtn.hidden = NO;
        self.menuBtn.hidden = YES;
        self.btnSearch.hidden = YES;
        self.btnOpenList.hidden = YES;
        self.logo.hidden = YES;
        self.listLbl.hidden = YES;
        [self resetIdleTimer];
    }
}

- (UIResponder *)nextResponder {
    [self resetIdleTimer];
    return [super nextResponder];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self resetIdleTimer];
    self.listLbl.hidden = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                    target:self
                                    selector:@selector(updateListLabel)
                                    userInfo:nil repeats:YES
    ];
    self.shoeListDS.itemArray = appDelegate.itemList;
    self.revealViewController.delegate = self;
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.backgroundColor = [UIColor clearColor];
    translucentView.hidden = YES;
    translucentView1 = [[UIView alloc] initWithFrame:CGRectMake(300, 0, 724,768)];
    translucentView1.backgroundColor = [UIColor blackColor];
    translucentView1.alpha = 0.85;
//    [self.view addSubview:translucentView1];
    translucentView1.hidden = YES;
    translucentView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 724,768)];
    translucentView2.backgroundColor = [UIColor blackColor];
    translucentView2.alpha = 0.85;
    [self.view addSubview:translucentView2];
    translucentView2.hidden = YES;
    self.btnNewList.layer.borderWidth = 1;
    self.btnNewList.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.btnNewList.layer.cornerRadius = 3;
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusBarView.backgroundColor  =  [UIColor blackColor];
    [self.view addSubview:statusBarView];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.topBarView addGestureRecognizer:swipeLeft];
    [self.rightView addGestureRecognizer:swipeLeft];
    UIPanGestureRecognizer *panLeft = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan)];
    [self.rightView addGestureRecognizer:panLeft];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [self.txtSearch setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtSearch setLeftView:spacerView2];
    self.searchView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    self.txtSearch.layer.cornerRadius = 3;
    self.txtSearch.backgroundColor = [UIColor whiteColor];
    self.btnSearch.hidden = YES;
    self.btnOpenList.hidden = YES;
    self.menuBtn.hidden = YES;
    self.activeListName.hidden = YES;
    self.btnCreateNewList.enabled = NO;
    self.btnCreateNewList.layer.cornerRadius = 3;
    self.btnCreateNewList.layer.borderColor = [ClarksColors gillsansGray].CGColor;
    [self.btnCreateNewList setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
    self.btnCreateNewList.layer.borderWidth = 1;
    self.logo.hidden = YES;
    self.navBar.layer.borderWidth =1;
    self.navBar.layer.borderColor = [ClarksColors clarksBorderGray].CGColor;
    UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [self.txtNewList setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtNewList setLeftView:spacerView3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.txtNewList];
    self.txtNewList.delegate = self;
    self.txtNewList.layer.cornerRadius = 3;
    isListView = @"NO";
    self.filterTable.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.filterTable.backgroundColor  =[UIColor whiteColor];
    self.shoeListCollectionView.layer.borderColor = [ClarksColors gillsansBorderGray].CGColor;
    self.shoeListCollectionView.layer.borderWidth = 1;
    [self.txtSearch addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    self.filterView.alpha = 1.0;
    self.backFromListChange.hidden = YES;
    self.revealViewController.frontViewShadowRadius = 0;
    [self listViewUIHelper];
}

-(void) didPan{
    if (![isSearchView isEqualToString:@"YES"] && self.filterView.isHidden) {
//        self.navBar.hidden = YES;
        isListView = @"YES";
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.isDuplicateView = @"YES";
        self.revealViewController.panGestureRecognizer.enabled = NO;
        translucentView2.hidden = NO;
        Lists *activeList = appDelegate.activeList;
        if(activeList == nil) {
            [self hideAllSlideOutViews];
            [self slideOutCollectionView];
            self.selectListView.hidden = NO;
            [self.itemListTableView reloadData];
        }else {
            [self hideAllSlideOutViews];
            [self slideOutCollectionView];
            self.itemListView.hidden = NO;
            [self.listItemDS setUpData];
            [self.listTable reloadData];
            [self updateListViewListNameLabel];
            self.backFromListChange.hidden = NO;
        }
    }
}

-(void)textFieldDidChange: (UITextField *)field{
    if ([self.txtNewList.text isEqualToString:@""]) {
        self.btnCreateNewList.enabled = NO;
        self.btnCreateNewList.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        [self.btnCreateNewList setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        self.btnCreateNewList.layer.borderWidth = 1;
    }else{
        self.btnCreateNewList.enabled = YES;
        self.btnCreateNewList.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        [self.btnCreateNewList setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        self.btnCreateNewList.layer.borderWidth = 1;
    }
}

- (IBAction)didListOpen:(id)sender {
    [self didPan];
}

-(void) updateListLabel{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIFont *font1 = [UIFont fontWithName:@"GillSans-Light" size:15];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: font1 forKey:NSFontAttributeName];
    float spacing = 2.0f;
    if (appDelegate.activeList != nil) {
        NSMutableAttributedString *aAttrString1 = [[NSMutableAttributedString alloc] initWithString:[appDelegate.activeList.listName uppercaseString] attributes: arialDict];
        [aAttrString1 addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [appDelegate.activeList.listName length])];
        NSString *count = [NSString stringWithFormat:@" %lu",(unsigned long)[appDelegate.activeList.listOfItems count]];
        self.listLbl.text = count;
        UIFont *font2 = [UIFont fontWithName:@"GillSans-Light" size:13];
        NSDictionary *arialDict2 = [NSDictionary dictionaryWithObject: font2 forKey:NSFontAttributeName];
        NSMutableAttributedString *aAttrString2 = [[NSMutableAttributedString alloc] initWithString:[count uppercaseString] attributes: arialDict2];
        [aAttrString2 addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [count length])];
        [aAttrString1 appendAttributedString:aAttrString2];
        
        self.activeListName.attributedText  = aAttrString1;
        [self.activeListName sizeToFit];
        self.activeListName.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2.0f,33 );
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.activeListName addGestureRecognizer:tapGestureRecognizer];
        self.activeListName.userInteractionEnabled = YES;
    }
}

-(void) labelTapped{
    [self didPan];
}

-(void)textChanged:(UITextField *)textField{
    if([self.txtSearch.text length] > 0)
        self.btnSearchViewSearch.enabled = YES;
    else
        self.btnSearchViewSearch.enabled = NO;
}
-(void) hideAllSlideOutViews {
    [self.shoeListCollectionView setUserInteractionEnabled:YES];
    self.itemListView.hidden = YES;
    self.saveListView.hidden = YES;
    self.selectListView.hidden = YES;
    self.theNewListView.hidden = YES;
    self.searchView.hidden = YES;
    isSlidePanelOpen = NO;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navBar.hidden = NO;
    [self.filterTable flashScrollIndicators];
    self.filterTable.showsVerticalScrollIndicator = true;
//    self.filterTable.s
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    translucentView2.hidden = YES;
    self.txtSearch.delegate = self;
    self.txtNewList.delegate = self;
    self.itemListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    if([self.txtSearch.text length] > 0)
        self.btnSearchViewSearch.enabled = YES;
    else
        self.btnSearchViewSearch.enabled = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)[appDelegate.activeList.listOfItems count]];
    self.listLbl.text = count;
    Lists *activeList = appDelegate.activeList;
    if(activeList != nil) {
        self.btnNavBarList.hidden = NO;
        NSString *strCurrListName =activeList.listName;
        NSString *title = [NSString stringWithFormat:@"%@ (%d)",strCurrListName, [activeList noOfItemsInList:strCurrListName]];
        [self.btnNavBarList setTitle:title forState:UIControlStateNormal];
        [self.btnNavBarList setTitle:title forState:UIControlStateHighlighted];
        [self.btnNavBarList setTitle:title forState:UIControlStateSelected];
    }else { //Hide the name
        self.btnNavBarList.hidden = YES;
    }
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self.shoeListCollectionView reloadData];
}

-(void) addItemToActiveList:(Item *)theItem {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if (self.isActiveList ) {
        self.listLbl.hidden = NO;
    }else{
        self.listLbl.hidden = YES;
    }
    self.btnTopBarFilter.hidden = YES;
    self.backBtn.hidden = YES;
    self.menuBtn.hidden = NO;
    self.btnSearch.hidden = NO;
    self.btnOpenList.hidden = NO;
    self.logo.hidden = NO;
    if(activeList != nil) {
        [activeList addItemToList:theItem];
        [appDelegate saveList];
    }
}

-(void) removeItemFromActiveList:(Item *)theItem {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if(activeList == nil)
        return;
    [activeList deleteItemFromList:theItem];
    [appDelegate saveList];
    return;
}

-(void) performNoActiveList {
    [self.shoeListCollectionView setUserInteractionEnabled:NO];
    self.revealViewController.panGestureRecognizer.enabled = NO;
    [self onOpenAList:nil];
    return;
}

-(BOOL) isActiveList {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if(activeList != nil){
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(self.searchView.hidden == NO)
        [self performSearch:self];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onListName:(id)sender {
    [self onShowListSlideOut:sender];
}

- (IBAction)onShowCreateSelectNewList:(id)sender {
    self.revealViewController.panGestureRecognizer.enabled = NO;
    translucentView2.hidden = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if(activeList == nil) {
        [self onOpenAList:sender];
    }else {
        [self onShowListSlideOut:sender];
    }
}

- (IBAction)onShowListSlideOut:(id)sender {
    if(isSlidePanelOpen) {
        [self closeLeftSlideOut:sender];
        isSlidePanelOpen = NO;
        return;
    }
    self.revealViewController.panGestureRecognizer.enabled = NO;
    translucentView2.hidden = NO;
    [self hideAllSlideOutViews];
    [self slideOutCollectionView];
    self.itemListView.hidden = NO;
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self updateListViewListNameLabel];
    self.backFromListChange.hidden = NO;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([segue.identifier isEqualToString:@"shoeDetail"]) {
        UICollectionViewCell *cell = sender;
        NSIndexPath *indexPath = [self.shoeListCollectionView indexPathForCell:cell];
        SingleShoeViewController *ssvc = (SingleShoeViewController *) segue.destinationViewController;
        [[MixPanelUtil instance] track:@"shoe_selected"];
        [ssvc setItem: appDelegate.filtereditemArray[(int)indexPath.row] withColorIndex:0];
    }
    if([segue.identifier isEqualToString:@"viewList"]) {
        ItemsInListViewController *itemsInListVC = (ItemsInListViewController *)segue.destinationViewController;
        int index = (int)[appDelegate.listofList indexOfObject:appDelegate.activeList];
        [self.shoeListCollectionView setUserInteractionEnabled:YES];
        [itemsInListVC setListIndex:index];
     }
}

-(void) listViewUIHelper{
    self.viewListItem.layer.cornerRadius = 3;
    self.viewListItem.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.viewListItem.layer.borderWidth = 1;
}

-(void) unRepositionNewListViewButtons {
    CGRect f = self.lblCreateANewList.frame;
    [ClarksUI reposition:self.lblCreateANewList x:f.origin.x y:189];
    f = self.txtNewList.frame;
    [ClarksUI reposition:self.txtNewList x:f.origin.x y:287];
    f = self.btnCreateNewList.frame;
    [ClarksUI reposition:self.btnCreateNewList x:f.origin.x y:364];
}

-(void) repositionNewListViewButtons {
    CGRect f = self.lblCreateANewList.frame;
    [ClarksUI reposition:self.lblCreateANewList x:f.origin.x y:189-100];
    f = self.txtNewList.frame;
    [ClarksUI reposition:self.txtNewList x:f.origin.x y:287-100];
    f = self.btnCreateNewList.frame;
    [ClarksUI reposition:self.btnCreateNewList x:f.origin.x y:364-100];
}

-(void) deleteCollectionViewChecks:(NSString *)itemName{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for(Item *theItem in appDelegate.filtereditemArray) {
        if([theItem.name isEqualToString:itemName]) {
            [theItem markItemAsDeselected];
            [self.shoeListCollectionView reloadData];
            return;
        }
    }
}

-(void) slideOutCollectionView{
    self.revealViewController.panGestureRecognizer.enabled = NO;
    isSlidePanelOpen = YES;
    [ClarksUI setWidth:self.shoeListCollectionView width:722];
}

-(void) slideBackInCollectionView{
    isSlidePanelOpen = NO;
    [ClarksUI setWidth:self.shoeListCollectionView width:1024];
}

-(void) updateListViewListNameLabel {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    int count = (int)[curList.listOfItems count] ;
    NSString *productCount = [[NSString stringWithFormat:@"(%lu PRODUCTS)",(unsigned long)[curList.listOfItems count]] uppercaseString];
    self.lblListName.attributedText = [ClarksFonts addSpaceBwLetters:[curList.listName uppercaseString] alpha:2.0];
    self.lblProductCount.attributedText = [ClarksFonts addSpaceBwLetters:productCount alpha:2.0];
    self.btnNavBarList.hidden = NO;
    NSString *title = [NSString stringWithFormat:@"%@ (%lu)",curList.listName, (long)curList.listOfItems.count];
    [self.btnNavBarList setTitle:title forState: UIControlStateNormal];
    [self.btnNavBarList setTitle:title forState: UIControlStateHighlighted];
    [self.btnNavBarList setTitle:title forState: UIControlStateSelected];
    if(count <=0)
    {
        self.viewListItem.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        [self.viewListItem setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        self.btnCloseItemList.enabled = NO;
        [self.btnCloseItemList setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        self.viewListItem.enabled = NO;
        self.noListView.hidden = NO;
        self.listTable.hidden = YES;
        self.btnListClearAll.hidden = YES;
    }else{
        self.viewListItem.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        [self.viewListItem setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        self.viewListItem.enabled = YES;
        self.btnCloseItemList.enabled = YES;
        [self.btnCloseItemList setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
        self.noListView.hidden = YES;
        self.listTable.hidden = NO;
        self.btnListClearAll.hidden=NO;
    }
}
-(void) showListView{
    isListView = @"YES";
    [self slideOutCollectionView];
    self.revealViewController.panGestureRecognizer.enabled = NO;
    translucentView2.hidden = NO;
    self.backFromListChange.hidden = NO ;
    self.itemListView.hidden = NO;
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self.shoeListCollectionView reloadData];
    [self updateListViewListNameLabel];
}

-(void) viewWillAppear:(BOOL)animated{
    translucentView2.hidden = YES;
    isListView = @"NO";
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self slideBackInCollectionView];
    [self hideAllSlideOutViews];
}
- (IBAction)didClickMenu:(id)sender {
    [self.revealViewController revealToggle:sender];
}
- (IBAction)didClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
