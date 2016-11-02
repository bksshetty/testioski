//
//  API.m
//  NS 360
//
//  Created by Openly on 26/08/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "API.h"
#import "User.h"
#import "PListHelper.h"
#import "LoginViewController.h"
#import "ConnectionDelegate.h"
#import "Region.h"
#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation API
NSString * const BASE_URL = @"https://aw17-liveapi.openly.co/";
NSString * const PLIST_NAME = @"ClarksCollection-Info";
NSString * const BASE_URL_TEST = @"https://aw17-testapi.openly.co/";
static API *theInstance;

- (id)init {
    if ((self = [super init])) {
        self.isTestMode = false;
    }
    return self;
}

- (BOOL) isLoggedIn{
    NSString *authToken = [PListHelper getPlistData:PLIST_NAME key:@"auth_token"];
    self.auth_token = authToken ;
    BOOL isLoggedIn = authToken != nil && authToken.length > 0;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (isLoggedIn) {
        NSString *userName = [PListHelper getPlistData:PLIST_NAME key:@"user_name"];
        NSArray *regions = [[PListHelper getPlistData:PLIST_NAME key:@"user_regions"] componentsSeparatedByString:@","];
        NSString *userAnalyticsBlocked;
        userAnalyticsBlocked = [PListHelper getPlistData:PLIST_NAME key:@"user_analytics_blocked"];
        if ([userAnalyticsBlocked isEqualToString:@"true"]) {
            appDelegate.mixpanelBlockedUser = true;
        }else{
            appDelegate.mixpanelBlockedUser = false ;
        }
        User *curUser = [[User alloc] init];
        curUser.name = userName;
        curUser.regions = regions;
        [User setCurrent:curUser];
    }
    return isLoggedIn;
}

+ (API *) instance{
    if (theInstance == NULL) {
        theInstance = [[API alloc] init];
    }
    return theInstance;
}

- (void) login: (NSString *) user password:(NSString *) password onComplete: (void(^)(bool, NSString *)) handler{
    [self post:@"login" params:@{@"user":user, @"pass":password, @"mandateEmailId": @"true"} onComplete:^(NSDictionary *result) {
        if ([result valueForKey:@"email"] != nil) {
            self.email = [result valueForKey:@"email"];
            self.usernameUpdated = true;
            handler(true, nil);
        }
        if ([result valueForKey:@"auth_token"] != nil){
            self.auth_token = [result valueForKey:@"auth_token"];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.verificationStatus = [[result valueForKey:@"user"] valueForKey:@"emailVerificationStatus"];
            appDelegate.mixpanelBlockedUser = [[result valueForKey:@"user"] valueForKey:@"blockActivityLogging"];
            [PListHelper setPlistData:PLIST_NAME key:@"auth_token" strValue:[result valueForKey:@"auth_token"]];
            User *curUser = [[User alloc] initWithDict: [result valueForKey:@"user"]];
            [PListHelper setPlistData:PLIST_NAME key:@"user_name" strValue:curUser.name];
            [PListHelper setPlistData:PLIST_NAME key:@"user_regions" strValue:[curUser.regions componentsJoinedByString:@","]];
            BOOL val  = [[[result valueForKey:@"user"] valueForKey:@"blockActivityLogging"] boolValue];
            if (val) {
                [PListHelper setPlistData:PLIST_NAME key:@"user_analytics_blocked" strValue:@"true"];
            }else{
                [PListHelper setPlistData:PLIST_NAME key:@"user_analytics_blocked" strValue:@"false"];
            }
            [User setCurrent:curUser];
            handler(true, nil);
        }else {
            NSString *strErr = [result valueForKey:@"error"];
            if(strErr == nil)
                strErr =@"No connection to the server.";
            handler(false, strErr);
          }
    }];
}

- (void) logout: (void(^)(void)) handler{
    [PListHelper setPlistData:PLIST_NAME key:@"auth_token" strValue:@""];
    [Region clearRegions];
    handler();
}

- (void) clearRegions: (void(^)(void)) handler{
    [Region clearRegions];
    handler();
}

- (void) put: (NSString *) path onComplete: (void(^)(NSDictionary *)) handler{
    [self httpTransaction:path method:@"PUT" params:nil onComplete:handler];
}

- (void) get: (NSString *) path onComplete: (void(^)(NSDictionary *)) handler{
    [self httpTransaction:path method:@"GET" params:nil onComplete:handler];
}

- (void) getOnlyData: (NSString *) path onComplete: (void(^)(NSData *)) handler{
    [self httpTransactionOnlyData:path method:@"GET" onComplete:handler];
}

- (void) post: (NSString *) path params: (NSDictionary *)params onComplete: (void(^)(NSDictionary *)) handler{
    [self httpTransaction:path method:@"POST" params:params onComplete:handler];
}

