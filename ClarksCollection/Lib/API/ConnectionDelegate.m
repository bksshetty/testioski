//
//  ConnectionDelegate.m
//  NS 360
//
//  Created by Openly on 15/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ConnectionDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation ConnectionDelegate

-(ConnectionDelegate *) initWithHandler: (void(^)(NSData *)) completionHandler errorHandler:(void(^)(NSDictionary *)) connErrHandler certificateErrorHandler: (void (^)(void)) certErrHandler{
    if ([self init]) {
        fullData = [[NSMutableData alloc]init];
        handler = completionHandler;
        networkErrorHandler = connErrHandler;
        certificateErrorHandler = certErrHandler;
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [fullData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    handler(fullData);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
         networkErrorHandler(@{@"message": @"Connection to server failed"});
    return;
}

@end
