//
//  itemInListCollectionViewDataSource.m
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "itemInListCollectionViewDataSource.h"
#import "ClarksFonts.h"
#import "ManagedImage.h"
#import "CollectionViewCellButton.h"
#import "AppDelegate.h"
#import "TechImageView.h"
#import "DataReader.h"
#import "ImageDownloader.h"
#import "Techlogos.h"
#import "MarketingMaterial.h"
#import "MarketingCategory.h"
#import "MarketingDetailViewController.h"
#import "MixPanelUtil.h"
#import "Mixpanel.h"
#import "ClarksFonts.h"
#import "DiscoverCollectionDetailViewController.h"
#import "SingleShoeViewController.h"
#import "Assortment.h"
#import "Collection.h"
#import "Region.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation itemInListCollectionViewDataSource{
    int i;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item-in-list-grid" forIndexPath:indexPath];
        if (cell != nil) {
            [[cell viewWithTag:1 ] removeFromSuperview];
            [[cell viewWithTag:2 ] removeFromSuperview];
            [[cell viewWithTag:501] setHidden:YES];
            ListItem *theListItem = self.parentVC.list.listOfItems[indexPath.row];
            UILabel *lblName = (UILabel *)[cell viewWithTag:720];
            if (![theListItem.name isEqual:[NSNull null]] || !(theListItem.name == nil))
            {
                lblName.attributedText = [ClarksFonts addSpaceBwLetters:[theListItem.name uppercaseString] alpha:2.0];
            }
            UILabel *lblColorName = (UILabel *)[cell viewWithTag:121];
            if(theListItem != nil || theListItem != Nil){
                if (![theListItem.itemColor isEqual:[NSNull null]] || (theListItem.itemColor != nil) || !theListItem.itemColor) {
                    lblColorName.attributedText = [ClarksFonts addSpaceBwLetters:[theListItem.itemColor uppercaseString] alpha:2.0];
                }
            }
            ManagedImage *shoeImage= (ManagedImage *)[cell viewWithTag:122];
            [shoeImage loadImage: theListItem.imageSmall];
            shoeImage.contentMode = UIViewContentModeScaleAspectFit;
            NSString *str = theListItem.collectionName;
            NSArray *components = [str componentsSeparatedByString:@" - "];
            NSDictionary *collectionLogosObjs = [[Techlogos getAllAsortImages] valueForKey:[components lastObject]];
            self.discover_name = [components lastObject];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.discoverColl = [components lastObject];
            NSString *colLogoUrls = [collectionLogosObjs valueForKey:@"logo"] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(cell.tag == indexPath.row) {
                    UIButton *collectionImage = (UIButton *)[cell viewWithTag:127];
                    [[ImageDownloader instance] priorityDownload:colLogoUrls onComplete:^(NSData *theData) {
                        UIImage *colImage = [UIImage imageWithData:theData];
                        [collectionImage setBackgroundImage:colImage forState:UIControlStateNormal];
                    }] ;
                    for (UIView *oldViews in cell.subviews)
                    {
                        if([oldViews isKindOfClass:[TechImageView class]])
                            [oldViews removeFromSuperview];
                    }
                    i=0;
                    for (NSString *tech in theListItem.technologies) {
                        NSString *imgName = [NSString stringWithFormat:@"%@",[tech stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
                        imgName = [imgName lowercaseString];
                        NSDictionary *techLogoObjs  = [[Techlogos getAllTechURLS] valueForKey:imgName];
                        NSString *techLogos_urls = [techLogoObjs valueForKey:@"logo"];
                        NSString *idx = [techLogoObjs valueForKey:@"story_id"];
                        [[ImageDownloader instance] priorityDownload:techLogos_urls onComplete:^(NSData *theData) {
                            TechImageView *techImage = [[TechImageView alloc] initWithData:theData fori:i++ techLogos:techLogoObjs] ;
                            UIButton *techImgBtn = [[UIButton alloc] initWithFrame:techImage.frame];
                            [techImgBtn setImage:techImage.image forState:UIControlStateNormal];
                            [techImgBtn setTitle:idx forState:UIControlStateNormal];
                            [techImgBtn addTarget:self action:@selector(onTechClick:) forControlEvents:UIControlEventTouchUpInside];
                            techImgBtn.adjustsImageWhenHighlighted = NO;
                            techImgBtn.tag = i ;
                        }] ;
                        if(i >1) // Max 2 images
                            break;
                    }
                    if (![self checkIfItemIsAvailable:theListItem]) {
                        [[cell viewWithTag:501] setHidden:NO];
                    }
                }
            });
            if (!self.parentVC.readOnly) {
                CollectionViewCellButton *deleteButton = [self makeDeleteButtonForCell:cell];
                deleteButton.indexPath = (int)indexPath.row;
                [cell addSubview:deleteButton];
            }
        }
        return cell;
    }

- (BOOL) checkIfItemIsAvailable: (ListItem *)theListItem{
    Region *region = [Region getCurrent];
    for(Assortment *theAssortment in region.assortments) {
        for (Collection *theCollection in theAssortment.collections) {
            for(Item *theItem in theCollection.items) {
                if([theListItem.name isEqualToString:theItem.name]) {
                    return TRUE ;
                }
            }
        }
    }
    return FALSE ;
}

-(void)onTechClick: (UIButton *)btn{
    NSString *curTech = [[btn titleForState:UIControlStateNormal] lowercaseString];
    NSArray *categories = [MarketingCategory loadAll];
    for (MarketingCategory *cat in categories) {
        for (MarketingMaterial *mat in cat.marketingMaterials) {
            if ([[mat.idx lowercaseString] isEqualToString:curTech]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                MarketingDetailViewController *mdvc = [storyboard instantiateViewControllerWithIdentifier:@"marketing_detail"];
                [[MixPanelUtil instance] track:@"tech_logo_clicked"];
                mdvc.theMarketingData = mat;
                UINavigationController *navigationController = self.parentVC.navigationController;
                    [navigationController pushViewController:mdvc animated:YES];
            }
        }
    }
}


-(CollectionViewCellButton *)makeDeleteButtonForCell:(UICollectionViewCell *)cell
{
    CollectionViewCellButton *button = [CollectionViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/blue-cross-icon.png"];
    image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat width = image.size.width / 2;
    CGFloat height = image.size.height / 2;
    CGFloat X = 156;
    CGFloat Y = 511;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
    button.frame = CGRectMake(15, 495, 300, 60);
    button.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
    [imageView setImage:image];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(deleteItemFromList:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(IBAction)deleteItemFromList:(id)sender
{
    CollectionViewCellButton *button = (CollectionViewCellButton *)sender;
    int indexPath = button.indexPath;
    [self.parentVC.list.listOfItems removeObjectAtIndex:indexPath];
    [self.parentVC.gridView reloadData];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveList];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int count;
    count = (int)[self.parentVC.list.listOfItems count];
    return count;
}
@end
