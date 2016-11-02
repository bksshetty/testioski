//
//  CollectionSelectDataSource.h
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Assortment.h"

@interface CollectionSelectDataSource : NSObject<UICollectionViewDataSource, UICollectionViewDelegate>{
    void (^handler) (BOOL);
}
@property Assortment *curAssortment;
@property (strong,nonatomic) NSMutableArray  *displayState;

-(void)setupAssortment:(Assortment *)assortment;
-(NSArray *)getListofSelectedCollections;
-(void) updateCallback: (void(^)(BOOL)) completionHandler;
-(void)markAllCollectionsState:(BOOL)state;

@end
