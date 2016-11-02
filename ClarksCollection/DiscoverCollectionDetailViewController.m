//
//  DiscoverCollectionDetailViewController.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DiscoverCollectionDetailViewController.h"
#import "ShoeListViewController.h"
#import "Region.h"
#import "Assortment.h"
#import "AppDelegate.h"
#import "Collection.h"
#import "SWRevealViewController.h"
#import "ManagedImage.h"
#import "DiscoverCollection.h"
#import "MixPanelUtil.h"

@interface DiscoverCollectionDetailViewController () {
    NSArray *images;
    int nCurrImageIdx;
    UIView *translucentView;
}
@end

@implementation DiscoverCollectionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusBarView.backgroundColor  =  [UIColor blackColor];
    [self.view addSubview:statusBarView];
    [self.navigationController setNavigationBarHidden:YES];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    self.revealViewController.delegate = self;
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void) viewDidAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate = self;
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        if (translucentView.isHidden) {
            [self.navigationController popViewControllerAnimated:YES];
        }
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

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return [images count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        CGRect frame = CGRectMake(0, 0, 1024, 704);
        view = [[ManagedImage alloc] initWithFrame: frame];
    }
    NSString *strImgName = images[index];
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.jpg"];
    ((ManagedImage *)view).image = [UIImage imageWithContentsOfFile:fullpath];
    [((ManagedImage *)view) loadImage:strImgName];
    ((ManagedImage *)view).contentMode = UIViewContentModeScaleAspectFit;
    return view;
}

-(void) setupTransitionFromShoeDetail:(NSString *)theCollectionName {
    DiscoverCollection *theDiscoverCollection;
    self.collectionName = theCollectionName;
    for(theDiscoverCollection in [DiscoverCollection loadAll]) {
        if([theDiscoverCollection.collectionName isEqualToString:theCollectionName]) {
            break;
        }
    }
    images = theDiscoverCollection.detailImages;
    self.assortmentName = theDiscoverCollection.assortmentName;
    return;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShoeListViewController *shoeListVC = (ShoeListViewController *)[segue destinationViewController];
    // Get the list of selected collections from datasource
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Region *curRegion = [Region getCurrent];
    NSArray *theCollectionArray ;
    for(Assortment *theAssortment in curRegion.assortments) {
        if([theAssortment.name isEqualToString:self.assortmentName]) {
            for (Collection *theCollection in theAssortment.collections) {
                if([theCollection.name isEqualToString:self.collectionName]) {
                    theCollectionArray = [[NSArray alloc]initWithObjects:theCollection, nil];
                    [shoeListVC setupCollections:theCollectionArray];
                    appDelegate.selectedAssortmentName = self.assortmentName;
                    return;
                }
            }
        }
    }
    
    
}

-(void)setDetailImages:(NSArray *)theImages; {
    images = theImages;
}

@end