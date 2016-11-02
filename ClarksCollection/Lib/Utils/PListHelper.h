//
//  PListHelper.h
//  NS 360
//
//  Created by Openly on 27/08/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PListHelper : NSObject
+(NSString *)getDocsDirectory;
+(NSMutableArray *) getUserArray ;
@property NSMutableArray *userArray;
+(void) setUserArray: (NSString *)userName ;

+(BOOL)setPlist:(NSString *)strPlistName;
+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key strValue:(NSString *)strValue;
+(id)getPlistData:(NSString *)strPlistName key:(NSString *)key;
@end
