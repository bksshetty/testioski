//
//  MenubarViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "MenubarViewController.h"
#import "ListViewController.h"
#import "SWRevealViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "API.h"
#import "ImageDownloader.h"
#import "User.h"
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "Region.h"
#import "DownloadManagerViewController.h"
#import "AccountSettingsViewController.h"
#import "SettingsUtil.h"
#import "DataReader.h"
#import "ImageDownloadManager.h"
#import "RegionSelectViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface MenubarViewController () {
    NSTimer *statusUpdateTimer;
}
@end

@implementation MenubarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        statusUpdateTimer = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(API.instance.isTestMode){
        self.lblTestMode.hidden = NO ;
    }else{
       self.lblTestMode.hidden = YES ;
    }
    self.revealViewController.rearViewRevealWidth = 300;
    self.lblDownloadInfo.hidden = NO;
    self.btnUpdateData.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.btnUpdateData.layer.borderWidth =1 ;
    self.btnUpdateData.layer.cornerRadius = 3;
    self.btnLogout.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.btnLogout.layer.borderWidth =1 ;
    self.btnLogout.layer.cornerRadius = 3;
    self.btnDiscoverCollection.hidden = YES;
    [self registerForNotifications];
}

-(void) updateStatuses {
    ImageDownloader *dl = [ImageDownloader instance];
    Region *reg = [Region getCurrent];
    User *curUser = [User current];
    NSString *regionName = reg.name;
    if ([regionName isEqualToString:@"EUROPEAN UNION"] || [regionName isEqualToString:@"UK & ROI"]) {
        regionName = @"EUROPE";
    }
    self.regionNamelbl.attributedText = [ClarksFonts addSpaceBwLetters:[NSString stringWithFormat:@"%@", regionName] alpha:2.0];
    self.userNamelbl.attributedText = [ClarksFonts addSpaceBwLetters:[curUser.name uppercaseString] alpha:2.0];
    [[MixPanelUtil instance] track:@"update"];
    NSString *str;
    if([dl totalItems] == 0)
        str = @"DOWLOADED ALL IMAGES";
    else
        str =[NSString stringWithFormat:@"DOWLOADED %d OF %d IMAGES", [dl downloadedItems], [dl totalItems] ];
    self.lblDownloadInfo.text = str;
    return;
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self updateRegion];
    [[API instance] get:@"app-user/get-email-verification-status" onComplete:^(NSDictionary *results) {
        if(results == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"No network connectivity or server down"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            appDelegate.verificationStatus  = [results valueForKey:@"emailVerificationStatus"];
            if([[results valueForKey:@"emailVerificationStatus"] isEqualToString:@"BLOCKED"]){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                AccountSettingsViewController *accountSetting = [storyboard instantiateViewControllerWithIdentifier:@"accountSettings"];
                UINavigationController *navigationController = self.navigationController;
                [navigationController pushViewController:accountSetting animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verification Status"
                                                                message:@"Please verify your email address"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        else{
            CLSNSLog(@"Failed");
        }
    }] ;
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    self.lblVersion.text = [NSString stringWithFormat:@"Version: %@. Data version %d", version, appDelegate.dataVersion];
    NSString *alert_message ;
    if(appDelegate.dataVersion < 1){
        alert_message = @"Please update the catalog else the app might not work as expected." ;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Required"
                                                        message:alert_message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateStatuses];
    statusUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(updateStatuses) userInfo:nil repeats:YES];
}

-(void) updateRegion{
    User *curUser = [User current];
    NSArray * region = curUser.regions;
    if([region count] >1) {
        self.btnChange.hidden = NO;
    } else {
        self.btnChange.hidden = YES;
    }
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuIndex = [segue.identifier intValue];
    [[MixPanelUtil instance] track:@"menuBar_selected"];
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

- (IBAction)doUpdateData:(id)sender {
    [self disableUpdateBtn];
    if ([[[SettingsUtil alloc] init]  networkRechabilityMethod]) {
        [self enableUpdateBtn];
        return;
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.dataState == DataIsCurrent ||
           appDelegate.dataState == DataError ||
           appDelegate.dataState == DataStateUnknown ||
           appDelegate.dataState == DataDownloaded) {
            [appDelegate downloadProductInfo:NO onComplete:^{
            }];
        }
    }
}

- (IBAction)doLogout:(id)sender {
    if ([[[SettingsUtil alloc] init]  networkRechabilityMethod]) {
        return;
    }else{
        NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
        NSData *data = [NSData dataWithContentsOfFile:appFile];
        NSString *content = [data base64EncodedStringWithOptions:0];
        if(content != nil){
            [[API instance] post:@"update-lists"
                          params:@{@"listsData": content
                                   }
                      onComplete:^(NSDictionary *results) {
                          if(results == nil) {
                              [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
                          }
                          NSString *strResult = [results valueForKey:@"status"];
                          if ([strResult isEqualToString:@"success"]) {
                              NSFileManager *fileManager = [NSFileManager defaultManager];
                              NSError *error;
                              BOOL success = [fileManager removeItemAtPath:appFile error:&error];
                              if (success) {
                                  CLSNSLog(@"Success!!!");
                              }
                          }
                          else{
                              CLSNSLog(@"Failed");
                          }
                      }];
        }
    }
    self.userName =[User current].name;
    [[API instance]get:@"/logout" onComplete:^(NSDictionary *results) {
        if (results == nil) {
            [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
        }
        if ([[results valueForKey:@"status"]isEqualToString:@"success"]) {
            [[API instance]logout:^{
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"sign_in"] animated:NO completion:nil];
            }];
        }else if ([[results valueForKey:@"error"] isEqualToString:@"Session expired."]) {
            [[API instance]logout:^{
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"sign_in"] animated:NO completion:nil];
            }];
            return;
            }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[results valueForKey:@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.dataState = DataIsCurrent;
    appDelegate.activeList = nil;
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod:) name:@"Logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod1:) name:@"noCatalouge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod1:) name:@"Ignore" object:nil];
}

-(void)yourCustomMethod1:(NSNotification*)_notification
{
    [self enableUpdateBtn];
}

-(void)yourCustomMethod:(NSNotification*)_notification
{
    [[API instance] clearRegions:^{
    }];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate restoreList];
    NSDictionary *data = [DataReader read];
    int version = [[data valueForKey:@"version"] intValue];
    appDelegate.dataVersion = version;
    appDelegate.dataState = DataIsCurrent;
    [self dismissViewControllerAnimated:NO completion:nil];
    [ImageDownloadManager preload];
    RegionSelectViewController *vc = [[RegionSelectViewController alloc] init];
    [self enableUpdateBtn];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void) enableUpdateBtn{
    [self.btnUpdateData setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
    [self.btnUpdateData setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateSelected];
    self.btnUpdateData.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.btnUpdateData.layer.borderWidth = 1;
    [self.btnUpdateData setTitle:@"U P D A T E  A P P" forState:UIControlStateNormal];
    self.btnUpdateData.enabled = YES;
}

-(void) disableUpdateBtn{
    [self.btnUpdateData setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
    [self.btnUpdateData setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateSelected];
    [self.btnUpdateData setTitle:@"D O W N L O A D I N G . . ." forState:UIControlStateNormal];
    [self.btnUpdateData.layer setBorderColor:[ClarksColors gillsansGray].CGColor];
    self.btnUpdateData.layer.borderWidth = 1;
    self.btnUpdateData.enabled = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
