//
//  DownloadManagerViewController.h
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "SWRevealViewController.h"

@interface DownloadManagerViewController : ViewController <UITableViewDataSource, UITableViewDelegate,SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *downloadsTable;
@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UIView *downloadListView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadAllBtn1;

- (IBAction)downloadAll:(id)sender;
- (void) hideHelpView;

@property (weak, nonatomic) IBOutlet UIButton *downloadAllBtn;
 
@end
