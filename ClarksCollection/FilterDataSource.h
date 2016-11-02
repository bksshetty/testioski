//
//  FilterDataSource.h
//  ClarksCollection
//
//  Created by Openly on 10/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray* filters;

@end
