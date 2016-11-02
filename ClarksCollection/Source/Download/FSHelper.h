//
//  FSHelper.h
//  Clarks Collection
//
//  Created by Openly on 08/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSHelper : NSObject
+ (NSString *) fullPathFor :(NSString *)path;
+ (NSData *) dataFromFile: (NSString *)file;
+ (void) data: (NSData *) data toFile:(NSString *) file;
+ (BOOL) fileExists: (NSString *) path;
+ (NSString *) localPath: (NSString *) location;
@end
