//
//  API.h
//  NS 360
//
//  Created by Openly on 26/08/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject <NSURLSessionTaskDelegate>
+ (API *) instance;
@property bool isTestMode;
@property NSString *email ;
@property BOOL usernameUpdated;
@property NSString *auth_token ;
- (BOOL) isLoggedIn;
- (void) login: (NSString *) user password:(NSString *) password onComplete: (void(^)(bool, NSString *)) handler;
- (void) logout: (void(^)(void)) handler;
- (void) clearRegions: (void(^)(void)) handler;

- (void) get: (NSString *) path onComplete: (void(^)(NSDictionary *)) handler;
- (void) getOnlyData: (NSString *) path onComplete: (void(^)(NSData *)) handler;
- (void) put: (NSString *) path onComplete: (void(^)(NSDictionary *)) handler;
- (void) post: (NSString *) path params: (NSDictionary *)params onComplete: (void(^)(NSDictionary *)) handler;
- (void) httpTransaction: (NSString *) path method:(NSString *)transMethod params: (NSDictionary *)params onComplete: (void(^)(NSDictionary *)) handler;

@end
