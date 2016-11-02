//
//  DiscoverCollectionDetailViewController.h
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "SWRevealViewController.h"

@interface DiscoverCollectionDetailViewController : UIViewController<SWRevealViewControllerDelegate>
@property NSString * assortmentName;
@property NSString * collectionName;

-(void)setDetailImages:(NSArray *)theImages;
-(void) setupTransitionFromShoeDetail:(NSString *)theCollectionName;

@end
