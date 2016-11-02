//
//  SettingsUtil.m
//  ClarksCollection
//
//  Created by Openly on 31/08/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "SettingsUtil.h"
#import "Reachability.h"
#import <Foundation/Foundation.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation SettingsUtil

- (NSDictionary *)getContentsOfSettingsFile{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSDictionary *settings ;
    if (path != nil) {
        settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return settings ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Control coming Here");
    if (buttonIndex == 1) {
        BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
        if (canOpenSettings) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (BOOL) networkRechabilityMethod{
    // Checking for internet connection.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    NSDictionary *res =  [self getContentsOfSettingsFile] ;
    NSDictionary *forgotPass = [res valueForKey:@"NetworkDownError"] ;
    NSString *title = [forgotPass valueForKey:@"title"];
    NSString *message = [forgotPass valueForKey:@"message"] ;
    if (title == nil && message == nil) {
        title = @"" ;
        message = @"";
    }
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return true;
    }
    return false;
}

- (void) CMSNullErrorMethod{
    NSDictionary *res =  [self getContentsOfSettingsFile] ;
    NSDictionary *genErr = [res valueForKey:@"CMSNullReturnError"] ;
    NSString *title = [genErr valueForKey:@"title"];
    NSString *message = [genErr valueForKey:@"message"] ;
    if (title == nil && message == nil) {
        title = @"" ;
        message = @"";

    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                              message:message
                                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alert show];
    return;
}
@end
