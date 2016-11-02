//
//  AssortmentSelectViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "AssortmentSelectViewController.h"
#import "SWRevealViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "CollectionSelectViewController.h"
#import "MixPanelUtil.h"
#import "MenubarViewController.h"
#import "Region.h"
#import "Item.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AssortmentSelectViewController () {
    UIView *translucentView;
    int selectedIndex;
}
@end

@implementation AssortmentSelectViewController
@synthesize assortmentName ;

static AssortmentSelectViewController *instance = nil;

+(AssortmentSelectViewController*)getInstance{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [AssortmentSelectViewController new];
        }
    }
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.revealViewController.panGestureRecognizer.enabled = YES;
    self.revealViewController.frontViewShadowRadius = 0;
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    if ([Region getCurrent] != nil) {
        [self.assortmentDS setupRegion:@[[Region getCurrent]] ];
    }
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = (int)indexPath.row;
}

- (IBAction)onClickMenu:(id)sender {
    [self.revealViewController revealToggle:sender];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UICollectionViewCell *cell = (UICollectionViewCell *) sender;
    CollectionSelectViewController *clVC = (CollectionSelectViewController *)[segue destinationViewController];
    int index = (int)cell.tag;
    Assortment *theAssortment = [self.assortmentDS assortmentAtIndex:index];
    AssortmentSelectViewController *ass = [AssortmentSelectViewController getInstance];
    ass.assortmentName = theAssortment.name ;
    [[MixPanelUtil instance] track:@"assortment_selected"];
    [clVC setAssortment:theAssortment];
}
@end
