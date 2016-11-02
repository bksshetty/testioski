//
//  MixPanelUtil.m
//  ClarksCollection
//
//  Created by Openly on 19/12/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "MixPanelUtil.h"
#import "Mixpanel.h"
#import "User.h"
#import "Region.h"
#import "API.h"
#import "AppDelegate.h"

@implementation MixPanelUtil
static MixPanelUtil *theInstance;

- (instancetype)init{
    self = [super init];
    if (self) {
        mp = [Mixpanel sharedInstanceWithToken:@"f42d0417f6c68084d0277bd361acc6d6"];
        
        NSString *mixpanelEventsFile = [[NSBundle mainBundle]pathForResource:@"mixpanel-events" ofType:@"json"];
        NSError *e;
        eventNames = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:mixpanelEventsFile] options:kNilOptions error:&e];
    }
    return self;
}
+ (MixPanelUtil *) instance{
    if (theInstance == nil) {
        theInstance = [[MixPanelUtil alloc] init];
    }
    return theInstance;
}
-(void) track: (NSString *) event{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!API.instance.isTestMode) {
        if (!appDelegate.mixpanelBlockedUser) {
            [mp track:[self eventNameFor:event]] ;
        }
    }
}

-(void) track: (NSString *) event args:(NSString *) trackArgs{
    Region *current = [Region getCurrent];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *trackString = [[NSString alloc] initWithFormat:[self eventNameFor:event], trackArgs];
    if (!API.instance.isTestMode) {
        if (!appDelegate.mixpanelBlockedUser) {
            if (current!= NULL) {
                [mp track:trackString properties:@{@"Sales-Region": current.name, @"Data-Version": [NSString stringWithFormat:@"%d", appDelegate.dataVersion]}];
            }else{
                [mp track:trackString];
            }
        }
    }
}

- (NSString *) eventNameFor: (NSString *) eventID{
    return [eventNames valueForKey:eventID];
}
-(void) identify: (User *) user{
    [mp identify: [user uniqueID]];
    [mp.people set:@{@"name":user.name}];
}
@end
