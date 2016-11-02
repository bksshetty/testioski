//
//  SelectListDataSource.h
//  ClarksCollection
//
//  Created by Openly on 14/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoeListViewController.h"
#import "SingleShoeViewController.h"

@interface SelectListDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet ShoeListViewController *parentVC;
@property (weak, nonatomic) IBOutlet SingleShoeViewController *singleShoeParentVC;

@end
