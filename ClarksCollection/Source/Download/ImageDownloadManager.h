//
//  ImageDownloadManager.h
//  Clarks Collection
//
//  Created by Openly on 09/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloadManager : NSObject


+ (void) preload;
+ (void) downloadNow: (NSString *) location onComplete:(void (^)(NSData *))handler;
+ (void) removeUnreferencedImages ;
+ (void) removeMediumImages ;
@end
