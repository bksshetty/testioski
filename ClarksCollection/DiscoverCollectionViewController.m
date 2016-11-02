//
//  DiscoverCollectionViewController.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DiscoverCollectionViewController.h"
#import "SWRevealViewController.h"
#import "DiscoverCollectionDetailViewController.h"
#import "DiscoverCollection.h"
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "AssortmentSelectViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface DiscoverCollectionViewController () {
  UIView *translucentView;
}
@end

@implementation DiscoverCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusBarView.backgroundColor  =  [UIColor blackColor];
    [self.view addSubview:statusBarView];
    self.revealViewController.delegate = self;
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void) viewDidAppear:(BOOL)animated{
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.discoverCollectionView indexPathForCell:cell];
    DiscoverCollectionDetailViewController *discoverDetailVC = (DiscoverCollectionDetailViewController *) segue.destinationViewController;
    DiscoverCollection *theDiscoverCollection = [[DiscoverCollection loadAll] objectAtIndex:indexPath.row];
    discoverDetailVC.assortmentName = theDiscoverCollection.assortmentName;
    discoverDetailVC.collectionName =theDiscoverCollection.collectionName;
    [[MixPanelUtil instance] track:@"discover_selected"];
    [discoverDetailVC setDetailImages:theDiscoverCollection.detailImages];
}
@end
