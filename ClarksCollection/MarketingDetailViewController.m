//
//  MarketingDetailViewController.m
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "MarketingDetailViewController.h"
#import "ManagedImage.h"
#import "MarketingMaterial.h"
#import "TemplatizedData.h"
#import "ClarksFonts.h"
#import "UILabel+dynamicSizeMe.h"
#import "SWRevealViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface MarketingDetailViewController () {
    NSMutableArray *listOfPlayers;
    UIView *translucentView;
}
@end

@implementation MarketingDetailViewController  {
    int nCurrImageIdx;
    BOOL viewLoaded;
    UIScrollView *scrollView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewLoaded = false;
    }
    return self;
}

- (IBAction)didClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.revealViewController.panGestureRecognizer.enabled = YES;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return [self.theMarketingCategory.marketingMaterials count];
}

- (NSInteger)indexOfItemView:(UIView *)view{
    return self.idx;
}
-(void) loadAllImages: (NSArray *) imageViews paths:(NSArray *) imagePaths idx:(int)index{
    if (index >= [imageViews count] || index >= [imagePaths count]) {
        return;
    }
    ManagedImage *imgView = (ManagedImage *)imageViews[index];
    NSString *path = imagePaths[index];
    [imgView loadImage:path onComplete:^{
        [self loadAllImages:imageViews paths:imagePaths idx:index+1];
    }];
}
-(void) loadAllImages: (NSArray *) imageViews paths:(NSArray *) imagePaths{
    [self loadAllImages:imageViews paths:imagePaths idx:0];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    MarketingMaterial *mat = self.theMarketingCategory.marketingMaterials[index];
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1023, 768)];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1023, 768)];
    int i = 0;
    NSMutableArray *imgViews = [[NSMutableArray alloc] init];
    NSMutableArray *imgPaths = [[NSMutableArray alloc] init];
    
    for (NSString *img in mat.detailImages) {
        CGRect frame = CGRectMake(0, 768 * i, 1023, 768);
        UIView *view1 = [[ManagedImage alloc] initWithFrame: frame];
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.jpg"];
        ((ManagedImage *)view1).image = [UIImage imageWithContentsOfFile:fullpath];
        [((ManagedImage *)view1) loadImage:img];
        ((ManagedImage *)view1).contentMode = UIViewContentModeScaleAspectFit;
        [imgViews addObject:view1];
        [imgPaths addObject:img];
        [scrollView addSubview:((ManagedImage *)view1)];
        i++;
    }
//    [self loadAllImages: imgViews paths:imgPaths];
    int height  = (int)[mat.detailImages count]* 768;
    scrollView.contentSize = CGSizeMake(1023, height+70);
    // Adding Footer View..
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, height+10, 1023, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    // Adding Up Arrow Button..
    UIButton *upBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/up-arrow-icon.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    upBtn.center = CGPointMake(CGRectGetWidth(footerView.bounds)/2.0f, 10);
    [upBtn setImage:image forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(didClickUp) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:upBtn];
    
    [scrollView addSubview: footerView];
    [view addSubview:scrollView];
    
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    viewLoaded = YES;
    self.revealViewController.delegate = self;
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    self.swipeView.bounces = NO;
    self.swipeView.currentItemIndex = self.idx;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)didClickUp{
    [scrollView setContentOffset: CGPointMake(0, -scrollView.contentInset.top) animated:YES];
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

@end
