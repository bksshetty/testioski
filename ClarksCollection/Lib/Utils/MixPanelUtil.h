//
//  MixPanelUtil.h
//  ClarksCollection
//
//  Created by Openly on 19/12/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mixpanel.h"
#import "User.h"

@interface MixPanelUtil : NSObject{
    Mixpanel *mp;
    NSDictionary *eventNames;
}
+ (MixPanelUtil *) instance;

-(void) identify: (User *) user;
-(void) track: (NSString *) event;
-(void) track: (NSString *) event args:(NSString *) trackArgs;
@end
