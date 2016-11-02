//
//  SettingsScreenViewController.m
//  ClarksCollection
//
//  Created by Openly on 27/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "SettingsScreenViewController.h"
#import "DownloadManagerViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "AccountSettingsViewController.h"
#import "AssortmentSelectViewController.h"

@interface SettingsScreenViewController (){
    UIView *translucentView;
}
@end

@implementation SettingsScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.revealViewController.frontViewShadowRadius = 0;
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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

-(void) viewDidAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
    if ([segue.identifier isEqualToString:@"download_manager"]) {
        DownloadManagerViewController *vc = (DownloadManagerViewController *) segue.destinationViewController;
        [vc hideHelpView];
    }
}

- (IBAction)didClickAccount:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                message:@"You must be connected to the internet to change your settings."
                                                delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [alert show];
        return;
    }else{
        AccountSettingsViewController * assort = [self.storyboard instantiateViewControllerWithIdentifier:@"accountSettings"];
        [self.navigationController pushViewController:assort animated:NO];
    }
}

@end