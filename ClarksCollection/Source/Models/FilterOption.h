//
//  FilterOption.h
//  ClarksCollection
//
//  Created by Openly on 27/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterOption : NSObject
@property NSString *name;
@property NSString *query;
- (FilterOption *) initWithDict: (NSDictionary *) dict;
@end
