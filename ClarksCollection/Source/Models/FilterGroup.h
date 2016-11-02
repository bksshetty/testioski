//
//  FilterGroup.h
//  ClarksCollection
//
//  Created by Openly on 27/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterGroup : NSObject
@property NSString *name;
@property NSArray *filterOptions;
- (FilterGroup *) initWithDict: (NSDictionary *) dict;

@end
