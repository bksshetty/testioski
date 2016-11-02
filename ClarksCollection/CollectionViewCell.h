//
//  CollectionViewCell.h
//  ClarksCollection
//
//  Created by Adarsh on 17/03/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsinListViewController.h"

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet ItemsInListViewController *parentVC;
- (BOOL) checkIfItemIsAvailable: (ListItem *)theListItem ;

@property NSString *discover_name ;
@property NSString *story_name ;


@end
