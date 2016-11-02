//
//  UIView+Constraints.m
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "UIView+Constraints.h"
#import <objc/runtime.h>

@implementation UIView (Constraints)
@dynamic leftConstraint;
@dynamic topConstraint;
@dynamic widthConstraint;

- (void)setLeftConstraint:(NSLayoutConstraint *)leftConstraint {
    objc_setAssociatedObject(self, @selector(leftConstraint), leftConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *) leftConstraint{
    return objc_getAssociatedObject(self, @selector(leftConstraint));
}


- (void)setTopConstraint:(NSLayoutConstraint *)topConstraint {
    objc_setAssociatedObject(self, @selector(topConstraint), topConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *) topConstraint{
    return objc_getAssociatedObject(self, @selector(topConstraint));
}


- (void)setWidthConstraint:(NSLayoutConstraint *)widthConstraint {
    objc_setAssociatedObject(self, @selector(widthConstraint), widthConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *) widthConstraint{
    return objc_getAssociatedObject(self, @selector(widthConstraint));
}
@end
