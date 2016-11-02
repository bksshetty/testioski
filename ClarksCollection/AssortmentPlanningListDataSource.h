//
//  AssortmentPlanningListDataSource.h
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 29/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"

@interface AssortmentPlanningListDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
@property NSArray *list;
@property (weak, nonatomic) IBOutlet ListViewController *parentVC;
@end
