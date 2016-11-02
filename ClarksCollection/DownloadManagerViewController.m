//
//  DownloadManagerViewController.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "DownloadManagerViewController.h"
#import "AppDelegate.h"
#import "DownloadTableViewCell.h"
#import "ClarksUI.h"
#import "DownloadItem.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "AssortmentSelectViewController.h"
#import "MixPanelUtil.h"
#import "ClarksColors.h"
#import "SettingsUtil.h"
#import "SettingsScreenViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface DownloadManagerViewController (){
    NSArray *downloadItems;
    BOOL downloadingAll;
    BOOL viewLoaded;
    BOOL hideHelpView;
    BOOL allCompleted ;
    Reachability *internetReachableFoo;
    UIView *translucentView;
}
@end

@implementation DownloadManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.overlay.hidden = YES;
    self.menuButton.hidden = YES;
    [[MixPanelUtil instance] track:@"downloadManager"];
    downloadItems = [DownloadItem getAll];
    downloadingAll = YES;
    allCompleted = YES;
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusBarView.backgroundColor  =  [UIColor blackColor];
    [self.view addSubview:statusBarView];
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    for (DownloadItem *item in downloadItems) {
        if(item.status == NOT_STARTED || item.status == PAUSED || item.status == STOPPED) {
            downloadingAll = NO;
            break;
        }
        if(!(item.status == COMPLETED)) {
            allCompleted = NO;
        }
    }
    self.revealViewController.delegate = self;
    viewLoaded = YES;
    if (downloadingAll && allCompleted) {
        downloadingAll = NO;
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal] ;
        [self.downloadAllBtn setEnabled: NO ] ;
        self.downloadAllBtn.userInteractionEnabled = NO ;
        
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled: NO ];
        self.downloadAllBtn.userInteractionEnabled = NO ;
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal] ;
        [self.downloadAllBtn1 setEnabled: NO ] ;
        self.downloadAllBtn1.userInteractionEnabled = NO ;
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled: NO ];
        self.downloadAllBtn1.userInteractionEnabled = NO ;
        
    }else if (!downloadingAll) {
        
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;
        
    }else{
        
        [self.downloadAllBtn setTitle:@"S T O P  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"S T O P  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;

        [self.downloadAllBtn1 setTitle:@"S T O P  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;
        
        [self.downloadAllBtn1 setTitle:@"S T O P  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;

    }
    if (hideHelpView) {
        [self hideHelpView];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }else{
        [ClarksUI reposition:self.helpView x:self.helpView.frame.origin.x y:0];
        [ClarksUI reposition:self.downloadsTable x:self.downloadsTable.frame.origin.x y:0];
        self.revealViewController.panGestureRecognizer.enabled = NO;
        if (appDelegate.firstLaunch == 1) {
            UIStoryboard * storyboard = self.storyboard;
            AssortmentSelectViewController *destVC = [storyboard instantiateViewControllerWithIdentifier: @"assortment_select"];
            [self.navigationController pushViewController: destVC animated: NO];
        } else {
            appDelegate.firstLaunch = 1 ;
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstLaunch"];
        }
    }
    self.downloadsTable.delaysContentTouches = NO;
}

-(void) viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

- (IBAction)didClickBack:(id)sender {
    if (hideHelpView) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SettingsScreenViewController *settings = [storyboard instantiateViewControllerWithIdentifier:@"setting_screen"];
        UINavigationController *navigationController = self.navigationController;
        [navigationController pushViewController:settings animated:YES];
    }
}

- (IBAction)didDownloadAll1:(id)sender {
    [self doDownloadAll];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [downloadItems count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadTableViewCell *cell = [tableView
                        dequeueReusableCellWithIdentifier:@"download-cell"
                        forIndexPath:indexPath];
    [cell setItem:downloadItems[indexPath.row]];
    return cell;
}
- (void) hideHelpView{
    if (!viewLoaded) {
        hideHelpView = YES;
        return;
    }
    self.continueBtn.hidden = YES;
    self.menuButton.hidden = NO;
    self.helpView.hidden = YES;
    [ClarksUI reposition:self.downloadListView x:self.downloadListView.frame.origin.x y:0];
    [ClarksUI reposition:self.downloadsTable x:self.downloadsTable.frame.origin.x y:140];
}
- (IBAction)downloadAll:(id)sender {
    [self doDownloadAll];
}

-(void) doDownloadAll{
    DownloadTableViewCell *downLoadTableView = [DownloadTableViewCell alloc];
    [[[SettingsUtil alloc] init]  networkRechabilityMethod];
    for (DownloadItem *item in downloadItems) {
        if (downloadingAll) {
            [item cancel];
        }else{
            [item start];
            [item resume];
        }
        if(!(item.status == COMPLETED)) {
            allCompleted = NO;
        }else{
            allCompleted = YES ;
        }
    }
    if  (downloadingAll) {
        
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;

    }else{
        [self.downloadAllBtn setTitle:@"S T O P  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"S T O P  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn1 setTitle:@"S T O P  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;
        
        [self.downloadAllBtn1 setTitle:@"S T O P  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;
    }
    downloadingAll = !downloadingAll;
    [downLoadTableView refresh];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(refreshBtn)
                                   userInfo:nil repeats:YES
     ];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
    if ([segue.identifier isEqualToString:@"setting_screen"]) {
        SettingsScreenViewController *vc = (SettingsScreenViewController *) segue.destinationViewController;
    }
}

-(void) refreshBtn{
    [self.downloadsTable reloadData];
    for (DownloadItem *item in downloadItems) {
        if(item.status == NOT_STARTED || item.status == PAUSED || item.status == STOPPED) {
            downloadingAll = NO;
            break;
        }else{
            downloadingAll = YES;
        }
        if(!(item.status == COMPLETED)) {
            allCompleted = NO;
        }
    }
    if (downloadingAll && allCompleted) {
        downloadingAll = NO;
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal] ;
        [self.downloadAllBtn setEnabled: NO ] ;
        self.downloadAllBtn.userInteractionEnabled = NO ;
        
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled: NO ];
        self.downloadAllBtn.userInteractionEnabled = NO ;
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal] ;
        [self.downloadAllBtn1 setEnabled: NO ] ;
        self.downloadAllBtn1.userInteractionEnabled = NO ;
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled: NO ];
        self.downloadAllBtn1.userInteractionEnabled = NO ;
    }else if (!downloadingAll) {
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;
        
        [self.downloadAllBtn1 setTitle:@"D O W N L O A D  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;

    }else{
        [self.downloadAllBtn setTitle:@"S T O P  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"S T O P  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn1 setTitle:@"S T O P  A L L" forState:UIControlStateNormal];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal] ;
        [self.downloadAllBtn1 setEnabled:YES ];
        
        [self.downloadAllBtn1 setTitle:@"S T O P  A L L" forState:UIControlStateHighlighted];
        [self.downloadAllBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn1 setEnabled:YES ] ;
    }
    [self.downloadAllBtn1 setNeedsLayout];
    [self.downloadAllBtn1 layoutIfNeeded];
}

-(void) reload{
    [self.downloadsTable reloadData];
}

@end
