//
//  SingleShoeDataSource.h
//  ClarksCollection
//
//  Created by Openly on 15/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SingleShoeViewController;

@interface SingleShoeDataSource : NSObject<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet SingleShoeViewController *parentViewController;

@end
