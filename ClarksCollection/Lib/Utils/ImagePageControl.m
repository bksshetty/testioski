//
//  ImagePageControl.m
//  ClarksCollection
//
//  Created by Adarsh on 23/05/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "ImagePageControl.h"

@implementation ImagePageControl

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    activeImage = [UIImage imageNamed:@"page-control-icon-filled.png"];
    inactiveImage = [UIImage imageNamed:@"page-control-icon-empty.png"];
    return self;
}

-(void) updateDots{
    for (int i = 0; i < [self.subviews count]; i++){
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }
}

- (UIImageView *) imageViewForSubview: (UIView *) view{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]]){
        for (UIView* subview in view.subviews){
            if ([subview isKindOfClass:[UIImageView class]]){
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil){
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else{
        dot = (UIImageView *) view;
    }
    return dot;
}

-(void) setCurrentPage:(NSInteger)page{
    [super setCurrentPage:page];
    [self updateDots];
}
@end
