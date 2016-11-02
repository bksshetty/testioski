//
//  CollectionSelectViewController.m
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "CollectionSelectViewController.h"
#import "CollectionViewCellButton.h"
#import "ShoeListViewController.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "Region.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface CollectionSelectViewController (){
    UIView *translucentView;
}
@end

@implementation CollectionSelectViewController
int count = 0 ;
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
    [super viewDidLoad];
    self.btnReset.enabled = NO;
    self.btnReset.alpha = 0.5;
    [self.navigationController setNavigationBarHidden:YES];
    [self.collectionView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    self.btnApply.layer.cornerRadius = 3;
    self.btnApply.layer.borderColor = [ClarksColors gillsansGray].CGColor;
    [self.btnApply setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    self.btnApply.layer.borderWidth = 1;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    [self.collectionSelectDS updateCallback:^(BOOL btnSelected){
        if(btnSelected)
        {
            self.btnApply.enabled = YES;
            self.btnReset.enabled = YES;
            [self.btnApply setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
            self.btnApply.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
            self.btnApply.layer.borderWidth = 1;
            self.btnReset.alpha = 1.0;
        }
        else
        {
            self.btnApply.enabled = NO;
            [self.btnApply setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
            self.btnApply.layer.borderColor = [ClarksColors gillsansGray].CGColor;
            self.btnApply.layer.borderWidth = 1;
            self.btnReset.enabled = NO;
            self.btnReset.alpha = 0.5;
        }
        NSArray *selItems = [self.collectionSelectDS getListofSelectedCollections];
        if ([selItems count] == [self.collectionSelectDS.curAssortment.collections count]) {
            self.btnSelectAll.enabled = NO;
            [self.btnApply setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
            self.btnApply.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
            self.btnApply.layer.borderWidth = 1;
            self.btnSelectAll.alpha = 0.5;
        }else if ([selItems count]==0){
            [self.btnApply setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
            self.btnApply.layer.borderColor = [ClarksColors gillsansGray].CGColor;
            self.btnApply.layer.borderWidth = 1;
        }
        else{
            self.btnSelectAll.enabled = YES;
            [self.btnApply setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
            self.btnApply.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
            self.btnApply.layer.borderWidth = 1;
            self.btnSelectAll.alpha = 1.0;
        }
     }];
    self.revealViewController.frontViewShadowRadius = 0;
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
  }

-(void)viewDidAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate = self;
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

-(void) setAssortment:(Assortment *)assortment{
    [self.collectionSelectDS setupAssortment:assortment];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedAssortmentName = assortment.name;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ShoeListViewController *shoeListVC = (ShoeListViewController *)[segue destinationViewController];
    // Get the list of selected collections from datasource
    NSArray *collectionArray = [self.collectionSelectDS getListofSelectedCollections];
    [[MixPanelUtil instance] track:@"collection_selected"];
    [shoeListVC setupCollections:collectionArray];
}

-(void)setDisplayValue:(BOOL) val
{
    [self.collectionSelectDS markAllCollectionsState:val];
    for(UICollectionView *cell in self.collectionView.visibleCells)
    {
        if (val) {
            cell.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
            cell.layer.borderWidth =1 ;
        }else{
            cell.layer.borderWidth = 0;
        }
    }
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Swipe Up");
        if (translucentView.isHidden) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)onSelectAll:(id)sender {
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        cell.layer.borderWidth = 1;
    }
    if ([self.collectionView.visibleCells count]>0) {
        [self setDisplayValue:YES];
        self.btnApply.enabled = YES;
        [self.btnApply setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        self.btnApply.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        self.btnApply.layer.borderWidth = 1;
        self.btnSelectAll.enabled = NO;
        self.btnSelectAll.alpha = 0.5;
        
        self.btnReset.enabled = YES;
        self.btnReset.alpha = 1.0;
    }
}

- (IBAction)onReset:(id)sender {
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        cell.layer.borderWidth = 0;
    }
    [self setDisplayValue:NO];
    self.btnReset.enabled = NO;
    self.btnReset.alpha = 0.5;
    [self.btnApply setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
    self.btnApply.layer.borderColor = [ClarksColors gillsansGray].CGColor;
    self.btnApply.layer.borderWidth = 1;
    self.btnSelectAll.enabled = YES;
    self.btnSelectAll.alpha = 1.0;
    self.btnApply.enabled = NO;
}
@end
