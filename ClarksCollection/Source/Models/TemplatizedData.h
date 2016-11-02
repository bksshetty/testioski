//
//  OurBigStoriesData.h
//  ClarksCollection
//
//  Created by Openly on 05/12/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplatizedData : NSObject
@property NSString *headLine;
@property NSString *detailLine;

@property NSString *bigImage;
@property NSString *bigVideo;
@property NSString *thumbImage;
@property NSString *thumbVideo;

- (TemplatizedData *) initWithDict: (NSDictionary *) dict;

@end
