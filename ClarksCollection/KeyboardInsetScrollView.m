//
//  KeyboardInsetScrollView.m
//  KeyboardInsetScrollView
//
//  Created by Cao Huu Loc on 5/6/15.
//  Copyright (c) 2015 Cao Huu Loc. All rights reserved.
//

#import "KeyboardInsetScrollView.h"

@interface KeyboardInsetScrollView ()
@property (nonatomic, strong) UIView *activeControl;
@property (nonatomic, assign) CGRect keyboardRect;
@end

@implementation KeyboardInsetScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.shouldCloseKeyboardWhenTap = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.contentView];
        [KeyboardInsetScrollView addConstraintsForView:self.contentView fitInsideView:self];
        
        //Register keyboard notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Helper methods
+ (float)iOSVersion {
    static CGFloat version = -1.0f;
    if (version <= 0)
    {
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        version = [systemVersion floatValue];
    }
    return version;
}

+ (void)addConstraintsForView:(UIView*)sub fitInsideView:(UIView*)parent {
    sub.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cs1 = [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *cs2 = [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *cs3 = [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *cs4 = [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:cs1, cs2, cs3, cs4, nil];
    [parent addConstraints:arr];
}

+ (void)addConstraintsForView:(UIView*)sub inView:(UIView*)parent sameLocationWithView:(UIView*)frameView {
    sub.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cs1 = [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:frameView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *cs2 = [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:frameView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *cs3 = [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:frameView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *cs4 = [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:frameView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:cs1, cs2, cs3, cs4, nil];
    [parent addConstraints:arr];
}

+ (NSLayoutConstraint*)constraint:(NSLayoutConstraint*)constraint replaceFirstItemBy:(id)newItem {
    UILayoutPriority priority = constraint.priority;
    NSLayoutAttribute firstAttribute = constraint.firstAttribute;
    NSLayoutRelation relation = constraint.relation;
    id secondItem = constraint.secondItem;
    NSLayoutAttribute secondAttribute = constraint.secondAttribute;
    CGFloat multiplier = constraint.multiplier;
    CGFloat constant = constraint.constant;
    
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:newItem attribute:firstAttribute relatedBy:relation toItem:secondItem attribute:secondAttribute multiplier:multiplier constant:constant];
    newConstraint.priority = priority;
    return newConstraint;
}

+ (NSLayoutConstraint*)constraint:(NSLayoutConstraint*)constraint replaceSecondItemBy:(id)newItem {
    UILayoutPriority priority = constraint.priority;
    id firstItem = constraint.firstItem;
    NSLayoutAttribute firstAttribute = constraint.firstAttribute;
    NSLayoutRelation relation = constraint.relation;
    NSLayoutAttribute secondAttribute = constraint.secondAttribute;
    CGFloat multiplier = constraint.multiplier;
    CGFloat constant = constraint.constant;
    
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:firstItem attribute:firstAttribute relatedBy:relation toItem:newItem attribute:secondAttribute multiplier:multiplier constant:constant];
    newConstraint.priority = priority;
    return newConstraint;
}

+ (void)moveSubviewsFromView:(UIView*)source toView:(UIView*)des {
    des.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints = source.constraints;
    NSMutableArray *newConstraints = [[NSMutableArray alloc] initWithCapacity:constraints.count];
    for (NSLayoutConstraint *constraint in constraints) {
        if (constraint.firstItem == source) {
            NSLayoutConstraint *newConstraint = [self constraint:constraint replaceFirstItemBy:des];
            [newConstraints addObject:newConstraint];
        } else if (constraint.secondItem == source) {
            NSLayoutConstraint *newConstraint = [self constraint:constraint replaceSecondItemBy:des];
            [newConstraints addObject:newConstraint];
        } else {
            [newConstraints addObject:constraint];
        }
    }
    
    NSArray *subviews = source.subviews;
    for (UIView *sub in subviews) {
        [sub removeFromSuperview];
        [des addSubview:sub];
    }
    [des addConstraints:newConstraints];
}

+ (void)resignTexfieldsResponderInView:(UIView*)view {
    if ( ([view isKindOfClass:[UITextField class]])
        || ([view isKindOfClass:[UITextView class]])
        || ([view isKindOfClass:[UISearchBar class]])
        ) {
        [view resignFirstResponder];
    } else {
        NSArray *subs = view.subviews;
        for (UIView *sub in subs) {
            [self resignTexfieldsResponderInView:sub];
        }
    }
}

#pragma mark - Touch events
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (self.shouldCloseKeyboardWhenTap) {
        [KeyboardInsetScrollView resignTexfieldsResponderInView:self.contentView];
    }
}

#pragma mark - Private methods
- (CGRect)currentScreenBounds {
    CGRect rect = [UIScreen mainScreen].bounds;
    float wide = MIN(rect.size.width, rect.size.height);
    float tall = MAX(rect.size.width, rect.size.height);
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        return CGRectMake(0, 0, wide, tall);
    } else {
        return CGRectMake(0, 0, tall, wide);
    }
}

- (void)attachContentFromView:(UIView*)contentView {
    if (contentView) {
        self.contentView.backgroundColor = contentView.backgroundColor;
        [KeyboardInsetScrollView moveSubviewsFromView:contentView toView:self.contentView];
        
        [self registerNotificationsFromSubControls];
    }
}

- (void)registerNotificationsInView:(UIView*)view {
    if ([view isKindOfClass:[UITextField class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:view];
    } else if ([view isKindOfClass:[UITextView class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:view];
    } else {
        for (UIView *sub in view.subviews) {
            [self registerNotificationsInView:sub];
        }
    }
}

- (void)registerNotificationsFromSubControls {
    //Remove old observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    
    //Register new observer
    [self registerNotificationsInView:self.contentView];
}

- (void)scrollToSeeActiveControl {
    if (!self.activeControl)
        return;
    if (self.keyboardRect.size.height == 0)
        return;
    
    CGRect screen = [self currentScreenBounds];
    screen.size.height -= self.keyboardRect.size.height;
    
    UIView *toView = nil;
    if ([KeyboardInsetScrollView iOSVersion] < 8.0) {
        toView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    }
    CGRect convertedFrame = [self.activeControl convertRect:self.activeControl.bounds toView:toView];
    if (screen.size.height < convertedFrame.origin.y) {
        CGRect visibleFrame = [self.activeControl convertRect:self.activeControl.bounds toView:self.contentView];
        [self scrollRectToVisible:visibleFrame animated:YES];
        
    }
}

#pragma mark - Public method
- (void)injectToView:(UIView*)injectedView withRootView:(UIView*)rootView {
    [self attachContentFromView:injectedView];
    
    UIView *parent = injectedView.superview;
    if (parent) {
        injectedView.hidden = YES;
        [parent addSubview:self];
        [KeyboardInsetScrollView addConstraintsForView:self inView:parent sameLocationWithView:injectedView];
    } else {
        [injectedView addSubview:self];
        [KeyboardInsetScrollView addConstraintsForView:self fitInsideView:injectedView];
    }
    
    //Define size for contentView inside scrollview
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:injectedView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:injectedView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:injectedView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}

#pragma mark - Notifications
- (void)textFieldDidBeginEditing:(NSNotification *)notification {
    self.activeControl = notification.object;
    [self scrollToSeeActiveControl];
}

- (void)textViewDidBeginEditing:(NSNotification *)notification {
    self.activeControl = notification.object;
    [self scrollToSeeActiveControl];
}

- (void)keyboardWasShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    self.keyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if ([KeyboardInsetScrollView iOSVersion] < 8.0) {
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGRect correctRect = CGRectMake(self.keyboardRect.origin.x, self.keyboardRect.origin.y, self.keyboardRect.size.height, self.keyboardRect.size.width);
            self.keyboardRect = correctRect;
        }
    }
    
    CGRect screen = [self currentScreenBounds];
    
    UIView *toView = nil;
    if ([KeyboardInsetScrollView iOSVersion] < 8.0) {
        toView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    }
    CGRect contentRect = [self.contentView convertRect:self.contentView.bounds toView:toView];
    
    float space = screen.size.height - (contentRect.origin.y + contentRect.size.height);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.keyboardRect.size.height - space, 0.0);
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
    [self scrollToSeeActiveControl];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.keyboardRect = CGRectZero;
    [UIView animateWithDuration:0.2 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.contentInset = contentInsets;
        self.scrollIndicatorInsets = contentInsets;
    }];
}

@end
