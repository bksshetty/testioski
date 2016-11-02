//
//  MarketingViewController.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "MarketingViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "MarketingCategory.h"
#import "AssortmentSelectViewController.h"
#import "MarketingDetailViewController.h"
#import "MarketingMaterial.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "ClarksUI.h"
#import "MarketingMaterialViewController.h"
#import "MixPanelUtil.h"

@interface MarketingViewController (){
    UIView *translucentView;
    MarketingCategory *cat;
}
@end

@implementation MarketingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.revealViewController.delegate = self;
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.btnArray = [[NSMutableArray alloc] init];
    self.marketingCategory = [MarketingCategory loadAll];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_marketingCategory count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"marketing_cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UILabel *lbl = (UILabel *) [cell viewWithTag:120];
    UILabel *lbl1 = (UILabel *) [cell viewWithTag:121];
    UILabel *lbl2 = (UILabel *) [cell viewWithTag:122];
    cat = self.marketingCategory[indexPath.row];
    self.index = (int)indexPath.row;
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    lbl.numberOfLines = 2;
    if ([[cat.name lowercaseString] isEqualToString:@"adults brand book"]) {
        lbl.attributedText = [ClarksFonts addSpaceBwLetters:[@"ADULTS" uppercaseString] alpha:4.0];
        lbl1.attributedText = [ClarksFonts addSpaceBwLetters:[@"BRAND BOOK" uppercaseString] alpha:4.0];
        lbl2.hidden = YES;
    }else if ([[cat.name lowercaseString] isEqualToString:@"kids brand book"]){
        lbl.attributedText = [ClarksFonts addSpaceBwLetters:[@"KIDS" uppercaseString] alpha:4.0];
        lbl1.attributedText = [ClarksFonts addSpaceBwLetters:[@"BRAND BOOK" uppercaseString] alpha:4.0];
        lbl2.hidden = YES;
    }else if ([[cat.name lowercaseString] isEqualToString:@"additional features"]){
        lbl.attributedText = [ClarksFonts addSpaceBwLetters:[@"ADDITIONAL" uppercaseString] alpha:4.0];
        lbl1.attributedText = [ClarksFonts addSpaceBwLetters:[@"FEATURES" uppercaseString] alpha:4.0];
        lbl2.hidden = YES;
    }else if ([[cat.name lowercaseString] isEqualToString:@"christopher raeburn"]){
        lbl.attributedText = [ClarksFonts addSpaceBwLetters:[@"christopher" uppercaseString] alpha:4.0];
        lbl1.attributedText = [ClarksFonts addSpaceBwLetters:[@"raeburn" uppercaseString] alpha:4.0];
        lbl2.hidden = YES;
    }else{
        lbl2.attributedText = [ClarksFonts addSpaceBwLetters:[cat.name uppercaseString] alpha:4.0];
        lbl1.hidden = YES;
        lbl.hidden = YES;
        lbl2.hidden = NO;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MarketingMaterialViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"marketing_material"];
    vc2.cat = self.marketingCategory[indexPath.row];
    UINavigationController *navigationController = self.navigationController;
    [navigationController pushViewController:vc2 animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.marketingCategory = [MarketingCategory loadAll];
        self.index =0;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.index = 0;
        self.marketingCategory = [MarketingCategory loadAll];
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.marketingCollectionView indexPathForCell:cell];
    MarketingDetailViewController *marketingDetailVC = (MarketingDetailViewController *) segue.destinationViewController;
    MarketingCategory *theCategory = [self.marketingCategory objectAtIndex:self.index];
    MarketingMaterial *theMarketingMaterial = [theCategory.marketingMaterials objectAtIndex:indexPath.row];
    [[MixPanelUtil instance] track:@"marketing_selected"];
    marketingDetailVC.theMarketingData = theMarketingMaterial;
}
@end
