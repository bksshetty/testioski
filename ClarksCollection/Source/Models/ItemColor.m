//
//  ItemColor.m
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ItemColor.h"
#import "ClarksUI.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation ItemColor
static int curIdx;
+ (void) resetIdx{
    curIdx = 0;
}
-(NSString *)giveMeValidString:(NSString *) strTest {
    if([strTest isKindOfClass:[NSString class]]) {
        if(strTest != nil){
            return strTest;
        }
    }
    return @"";
}

- (ItemColor *) initWithDict: (NSDictionary *) dict{
    if ([self init]) {
        self.name = [dict valueForKey: @"name"];
        self.colorId = [dict valueForKey: @"id"];
        self.material = [self giveMeValidString:[dict valueForKey:@"material"]];
        self.thumbs = [[dict valueForKey: @"images"] valueForKey:@"thumb"];
        self.mediumImages = [[dict valueForKey: @"images"] valueForKey:@"medium"];
        self.largeImages = [[dict valueForKey: @"images"] valueForKey:@"large"];
        
        if(self.thumbs == nil)
            self.thumbs =[[dict valueForKey: @"images"] valueForKey:@"thumbs"];
        
        if(self.largeImages == nil)
            self.largeImages = [[dict valueForKey: @"images"] valueForKey:@"full_scale"];
        
        if(self.images360 == nil)
            self.images360 = [[dict valueForKey: @"images"] valueForKey:@"360"];
        
        self.wholeSalePrice = [NSNumber numberWithFloat:0.0f];
        self.retailPrice = [NSNumber numberWithFloat:0.0f];
        
        if ([dict valueForKey:@"fad"]!= nil) {
            self.fad =  [dict valueForKey:@"fad"];
        }
        if ([dict valueForKey:@"rrp_price"]!= nil) {
            self.rrp = [dict valueForKey:@"rrp_price"];
        }
        self.idx = curIdx++;
    }
    return self;
}
@end
