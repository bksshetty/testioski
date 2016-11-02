//
//  CustomNavigationControllerViewController.m
//  ClarksCollection
//
//  Created by Openly on 06/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "CustomNavigationControllerViewController.h"
#import "API.h"
#import "SWRevealViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface CustomNavigationControllerViewController (){
    UIView *translucentView;
}

@end

@implementation CustomNavigationControllerViewController

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
    id rootController;
    if ([[API instance]isLoggedIn] ){
        rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"region_select"];
    }
    else{
        rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"sign_in"];
    }
    self.revealViewController.delegate = self;
    self.viewControllers = [NSArray arrayWithObjects:rootController, nil];}

@end
