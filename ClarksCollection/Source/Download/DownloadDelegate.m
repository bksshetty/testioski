//
//  DownloadDelegate.m
//  Clarks Collection
//
//  Created by Openly on 09/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "DownloadDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ImageDownloader.h"

@implementation DownloadDelegate
static NSMutableDictionary *handlers;

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    CLSNSLog(@"Downloaded %@", [downloadTask.originalRequest.URL absoluteString]);

    [[ImageDownloader instance] saveToFile: location
                            downloadedFrom: downloadTask.originalRequest.URL];

}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes{
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    [[ImageDownloader instance] doNextDownloads];
}
@end
