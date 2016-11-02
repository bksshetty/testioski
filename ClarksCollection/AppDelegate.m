//
//  AppDelegate.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "ImageDownloadManager.h"
#import "ImageDownloader.h"
#import "ClarksColors.h"
#import "ItemColor.h"
#import "ListItem.h"
#import "Lists.h"
#import "User.h"
#import "DiscoverCollection.h"
#import "API.h"
#import "LoginViewController.h"
#import "ClarksUI.h"
#import "DataReader.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.firstLaunch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"firstLaunch"];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(startupTasks) userInfo:nil repeats:NO];
    [Fabric with:@[[Crashlytics class]]];
    return YES;
}

-(void) startupTasks{
    [[UITextField appearance] setTintColor:[ClarksColors clarksMediumGrey]];
    [self.window setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.memdiumSizedImageRequired = true ;
    [Crashlytics startWithAPIKey:@"b433afd2053bd1c6b8f6f3a283c46f07d6ad6821"];
    [[MixPanelUtil instance] track:@"app_start"];
    [self getMinimumAppVersion];
    [self tryUpdate];
    [self doUpdateLists];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self getMinimumAppVersion];
    [[ImageDownloader instance] reActivate];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) downloadProductInfo:(BOOL) updateLocalData onComplete:(void(^)(void)) handler{
    
    [self downloadProductInfo:updateLocalData showAlert:YES onComplete:handler];
}

-(void) downloadProductInfo:(BOOL) updateLocalData showAlert: (BOOL)showAlert onComplete:(void(^)(void)) handler {
    [self getMinimumAppVersion];
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/data1.json",
                          documentsDirectory];
    NSDictionary *data = [DataReader read];
    NSInteger deviceVersion = [[data valueForKey:@"version"] integerValue];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    if (self.minAppVersion <= [version doubleValue]) {
        [[API instance] get:@"products-version"  onComplete:^(NSDictionary  *results) {
            if(results != nil) {
                NSInteger serverVersion =[[results valueForKey:@"version"] integerValue];
                if(serverVersion > deviceVersion) {
                    [[API instance] getOnlyData:@"products"  onComplete:^(NSData  *results) {
                            BOOL status = [results writeToFile:fileName1 atomically:YES];
                            CLSNSLog(@"writing to file %d",status);
                            if (self.firstLaunch == 0) {
                                LoginViewController* loginVC = (LoginViewController*) self.window.rootViewController;
                                [loginVC hideLoading];
                            } else {
                                [self showAlertBox];
                            }
                            handler();
                            
                            return;
                        }];
                }else {
                    if (self.firstLaunch == 0) {
                        LoginViewController* loginVC = (LoginViewController*) self.window.rootViewController;
                        [loginVC hideLoading];
                    }
                    if(updateLocalData == NO){
                        if (showAlert) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Catalogue is current"
                                                                            message:@"Your catalogue is up to date"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Close"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            alert.tag =2 ;
                        }
                        handler();
                    }
                    self.dataState = DataIsCurrent;
                }
            }
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incompatible App Version"
                                                        message:@"Your appplication needs to be updated inorder to view the latest catalog. Please update your application."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert.tag = 3;
    }
    if(updateLocalData)
        [ImageDownloadManager preload];
    if (self.memdiumSizedImageRequired) {
        [NSTimer scheduledTimerWithTimeInterval:(10.0) target:self selector:@selector(removeReference) userInfo:nil repeats:NO];
    }
}

-(void) showAlertBox{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New catalogue available"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Ignore"
                                          otherButtonTitles:@"Refresh",nil];
    alert.tag = 1;
    [alert show];
}

- (void) getMinimumAppVersion{
    [[API instance] get:@"minimum-app-version" onComplete:^(NSDictionary *results) {
        if ([[results valueForKey:@"status"] isEqualToString:@"success"]) {
            self.minAppVersion = [[results valueForKey:@"version"] doubleValue];
        }
    }];
}

- (void)removeReference{
    [ImageDownloadManager removeUnreferencedImages];
}

- (void) tryUpdate{
    [self downloadProductInfo:NO showAlert:NO onComplete:^{
    }];
}

