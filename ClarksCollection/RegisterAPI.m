//
//  RegisterAPI.m
//  ClarksCollection
//
//  Created by Adarsh on 15/07/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "RegisterAPI.h"
#import "ClarksUI.h"
#import "API.h"
#import "SettingsUtil.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "MixpanelUtil.h"

@implementation RegisterAPI

static NSDictionary *regs;

+ (NSDictionary *) getRegions{
    if (regs!= nil) {
        return regs;
    }
    [[API instance]get:@"regions" onComplete:^(NSDictionary *results) {
        if(results == nil) {
            [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            regs = [results valueForKey:@"regions"];
        }
    }];
    return regs;
}

- (void) registerUser:(NSString *) firstName
            lastName:(NSString *) lastName
            userName:(NSString *) userName
               email:(NSString *) email
              region:(NSString *) region_name
            password:(NSString *) password
         confirmPass:(NSString *) confirmPass{
    UIView *loader = [ClarksUI showLoader:self.parentVC.view];
    [[API instance] post:@"app-user/create"
                  params:@{@"userName":userName,
                           @"password": password,
                           @"confirmPassword":confirmPass,
                           @"firstName":firstName,
                           @"lastName":lastName,
                           @"region":region_name,
                           @"email":email
                }
              onComplete:^(NSDictionary *results) {
                  [loader removeFromSuperview];
                  if(results == nil) {
                      [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
                  }
                  NSString *strResult = [results valueForKey:@"status"];
                  if ([strResult isEqualToString:@"success"]) {
                      [[MixPanelUtil instance] track:@"userRegistered" args:((NSString *) userName)];
                      [_parentVC.confirmView setHidden:NO];
                  }
                  else if ([strResult isEqualToString:@"failed"]){
                      [[MixPanelUtil instance] track:@"registrationFailed"];
                      NSArray *errors  = [results valueForKey:@"errors"] ;
                      NSString *error_msg = @"";
                      for (NSString *error in errors){
                          error_msg = [NSString stringWithFormat:@"%@ %@",error,error_msg];
                      }
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In-App Registration"
                                                                      message: error_msg
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                      [alert show];
                  }
              }];
}

@end