- (void) httpTransactionOnlyData: (NSString *) path method:(NSString *)transMethod onComplete: (void(^)(NSData *)) handler{
    NSString *urlString ;
    if(!self.isTestMode)
        urlString = [ NSString stringWithFormat:@"%@/%@", BASE_URL, path ];
    else
        urlString = [ NSString stringWithFormat:@"%@/%@", BASE_URL_TEST, path ];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    request.HTTPMethod = transMethod;
    [request setValue:[PListHelper getPlistData:PLIST_NAME key:@"auth_token"] forHTTPHeaderField:@"auth_token"];
    if(self.auth_token != nil)
        [request setValue:self.auth_token forHTTPHeaderField:@"auth_token"];
    ConnectionDelegate *delegate = [[ConnectionDelegate alloc] initWithHandler:^(NSData *data) {
        if(data == nil)
            return;
        handler(data);
    } errorHandler:^(NSDictionary *results) {
        NSString *strErr;
        if([@"Internal error" isEqualToString:[results valueForKey:@"message"]])
            [self showErrorMessage:@"ErrorLabel_Internal"];
        else
            [self showErrorMessage:@"ErrorLabel_NoServerConnection"];
        strErr = NSLocalizedString(@"Error_Connection", nil);
        handler(nil);
        return;
    } certificateErrorHandler:^{
        NSString *strErr;
        strErr = NSLocalizedString(@"Error_Connection", nil);
        [self showErrorMessage:@"ErrorLabel_Certificate"];
        handler(nil);
        return ;
    }];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:delegate];
    [conn start];
}

// Generic transaction handler
- (void) httpTransaction: (NSString *) path method:(NSString *)transMethod params: (NSDictionary *)params onComplete: (void(^)(NSDictionary *)) handler{
    NSString *urlString ;
    if(!self.isTestMode)
        urlString = [ NSString stringWithFormat:@"%@/%@", BASE_URL, path ];
    else
        urlString = [ NSString stringWithFormat:@"%@/%@", BASE_URL_TEST, path ];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    request.HTTPMethod = transMethod;
    if([transMethod isEqualToString:@"POST"])
        request.HTTPBody = [[self serializeParams:params] dataUsingEncoding: NSUTF8StringEncoding];
    [request setValue:[PListHelper getPlistData:PLIST_NAME key:@"auth_token"] forHTTPHeaderField:@"auth_token"];
    if(self.auth_token != nil)
        [request setValue:self.auth_token forHTTPHeaderField:@"auth_token"];
    ConnectionDelegate *delegate = [[ConnectionDelegate alloc] initWithHandler:^(NSData *data) {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *strErr;
        // If no result found then we got no data from service layer - means that the service layer is down
        if(results == nil)
        {
            strErr = [results valueForKey:@"error"];
            if(strErr == nil)
                strErr = NSLocalizedString(@"Error_NoServerConnection", nil);
            handler(@{@"error": strErr});
            return;
        }
        if ([@"NotAuthorized" isEqualToString:[results valueForKey:@"code"]])
        {
            [self showErrorMessage:@"ErrorLabel_SessionExpired"];
            strErr = NSLocalizedString(@"Error_SessionExpired", nil);
            handler(@{@"error": strErr});
            return;
        }
        handler(results);
    } errorHandler:^(NSDictionary *results) {
        NSString *strErr;
        if([@"Internal error" isEqualToString:[results valueForKey:@"message"]])
        {
          [self showErrorMessage:@"ErrorLabel_Internal"];
        }else
        {
            [self showErrorMessage:@"ErrorLabel_NoServerConnection"];
        }
        strErr = NSLocalizedString(@"Error_Connection", nil);
        handler(@{@"error": strErr});
        return;
    } certificateErrorHandler:^{
        NSString *strErr;
        strErr = NSLocalizedString(@"Error_Connection", nil);
        [self showErrorMessage:@"ErrorLabel_Certificate"];
        handler(@{@"error": strErr});
        return ;
    }];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:delegate];
    [conn start];
}

- (NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *pairs = NSMutableArray.array;
    for (NSString *key in params.keyEnumerator) {
        NSString *urlEncodedKey = [self urlencode:key];
        NSString *urlEncodedVal = [self urlencode:[params objectForKey:key]];
        CLSNSLog(@"%@ - %@",urlEncodedKey, urlEncodedVal);
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",urlEncodedKey,urlEncodedVal]];
    }
    return [pairs componentsJoinedByString:@"&"];
}

- (void) showErrorMessage:(NSString *)strMessageKey{
    return;
    NSString *strMessage = NSLocalizedString(strMessageKey, nil);
    UIViewController *topVC = [self topMostController];
    LoginViewController *loginVc = [topVC.storyboard instantiateViewControllerWithIdentifier:@"sign_in"];
    [topVC presentViewController:loginVc animated:NO completion:nil];
    loginVc.errorLabel.hidden = NO;
    loginVc.errorLabel.text = strMessage;
    loginVc.userField.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:0.4];
    loginVc.passwordFeild.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:0.4];
}

- (UIViewController*) topMostController{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    return topController;
}

- (NSString *)urlencode: (NSString *)src {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[src UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
@end
