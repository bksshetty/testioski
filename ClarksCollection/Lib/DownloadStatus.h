//
//  DownloadStatus.h
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 28/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadStatus : NSObject
+ (void) updateAsComplete:(NSString *) url;
+ (BOOL) isDownloaded:(NSString *) url;
@end
