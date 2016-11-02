//
//  AssortmentDatasource.h
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"

@interface AssortmentDatasource : NSObject<UICollectionViewDataSource, UICollectionViewDelegate>{
}
-(void) setupRegion:(NSArray *)regionArray;
-(Assortment *) assortmentAtIndex:(NSInteger)index;
@end
