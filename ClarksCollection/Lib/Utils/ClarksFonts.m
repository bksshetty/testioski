//
//  NS360Fonts.m
//  NS 360
//
//  Created by Openly on 25/08/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ClarksFonts.h"

@implementation ClarksFonts
+(UIFont *) clarksSansProLight:(float)size{
    return [UIFont fontWithName:@"ClarksSansPro-Light" size:size];
}
+(UIFont *) clarksSansProRegular:(float)size{
    return [UIFont fontWithName:@"ClarksSansPro-Regular" size:size];
}
+(UIFont *) clarksSansProThin:(float)size{
    return [UIFont fontWithName:@"ClarksSansPro-Thin" size:size];
}

+(UIFont *) clarksNarzissMediumBd:(float)size{
    return [UIFont fontWithName:@"NarzissClarks-MediumBd" size:size];
}

+ (NSMutableAttributedString *) addSpaceBwLetters:(NSString *) btnName alpha:(float)f{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:btnName];
    float spacing = f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [btnName length])];
    return attributedString;
}

@end
