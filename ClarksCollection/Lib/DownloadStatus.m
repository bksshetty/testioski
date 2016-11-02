//
//  DownloadStatus.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 28/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "DownloadStatus.h"
#import "FSHelper.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation DownloadStatus
+ (NSMutableArray *) getCurrent{
#ifdef DEBUG
    CLSNSLog(@"DownloadStatus: getCurrent: Entry");
#endif
    NSString *path = [FSHelper fullPathFor:@"status.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *cont = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
#ifdef DEBUG
        CLSNSLog(@"DownloadStatus: itemForTask: Exit");
#endif
        return [[cont componentsSeparatedByString:@"\n"] mutableCopy];
    }
#ifdef DEBUG
    CLSNSLog(@"DownloadStatus: getCurrent: Exit");
#endif
    return [[NSMutableArray alloc] init];
}
+ (void) save: (NSArray *) data{
#ifdef DEBUG
    CLSNSLog(@"DownloadStatus: save: Entry");
#endif
    NSString *path = [FSHelper fullPathFor:@"status.txt"];
    [[data componentsJoinedByString:@"\n"]
        writeToFile:path atomically:YES
        encoding:NSUTF8StringEncoding error:nil];
#ifdef DEBUG
    CLSNSLog(@"DownloadStatus: save: Exit");
#endif
}

+ (void) updateAsComplete:(NSString *) url{
#ifdef DEBUG
    CLSNSLog(@"DownloadStatus: updateAsComplete: Entry");
#endif
    NSMutableArray *cur = [self getCurrent];
    if ([cur indexOfObject:url] == NSNotFound) {
        [cur addObject:url];
    }
    [self save: cur];
#ifdef DEBUG
    CLSNSLog(@"DownloadStatus: updateAsComplete: Exit");
#endif
}
+ (BOOL) isDownloaded:(NSString *) url{
    return [[self getCurrent] indexOfObject:url] != NSNotFound;
}
@end
