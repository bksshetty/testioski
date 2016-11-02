//
//  itemInListTableViewDataSource.h
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsInListViewController.h"

@interface itemInListTableViewDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet ItemsInListViewController *parentVC;
@end
