//
//  DownloadItem.h
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadItem : NSObject

enum ItemStatus {NOT_STARTED, INIT_DOWNLOAD, DOWLOADING, PAUSED, COMPLETED, STOPPED};

+ (NSArray *) getAll;

@property NSString *title;
@property enum ItemStatus status;
@property long long fileSize;
@property long long downloadedSize;
@property NSString *url;

- (DownloadItem *) initWithTitle: (NSString *)title andURL:(NSString *)url;

- (void) start;
- (void) resume;
- (void) pause;
- (void) cancel;
- (float) completedPercentage;
- (int) taskID;
@end
