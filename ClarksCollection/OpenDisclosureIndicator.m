//
//  OpenDisclosureIndicator.m
//  ClarksCollection
//
//  Created by Openly on 10/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "OpenDisclosureIndicator.h"

@implementation OpenDisclosureIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (OpenDisclosureIndicator *)accessoryWithColor:(UIColor *)color
{
	OpenDisclosureIndicator *ret = [[OpenDisclosureIndicator alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)];
	ret.accessoryColor = color;
    
	return ret;
}
                                    
- (void)drawRect:(CGRect)rect
{
        // (x,y) is the tip of the arrow
        CGFloat x = CGRectGetMaxX(self.bounds)-3.0;;
        CGFloat y = CGRectGetMidY(self.bounds);
        const CGFloat R = 4.5;
        CGContextRef ctxt = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(ctxt, x-R, y-R);
        CGContextAddLineToPoint(ctxt, x, y);
        CGContextAddLineToPoint(ctxt, x-R, y+R);
        CGContextSetLineCap(ctxt, kCGLineCapSquare);
        CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
        CGContextSetLineWidth(ctxt, 3);
        
        if (self.highlighted)
        {
            [self.highlightedColor setStroke];
        }
        else
        {
 //           [self.accessoryColor setStroke];
        }
        
        CGContextStrokePath(ctxt);
}
                                    
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
        
    [self setNeedsDisplay];
}
                                    
@end
