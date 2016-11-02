//
//  ListDataSource.h
//  ClarksCollection
//
//  Created by Openly on 04/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"

@interface ListDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet ListViewController *parentVC;

@end
