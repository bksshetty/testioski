//
//  ManagedImage.m
//  Clarks Collection
//
//  Created by Openly on 08/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ManagedImage.h"
#import "ClarksUI.h"
#import "ImageDownloadManager.h"
#import "FSHelper.h"
#import "DataReader.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation ManagedImage{
    NSDictionary *data ;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) loadImage:(NSString *) location {
    [self loadImage:location onComplete:nil];
}

-(void) loadImage:(NSString *) location onComplete:(void(^)(void)) theHandler{
    @autoreleasepool {
        if (loader != nil) {
            [loader removeFromSuperview];
        }
        loader = [ClarksUI showLoader:self];
        handler = theHandler;
        curLocation = location;
        
        if ([self updateImage]) {
            return;
        }
        [ImageDownloadManager downloadNow:location onComplete:^(NSData *imgData) {
            [self updateImage];
        }];

    }
}

-(BOOL) updateImage{
    @autoreleasepool {
        NSString *filePath = [FSHelper localPath:curLocation];
        if (filePath && [FSHelper fileExists:filePath]) {
            //self.image = [UIImage imageWithData: [FSHelper dataFromFile:filePath]];
            self.image = [UIImage imageWithContentsOfFile:filePath];
            [loader removeFromSuperview];
            loader = nil;
            if (handler != nil) {
                handler();
            }
            return YES;
        }
        return NO;
    }
}

@end
