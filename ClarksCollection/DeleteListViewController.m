//
//  DeleteListViewController.m
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DeleteListViewController.h"
#import "ClarksFonts.h"
#import "ListViewController.h"
#import "AppDelegate.h"
#import "Lists.h"
#import "SWRevealViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface DeleteListViewController ()

@end

@implementation DeleteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.lblConfirmation setFont:[ClarksFonts clarksSansProThin:40]];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Swipe Up");
        [self.navigationController popViewControllerAnimated:YES];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"Swipe Down");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doPerformDelete:(id)sender {
#ifdef DEBUG
    CLSNSLog(@"DeleteListViewController: doPerformDelete: Entry");
#endif
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"List of lists: %lu", (unsigned long)[appDelegate.listofList count]);
    Lists *listToBeDeleted = [appDelegate.listofList objectAtIndex:self.index];
    
    if([listToBeDeleted isEqual:appDelegate.activeList])
    {
        [appDelegate markListAsActive:nil];
    }
    
    [appDelegate.listofList removeObjectAtIndex:self.index];
    [appDelegate saveList];
    //[self goBack];
#ifdef DEBUG
    CLSNSLog(@"DeleteListViewController: doPerformDelete: Exit");
#endif
}

- (IBAction)doNothing:(id)sender {
    [self goBack];
}


- (UIViewController*) topMostController
{
#ifdef DEBUG
    CLSNSLog(@"DeleteListViewController: topMostController: Entry");
#endif
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
#ifdef DEBUG
    CLSNSLog(@"DeleteListViewController: topMostController: Exit");
#endif
    return topController;
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
