//
//  KeyboardInsetScrollView.h
//  KeyboardInsetScrollView
//
//  Created by Cao Huu Loc on 5/6/15.
//  Copyright (c) 2015 Cao Huu Loc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardInsetScrollView : UIScrollView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL shouldCloseKeyboardWhenTap;

- (void)injectToView:(UIView*)injectedView withRootView:(UIView*)rootView;

@end
