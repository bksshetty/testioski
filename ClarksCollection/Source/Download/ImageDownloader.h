//
//  ImageDownloader.h
//  Clarks Collection
//
//  Created by Openly on 08/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject{
    NSMutableArray *queue;
    int total;
    
    NSURLSession *session;
    
    int priorityTasks;
    NSMutableDictionary *lowPriorityTasks;
}

- (NSMutableArray *) getQueue ;
+ (ImageDownloader *) instance;
- (void) setQueue: (NSArray *) theQueue;
- (void) priorityDownload: (NSString *) location onComplete:(void(^)(NSData *))handler;

- (int) totalItems;
- (int) downloadedItems;
- (void) removeDuplicates;
-(void) removeAlreadyDownloaded ;

-(void) saveToFile :(NSURL *)tmpUrl downloadedFrom: (NSURL *)location;
-(void) doNextDownloads;
-(void) reActivate;
-(void) refreshCount;
@end
