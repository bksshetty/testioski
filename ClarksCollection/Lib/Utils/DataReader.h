//
//  DataReader.h
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataReader : NSObject
+ (NSDictionary *) read;
+ (NSDictionary *) read1;
+ (BOOL) hasData;
@end
