//
//  DeleteView.m
//  ClarksCollection
//
//  Created by Adarsh on 20/05/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "DeleteView.h"
#import "ClarksColors.h"
#import "ListViewController.h"
#import "AppDelegate.h"

@implementation DeleteView{
    int index;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Adding a status bar with black background.
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
        statusBarView.backgroundColor  =  [UIColor blackColor];
        
        // Adding Top View.
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 80)];
        topView.backgroundColor = [UIColor whiteColor];
        
        // Creating "CLOSE" button
        UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(882, 45, 106, 16)];
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/close-icon.png"];
        UIImage *closeImg = [UIImage imageWithContentsOfFile:fullpath];
        [btnClose setImage:closeImg forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(didClickClose) forControlEvents:UIControlEventTouchUpInside];
        
        // Adding Bottom View.
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 1024, 768)];
        bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        
        // Create Delete View.
        UIView *deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, 317, 678, 130)];
        deleteView.backgroundColor = [UIColor whiteColor];
        deleteView.alpha = 1.0;
        deleteView.center = CGPointMake(CGRectGetWidth(bottomView.bounds)/2.0f, 317);
        deleteView.layer.cornerRadius = 3;
        
        // Create Label inside Delete View
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 800, 15)];
        lbl.text = @"A R E  Y O U  S U R E  Y O U  W A N T  T O  D E L E T E  T H I S  L I S T ?";
        lbl.font = [UIFont fontWithName:@"GillSans-Light" size:15];
        [lbl setTintColor:[ClarksColors gillsansDarkGray]];
        [lbl setTextColor:[ClarksColors gillsansDarkGray]];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.center = CGPointMake(CGRectGetWidth(deleteView.bounds)/2.0f, 30);
        
        // Create Yes and No buttons
        UIButton *yesBtn = [[UIButton alloc] initWithFrame:CGRectMake(237, 65, 87, 40)];
        [yesBtn  setTitle:@"Y E S" forState:UIControlStateNormal];
        yesBtn.font = [UIFont fontWithName:@"GillSans" size:13];
        yesBtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        yesBtn.layer.borderWidth = 1;
        yesBtn.layer.cornerRadius = 3;
        [yesBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        [yesBtn addTarget:self action:@selector(didClickYes) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *noBtn = [[UIButton alloc] initWithFrame:CGRectMake(354, 65, 87, 40)];
        [noBtn  setTitle:@"N O" forState:UIControlStateNormal];
        noBtn.font = [UIFont fontWithName:@"GillSans" size:13];
        noBtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        noBtn.layer.borderWidth = 1;
        noBtn.layer.cornerRadius = 3;
        [noBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        [noBtn addTarget:self action:@selector(didClickClose) forControlEvents:UIControlEventTouchUpInside];
        
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [bottomView addGestureRecognizer:swipeUp];
        self.userInteractionEnabled = YES;
        // Adding Yes and No buttons to Delete View
        [deleteView addSubview:lbl];
        [deleteView addSubview:yesBtn];
        [deleteView addSubview:noBtn];
        
        // Adding close button to the topView
        [topView addSubview:btnClose];
        [topView addSubview:statusBarView];
        
        // Adding Delete View.
        [bottomView addSubview:deleteView];
        
        [self viewController].revealViewController.panGestureRecognizer.enabled = NO;
        [self addSubview:topView];
        [self addSubview:bottomView];
      }
    return self;
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        self.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:nil userInfo:nil];
    }
}

-(void)didClickClose{
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:nil userInfo:nil];
}

-(void) getIndex: (int)idx{
    index = idx;
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

-(void) didClickYes{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.listViewController.tableView reloadData];
    Lists *listToBeDeleted = [appDelegate.listofList objectAtIndex:index];
    if([listToBeDeleted isEqual:appDelegate.activeList])
    {
        [appDelegate markListAsActive:nil];
    }
    [appDelegate.listofList removeObjectAtIndex:index];
    [appDelegate saveList];
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:nil userInfo:nil];
}
@end
