//
//  MarketingMaterialViewController.m
//  ClarksCollection
//
//  Created by Adarsh on 29/05/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "MarketingMaterialViewController.h"
#import "MarketingCategory.h"
#import "MarketingMaterial.h"
#import "ManagedImage.h"
#import "MarketingDetailViewController.h"
#import "SWRevealViewController.h"
#import "MarketingViewController.h"
#import "MixPanelUtil.h"
#import "MarketingCategory.h"
#import "ClarksFonts.h"

@interface MarketingMaterialViewController (){
    UIView *translucentView;
}
@end

@implementation MarketingMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.revealViewController != nil) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    self.marketingLbl.attributedText = [ClarksFonts addSpaceBwLetters:[_cat.name uppercaseString] alpha:3.0];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    self.marketingCategory = [MarketingCategory loadAll];
    [self.view addGestureRecognizer:swipeUp];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        if (translucentView.isHidden) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void) viewDidAppear:(BOOL)animated{
    if (self.revealViewController != nil) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
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
    return [_cat.marketingMaterials count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"category";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    ManagedImage *manImage = (ManagedImage *)[cell viewWithTag:120];
    self.index = (int)indexPath.row;
    MarketingMaterial *theMaterial =(MarketingMaterial *)[_cat.marketingMaterials objectAtIndex:indexPath.row];
    NSString *imageName = theMaterial.headerImage;
    [manImage loadImage:imageName];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"   bundle:nil];
    MarketingDetailViewController *marketingDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"marketing_detail" ];
    MarketingMaterial *theMarketingMaterial = [_cat.marketingMaterials objectAtIndex:indexPath.row];
    [[MixPanelUtil instance] track:@"marketing_selected"];
    marketingDetailVC.theMarketingData = theMarketingMaterial;
    marketingDetailVC.theMarketingCategory = _cat;
    marketingDetailVC.idx = (int)indexPath.row;
    UINavigationController *navigationController = self.navigationController;
    [navigationController pushViewController:marketingDetailVC animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    if( cellCount >0 )
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount;
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth<contentWidth )
        {
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
    }
    return UIEdgeInsetsZero;
}

-(void) setCategory: (MarketingCategory *)cat1{
    _cat = cat1;
}
@end
