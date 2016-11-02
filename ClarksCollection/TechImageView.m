//
//  TechImageView.m
//  ClarksCollection
//
//  Created by Openly on 26/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "TechImageView.h"
#import "DataReader.h"
#import "ManagedImage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation TechImageView

-(TechImageView *)initWithData:(NSData *)data fori:(int)fori techLogos:(NSDictionary *)techLogos{
    UIImage *img = [UIImage imageWithData:data];
    CGFloat width = img.size.width / 2;
    CGFloat height = img.size.height/2;
    if(img.size.width > 150) {
        width = img.size.width/4;
        height = img.size.height/4;
    }
    if(img.size.width > 300) {
        width = img.size.width / 8;
        height = img.size.height/8;
    }
    CGRect f = CGRectMake(244 - (78 * fori), 595,  width, height );
    self = [super initWithImage:[UIImage imageWithData:data]];
    [self setFrame:f];
    self.contentMode = UIViewContentModeScaleAspectFit;
    return self;
}

@end
