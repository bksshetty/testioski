//
//  HelpViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "HelpViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "ClarksFonts.h"

@interface HelpViewController (){
    UIView *translucentView;
}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[MixPanelUtil instance] track:@"help"];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate = self;
    self.revealViewController.frontViewShadowRadius = 0;
    
    self.header1.attributedText = [ClarksFonts addSpaceBwLetters:self.header1.text alpha:2.7];
    self.header2.attributedText = [ClarksFonts addSpaceBwLetters:self.header2.text alpha:2.7];
    self.header3.attributedText = [ClarksFonts addSpaceBwLetters:self.header3.text alpha:2.7];
    self.header4.attributedText = [ClarksFonts addSpaceBwLetters:self.header4.text alpha:2.7];
    
    self.desc11.attributedText = [ClarksFonts addSpaceBwLetters:self.desc11.text alpha:1.2];
    self.desc12.attributedText = [ClarksFonts addSpaceBwLetters:self.desc12.text alpha:1.2];
    self.desc21.attributedText = [ClarksFonts addSpaceBwLetters:self.desc21.text alpha:1.2];
    self.desc22.attributedText = [ClarksFonts addSpaceBwLetters:self.desc22.text alpha:1.2];
    self.desc23.attributedText = [ClarksFonts addSpaceBwLetters:self.desc23.text alpha:1.2];
    self.desc31.attributedText = [ClarksFonts addSpaceBwLetters:self.desc31.text alpha:1.2];
    self.desc32.attributedText = [ClarksFonts addSpaceBwLetters:self.desc32.text alpha:1.2];
    self.desc33.attributedText = [ClarksFonts addSpaceBwLetters:self.desc33.text alpha:1.2];
    self.desc34.attributedText = [ClarksFonts addSpaceBwLetters:self.desc34.text alpha:1.2];
    self.desc41.attributedText = [ClarksFonts addSpaceBwLetters:self.desc41.text alpha:1.2];
    self.desc42.attributedText = [ClarksFonts addSpaceBwLetters:self.desc42.text alpha:1.2];
    
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position{
    if (position == FrontViewPositionLeft) {
        self.view.alpha = 1;
        translucentView.hidden = YES;
    }else if(position == FrontViewPositionRight){
        self.view.alpha = 0.15;
        translucentView.hidden = NO;
    }
}

- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress{
    if (progress > 1) {
        self.view.alpha = 0.15;
    }else if(progress == 0){
        self.view.alpha = 1;
        translucentView.hidden = YES;
    }else{
        self.view.alpha = 1 - (0.85 * progress);
        translucentView.hidden = NO;
    }
    NSLog(@"%f - %f",progress, self.view.alpha);
}

@end
