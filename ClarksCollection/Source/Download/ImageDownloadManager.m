//
//  ImageDownloadManager.m
//  Clarks Collection
//
//  Created by Openly on 09/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ImageDownloadManager.h"
#import "ImageDownloader.h"
#import "Item.h"
#import "ItemColor.h"
#import "Region.h"
#import "MarketingCategory.h"
#import "DiscoverCollection.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation ImageDownloadManager

+ (void) preload{
    NSThread* downloadThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(doPrepload)
                                                   object:nil];
    [downloadThread start];
}

+ (void) removeUnreferencedImages{
    NSThread* removeReferenceThread = [[NSThread alloc] initWithTarget:self
                                                              selector:@selector(doRemoveImages)
                                                                object:nil];
    [removeReferenceThread start];
}

+ (void) removeMediumImages{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *filePathArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    NSMutableArray *existingQueue = [filePathArray mutableCopy];
    for (NSString *deleteItem in existingQueue) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:deleteItem];
        NSError *error;
        if ([deleteItem rangeOfString:@"_medium_"].location == NSNotFound) {
        }else{
            BOOL success = [fileManager removeItemAtPath:filePath error:&error];
            if (success) {
                CLSNSLog(@"Deleted File is: %@", deleteItem);
            }
        }
    }
}

+ (void) doRemoveImages{
    
//    [self removeMediumImages];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSArray *filePathArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
//    NSMutableArray *existingQueue = [filePathArray mutableCopy];
//    NSMutableArray *newQueue = [[ImageDownloader instance] getQueue];
//    
//    for (NSString *str in existingQueue) {
//        NSLog(@"Existing Queue: %@", str);
//    }
//    
//    NSMutableArray *newArray = [NSMutableArray array];
//    for (NSString *str in newQueue) {
//        [newArray addObject:str];
//    }
//    if (newArray != nil && existingQueue != nil) {
//        for (NSString *fileName in existingQueue) {
//            NSArray *componentArray = [fileName componentsSeparatedByString:@"."];
//            NSString *fileExtenstion = [componentArray lastObject];
//            if ([fileExtenstion isEqualToString:@"jpg"] ||
//                [fileExtenstion isEqualToString:@"jpeg"] ||
//                [fileExtenstion isEqualToString:@"png"]) {
//                if (fileName != nil) {
//                    if (![newArray containsObject:fileName]) {
//                        NSFileManager *fileManager = [NSFileManager defaultManager];
//                        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                        
//                        NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
//                        NSError *error;
//                        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
//                        if (success) {
//                            CLSNSLog(@"Deleted File is: %@", fileName);
//                        }
//                    }
//                }
//            }
//            
//        }
//    }
}

+ (void) doPrepload{
    @autoreleasepool {
        NSMutableArray *downloadList = [[NSMutableArray alloc] init];
        NSMutableArray *thumbList = [[NSMutableArray alloc] init];
        NSMutableArray *colorThumbList = [[NSMutableArray alloc] init];
        NSMutableArray *mediumList = [[NSMutableArray alloc] init];
        NSMutableArray *largeList = [[NSMutableArray alloc] init];
        NSMutableArray *image360List = [[NSMutableArray alloc] init];
        NSMutableArray *marketingImagesList = [[NSMutableArray alloc] init];
        NSMutableArray *discoverImagesList = [[NSMutableArray alloc] init];
        NSArray *discoverCollectionArray = [DiscoverCollection loadAll];
        for(DiscoverCollection *theDiscoverCollection in discoverCollectionArray) {
            [discoverImagesList addObject:theDiscoverCollection.headerImage];
            [discoverImagesList addObjectsFromArray:theDiscoverCollection.detailImages];
        }
        NSArray *marketingCategory = [MarketingCategory loadAll];
        for(MarketingCategory *theCategory in marketingCategory) {
            NSArray *theMaterialArray = theCategory.marketingMaterials;
            for(MarketingMaterial *marketingMaterial in theMaterialArray) {
                if(marketingMaterial.isTemplatized == NO) {
                    [marketingImagesList addObject:marketingMaterial.headerImage];
                    [marketingImagesList addObjectsFromArray:marketingMaterial.detailImages];
                }
                else {
                    NSArray *theTemplatizedDataArray = marketingMaterial.templatizedData;
                    for(TemplatizedData *theTemplatizedData in theTemplatizedDataArray) {
                        [marketingImagesList addObject:theTemplatizedData.bigImage];
                        [marketingImagesList addObject:theTemplatizedData.thumbImage];
                    }
                }
            }
        }
        NSArray *regions = [Region loadAll];
        if (regions != nil) {
            for (int i =0; i<[regions count]; i++) {
                if ([regions[i] isKindOfClass: [Region class]]) {
                    NSArray *assorts = ((Region *) regions[i]).assortments;
                    for (int j =0; j<[assorts count]; j++) {
                        if ([assorts[j] isKindOfClass:[Assortment class]]) {
                            NSArray *colls = ((Assortment *) assorts[j]).collections;
                            for (int k =0; k<[colls count]; k++) {
                                NSArray *items = ((Collection *) colls[k]).items;
                                for (int l =0; l<[items count]; l++) {
                                    [thumbList addObject: ((Item *) items[l]).image];
                                    NSArray *colors = ((Item *) items[l]).colors;
                                    for (int m =0; m<[colors count]; m++) {
                                        [colorThumbList addObjectsFromArray:((ItemColor *) colors[m]).thumbs];
                                        [largeList addObjectsFromArray:((ItemColor *) colors[m]).largeImages];
                                        [image360List addObjectsFromArray:((ItemColor *) colors[m]).images360];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        [downloadList addObjectsFromArray:discoverImagesList];
        [downloadList addObjectsFromArray:marketingImagesList];
        [downloadList addObjectsFromArray:image360List];
        [downloadList addObjectsFromArray:largeList];
        [downloadList addObjectsFromArray:colorThumbList];
        [downloadList addObjectsFromArray:thumbList];
        [[ImageDownloader instance] setQueue:downloadList];
    }
}

+ (void) downloadNow: (NSString *) location onComplete:(void (^)(NSData *))handler{
    [[ImageDownloader instance] priorityDownload:location onComplete:handler];
}
@end
