//
//  ZipDownloader.h
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipDownloader : NSObject<NSURLSessionDownloadDelegate>
+ (void) download: (NSString *) url onComplete:(void(^)(NSURLSessionDownloadTask *))handler;
@end
