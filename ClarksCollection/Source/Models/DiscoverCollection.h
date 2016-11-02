//
//  DiscoverCollection.h
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverCollection : NSObject
+(NSArray *) loadAll;

@property NSString *assortmentName;
@property NSString *collectionName;
@property NSString *headerImage;
@property (strong,nonatomic) NSMutableArray* detailImages;

@end
