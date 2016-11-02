//
//  ClarksUI.m
//  Clarks Collection
//
//  Created by Openly on 26/08/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ClarksUI.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Constraints.h"

@implementation ClarksUI
+(UIView*) showLoader:(UIView *)view{
    CGRect frame = CGRectMake(0,0,view.bounds.size.width,view.bounds.size.height);
    UIView *translucentView = [[UIView alloc] initWithFrame: frame];
    UIImageView *translucentImage = [[UIImageView alloc] initWithFrame:frame];
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.png"];
    translucentImage.image = [UIImage imageWithContentsOfFile:fullpath];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [spinner startAnimating];
    [translucentView addSubview:translucentImage];
    [translucentView addSubview:spinner];
    [view addSubview: translucentView];
    return translucentView;
}
+(UIView*) showOverlay:(UIView *)view{
    CGRect frame = CGRectMake(0,0,view.bounds.size.width,view.bounds.size.height);
    UIView *translucentView = [[UIView alloc] initWithFrame: frame];
    UIImageView *translucentImage = [[UIImageView alloc] initWithFrame:frame];
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.png"];
    translucentImage.image = [UIImage imageWithContentsOfFile:fullpath];[view addSubview:translucentView];
    [translucentView addSubview:translucentImage];
    return translucentImage;
}

+(void) reposition: (UIView *) view x:(int) newX y:(int) newY{
    UIView *parent = [view superview];
    
    [parent removeConstraint:view.leftConstraint];
    [parent removeConstraint:view.topConstraint];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeLeft multiplier:1.0f constant:(float)newX];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1.0f constant:(float)newY];
    
    view.leftConstraint = leftConstraint;
    view.topConstraint = topConstraint;
    
    [parent addConstraint:leftConstraint];
    [parent addConstraint:topConstraint];
}

+(void) setWidth: (UIView *) view width:(int) newWidth{
    UIView *parent = [view superview];
    
    [parent removeConstraint:view.widthConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(float)newWidth];
    
    view.widthConstraint = widthConstraint;
    [parent addConstraint:widthConstraint];
}

@end