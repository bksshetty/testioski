//
//  RegisterAPI.h
//  ClarksCollection
//
//  Created by Adarsh on 15/07/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InAppRegistrationViewController.h"

@interface RegisterAPI : NSObject
@property (weak, nonatomic) IBOutlet InAppRegistrationViewController *parentVC;
+ (NSDictionary *) getRegions;
- (void) registerUser:(NSString *) firstName
             lastName:(NSString *) lastName
             userName:(NSString *) userName
                email:(NSString *) email
               region:(NSString *) region_name
             password:(NSString *) password
          confirmPass:(NSString *) confirmPass ;

@end