- (void) doUpdateLists{
    [NSTimer scheduledTimerWithTimeInterval:(15.0f*60) target:self selector:@selector(updateLists) userInfo:nil repeats:YES];
}

-(void) replaceFiles{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFile = [documentsDirectory stringByAppendingPathComponent:@"data1.json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFile];
    NSString *fileName = [NSString stringWithFormat:@"%@/data.json",
                          documentsDirectory];
    BOOL status = [data writeToFile:fileName atomically:YES];
    if (status) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:dataFile error:&error];
    }
    self.dataState = DataIsCurrent;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            [self replaceFiles];
            self.dataState = DataIsCurrent;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil userInfo:nil];
        }else{
            self.dataState = DataDownloaded;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Ignore" object:nil userInfo:nil];
        }
    }
    if (alertView.tag ==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noCatalouge" object:nil userInfo:nil];
    }
    if (alertView.tag == 3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noCatalouge" object:nil userInfo:nil];
    }
}
-(void)saveList {
    NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
    [NSKeyedArchiver archiveRootObject:self.listofList toFile:appFile];
}

- (void)updateLists{
    NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
    NSData *data = [NSData dataWithContentsOfFile:appFile];
    NSString *content = [data base64EncodedStringWithOptions:0];
    if(content != nil){
        [[API instance] post:@"update-lists"
                      params:@{@"listsData": content
                               }
                  onComplete:^(NSDictionary *results) {
                      if(results == nil) {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:@"No network connectivity or server down"
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          [alert show];
                          return;
                      }
                      NSString *strResult = [results valueForKey:@"status"];
                      if ([strResult isEqualToString:@"success"]) {
                          CLSNSLog(@"Success!!!");
                      }
                      else{
                          CLSNSLog(@"Failed");
                      }
                  }];
    }
}

-(void)restoreList {
    NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
    self.listofList = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    Lists *listItem ;
    for (listItem in self.listofList){
        [listItem sort] ;
    }
    if(self.listofList == nil)
        self.listofList = [[NSMutableArray alloc]initWithCapacity:1];
    self.activeList = nil;
    self.filtereditemArray = nil;
}

-(void) markListAsActive:(Lists *)theList {
    self.activeList = theList;
    [self reconcileFilteredArrayWithActiveList];
}

-(void) removeItemColorFromActiveList:(Item *)theItem itemColor:(ItemColor *)theColor {
    Lists *activeList = self.activeList;
    if(activeList != nil) {
        [activeList deleteItemColorFromList:theColor.colorId];
        [self saveList];
    }
    ItemColor *theItemColor;
    for(theItemColor in theItem.colors) {
        if([theItemColor.colorId isEqualToString:theColor.colorId])
            theItemColor.isSelected = NO;
    }
    BOOL anyColorSelected = NO;
    for(theItemColor in theItem.colors) {
        if(theItemColor.isSelected ) {
            anyColorSelected = YES;
            break;
        }
    }
    if(anyColorSelected)
        theItem.isSelected = YES;
    else
        theItem.isSelected = NO;
}

-(void) reconcileFilteredArrayWithActiveList {
    Item *theItem;
    ItemColor *theColor;
    for( theItem in self.filtereditemArray) {
        for (theColor in theItem.colors) {
            theColor.isSelected = NO;
        }
        theItem.isSelected = NO;
    }
    Lists *theList = self.activeList;
    if ( (self.filtereditemArray != nil) && (theList != nil)) {
        for (ListItem *theListItem in theList.listOfItems) {
            for( Item *theItem in self.filtereditemArray) {
                for (ItemColor *theColor in theItem.colors) {
                    if([theColor.colorId isEqualToString:theListItem.itemNumber]) {
                        theColor.isSelected = YES;
                        theItem.isSelected = YES;
                    }
                }
            }
        }
    }
}

- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [[ImageDownloader instance] doNextDownloads];
}

-(void) application: (UIApplication *) applicationDidReceiveMemoryWarning{
    [[MixPanelUtil instance] track:@"didReceiveMemoryWarning"];
}

- (void) application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    completionHandler();
}

@end