//
//  DownloadTableViewCell.h
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadItem.h"

@interface DownloadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property int counter ;

- (IBAction)startDownload:(id)sender;
- (IBAction)cancelDownload:(id)sender;

- (void) setItem:(DownloadItem *) item;
- (void) refresh;
@end
