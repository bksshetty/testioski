//
//  itemInListCollectionViewDataSource.h
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsinListViewController.h"

@interface itemInListCollectionViewDataSource : NSObject  <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet ItemsInListViewController *parentVC;
- (BOOL) checkIfItemIsAvailable: (ListItem *)theListItem ;

@property NSString *discover_name ;
@property NSString *story_name ;
@end
