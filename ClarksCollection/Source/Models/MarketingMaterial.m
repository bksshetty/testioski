//
//  MarketingMaterial.m
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "MarketingMaterial.h"
#import "TemplatizedData.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation MarketingMaterial

- (MarketingMaterial *) initWithDict: (NSDictionary *) dict {
    if ([self init]) {
        self.name = [dict valueForKey:@"name"];
        self.isTemplatized = [[dict valueForKey:@"type"] isEqualToString:@"Templated"]?YES:NO;
        self.headerImage = [dict valueForKey:@"header_image"];
        if ([dict valueForKey:@"id"] != NULL || [dict valueForKey:@"id"] != nil) {
            self.idx = [dict valueForKey:@"id"];
        }
        self.templatizedData = [[NSMutableArray alloc]init];
        if(self.isTemplatized) {
            self.heading =[dict valueForKey:@"heading"];
            self.subHeading =[dict valueForKey:@"sub_heading"];
            NSArray *sectionArray =[dict valueForKey:@"sections"];
            for(NSDictionary *theTemplatizedDictionary in sectionArray) {
                TemplatizedData *theTemplatizedData = [[TemplatizedData alloc]initWithDict:theTemplatizedDictionary];
                [self.templatizedData addObject:theTemplatizedData];
            }
        }
        else {
            self.detailImages = [dict valueForKey:@"detail_images"]; // array
        }
    }
    return self;
}

@end
