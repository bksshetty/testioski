//
//  ListItemDataSource.h
//  ClarksCollection
//
//  Created by Openly on 14/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShoeListViewController;
@class SingleShoeViewController;


@interface ListItemDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet ShoeListViewController *shoeListViewController;
@property (weak, nonatomic) IBOutlet SingleShoeViewController *singleShoeViewController;

-(void)setUpData;
-(void)setUpEmptyData;
@end
