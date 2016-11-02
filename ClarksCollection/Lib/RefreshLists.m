//
//  RefreshLists.m
//  ClarksCollection
//
//  Created by Adarsh on 21/07/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "RefreshLists.h"
#import "AppDelegate.h"
#import "API.h"
#import "User.h"

@implementation RefreshLists

+(void) getLists{
    [[API instance]get:@"get-lists" onComplete:^(NSDictionary *results) {
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
            NSData *content = [results valueForKey:@"listsData"];
            NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
            NSData *data = [[NSData alloc] initWithBase64EncodedData:content options:0];
            [content writeToFile:[documentsDirectory stringByAppendingPathComponent:@"api.txt"] atomically:YES];
            [data writeToFile:appFile atomically:YES];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate restoreList];
            
        }else{
            NSLog(@"Failure");
        }
    }];
}

+ (void)updateLists{
    NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
    NSData *data = [NSData dataWithContentsOfFile:appFile];
    NSString *content = [data base64EncodedStringWithOptions:0];
    if(content != nil){
        [[API instance] post:@"update-lists"
                      params:@{@"listsData": content}
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
                          NSLog(@"Success!!!");
                      }else{
                          NSLog(@"Failed");
                      }
                  }];
    }
}


@end
