//
//  DownloadItem.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "DownloadItem.h"
#import "DataReader.h"
#import "ZipDownloader.h"
#import "DownloadStatus.h"

@implementation DownloadItem {
    NSURLSessionDownloadTask *task;
}
static NSMutableArray *allItems;

+ (NSArray *) getAll{
    if (allItems != nil) {
        return allItems;
    }
    allItems = [[NSMutableArray alloc] init];
    NSDictionary *data = [DataReader read];
    NSArray *downloadItems = [data valueForKey:@"download_manager_links"];
    for (NSDictionary *dict in downloadItems) {
        DownloadItem *item = [[DownloadItem alloc]
                              initWithTitle: [dict valueForKey:@"name"]
                              andURL: [dict valueForKey:@"url"]];
        item.fileSize = (long long)[dict valueForKey:@"size"];
        [allItems addObject:item];
    }
    return allItems;
}

- (DownloadItem *) initWithTitle: (NSString *)title andURL:(NSString *)url{
    if ([self init]) {
        self.title = title;
        self.url = url;
        self.fileSize = -1;
        if ([DownloadStatus isDownloaded:self.url]) {
            self.status = COMPLETED;
        }
    }
    return self;
}

- (void) start{
    if (self.status != NOT_STARTED && self.status != STOPPED) {
        return;
    }
    self.status = INIT_DOWNLOAD;
    [ZipDownloader download:self.url onComplete:^(NSURLSessionDownloadTask *theTask) {
        self.status = DOWLOADING;
        task = theTask;
    }];
}

- (void) resume{
    if (self.status != PAUSED) {
        return;
    }
    if (task != nil) {
        [task resume];
    }
    self.status = DOWLOADING;
}

- (void) pause{
    if (self.status != DOWLOADING) {
        return;
    }
    if (task != nil) {
        [task suspend];
    }
    self.status = PAUSED;
}

- (void) cancel{
    if (self.status != DOWLOADING && self.status != PAUSED) {
        return;
    }
    if (task != nil) {
        [task cancel];
    }
    self.status = STOPPED;
}

- (float) completedPercentage{
    return self.fileSize > 0 ? ((float)self.downloadedSize / (float)self.fileSize) : 0 ;
}

- (int) taskID{
    if (self.status == DOWLOADING) {
        return task.taskIdentifier;
    }
    return -1;
}
@end