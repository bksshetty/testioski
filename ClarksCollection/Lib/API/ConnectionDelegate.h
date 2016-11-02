//
//  ConnectionDelegate.h
//  NS 360
//
//  Created by Openly on 15/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionDelegate : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData *fullData;
    void (^handler) (NSData *);
    void (^networkErrorHandler) (NSDictionary *);
    void (^certificateErrorHandler) (void);
}
-(ConnectionDelegate *) initWithHandler: (void(^)(NSData *)) completionHandler errorHandler:(void(^)(NSDictionary *)) connErrHandler certificateErrorHandler: (void (^)(void)) certErrHandler;
@end
