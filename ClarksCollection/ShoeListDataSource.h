//
//  ShoeListDataSource.h
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@class ShoeListViewController;

@interface ShoeListDataSource : NSObject<UICollectionViewDataSource, UICollectionViewDelegate>{
}
@property NSString *titleLable;
@property NSArray *itemArray;
@property (weak, nonatomic) IBOutlet UICollectionView *shoeListView;
@property (weak, nonatomic) IBOutlet ShoeListViewController *parentVC;

@property Item *current;
@property NSString *searchTerm;
@property(strong,nonatomic) NSMutableDictionary *filters;


-(void) setupCollections:(NSArray *)collectionsArray;
-(void)setupFilterArray;
-(void)setupFilterArrayFromFilterList;
-(void)resetFilterArrayFromFilterList;
@end
