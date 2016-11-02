//
//  ChangeTeritoryViewController.m
//  ClarksCollection
//
//  Created by Openly on 21/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ChangeTeritoryViewController.h"
#import "AppDelegate.h"
#import "ClarksFonts.h"
#import "SWRevealViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface ChangeTeritoryViewController ()

@end

@implementation ChangeTeritoryViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.lbl.font = [ClarksFonts clarksSansProLight:12.0f];
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if(appDelegate.selectedTerritory) {
    }
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

#pragma mark - Navigation
- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onApply:(id)sender {
    NSArray *selectedTerritories = [self.tblView indexPathsForSelectedRows];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([selectedTerritories count] > 0)
        appDelegate.selectedTerritory = (NSIndexPath*)selectedTerritories[0];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
