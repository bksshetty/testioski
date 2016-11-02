//
//  ZipDownloader.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "ZipDownloader.h"
#import "DownloadItem.h"
#import "SSZipArchive.h"
#import "FSHelper.h"
#import "DownloadStatus.h"
#import "ImageDownloader.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation ZipDownloader{
    NSURLSession *session;
}

static ZipDownloader *instance;

- (NSURLSession *) getSession{
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: getSession: Entry");
#endif
    if (session != nil) {
#ifdef DEBUG
        CLSNSLog(@"ZipDownloader: getSession: Exit");
#endif
        return session;
    }
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration
            backgroundSessionConfigurationWithIdentifier:
                @"co.openly.ClarksCollection-zip"];
    
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 20;
    
    session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                            delegate: self
                            delegateQueue:nil];
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: getSession: Exit");
#endif
    return session;
}

- (void) doDownload: (NSString *) url
         onComplete:
        (void(^)(NSURLSessionDownloadTask *))handler{
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: doDownload: Entry");
#endif
    NSURLSession *theSession = [self getSession];
    [theSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSURLSessionDownloadTask *task = nil;
        for (NSURLSessionDownloadTask *eTask in downloadTasks) {
            if ([[eTask.originalRequest.URL absoluteString] isEqualToString:url]) {
                [eTask cancel];
            }
        }
        task = [theSession downloadTaskWithURL:
                        [NSURL URLWithString:url]];
        [task resume];
        
        handler(task);
    }];
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: doDownload: Exit");
#endif
}

+ (void) download: (NSString *) url onComplete:(void(^)(NSURLSessionDownloadTask *))handler{
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: download: Entry");
#endif
    if (instance == nil) {
        instance = [[ZipDownloader alloc] init];
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    CLSNSLog(@"Start download: %@",url);
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: download: Exit");
#endif
    return [instance doDownload:url onComplete:handler];
}

- (void)URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didFinishDownloadingToURL:(NSURL *)location{
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: didFinishDownloadingToURL: Entry");
#endif
    DownloadItem *theItem = [self itemForTask:downloadTask];
    if (theItem != nil) {
        theItem.status = COMPLETED;
        NSString *dest = [FSHelper fullPathFor:@""];
        CLSNSLog(@"Unzipping %@ from %@ to %@", theItem.title,[location absoluteString], dest);
        if ([SSZipArchive unzipFileAtPath:[location path] toDestination:dest overwrite:YES password:nil error:nil]) {
            [DownloadStatus updateAsComplete: theItem.url];
            CLSNSLog(@"Unzip success");
        }else{
            CLSNSLog(@"Unzip failed");
        }
        
        [[ImageDownloader instance] removeAlreadyDownloaded];
        [[ImageDownloader instance] refreshCount];
    }
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: didFinishDownloadingToURL: Exit");
#endif
}

- (void)URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didWriteData:(int64_t)bytesWritten
        totalBytesWritten:(int64_t)totalBytesWritten
        totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: didWriteData: Entry");
#endif
    
    DownloadItem *theItem = [self itemForTask:downloadTask];
    NSLog(@"Item Name: %@", theItem.title);
    CLSNSLog(@"Downloading %@: %lld of %lld", theItem.title,
          totalBytesWritten, totalBytesExpectedToWrite);
    theItem.fileSize = totalBytesExpectedToWrite;
    theItem.downloadedSize = totalBytesWritten;
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: didWriteData: Exit");
#endif
}

- (void)URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didResumeAtOffset:(int64_t)fileOffset
        expectedTotalBytes:(int64_t)expectedTotalBytes{
    
    
}

- (void)URLSession:(NSURLSession *)session
        didBecomeInvalidWithError:(NSError *)error{
    
}

- (DownloadItem *) itemForTask:(NSURLSessionDownloadTask *) task{
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: itemForTask: Entry");
#endif
    for (DownloadItem *item in [DownloadItem getAll]) {
        if ([item taskID] ==  task.taskIdentifier) {
#ifdef DEBUG
            CLSNSLog(@"ZipDownloader: itemForTask: Exit");
#endif
            
            return item;
        }
    }
#ifdef DEBUG
    CLSNSLog(@"ZipDownloader: itemForTask: Exit");
#endif
    return nil;
}

@end
