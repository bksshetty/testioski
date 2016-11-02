//
//  UILabel+dynamicSizeMe.m
//  ClarksCollection
//
//  Created by Openly on 01/12/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "UILabel+dynamicSizeMe.h"
#import "ClarksFonts.h"

@implementation UILabel (dynamicSizeMe)
-(float)resizeToFit{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

-(float)expectedHeight{
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font = [ClarksFonts clarksSansProRegular:16];
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
    CGRect expectedLabelRect = [[self text] boundingRectWithSize:maximumLabelSize
                                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                      attributes:attributesDictionary
                                                         context:nil];
    CGSize *expectedLabelSize = &expectedLabelRect.size;
    return expectedLabelSize->height;
}


@end
