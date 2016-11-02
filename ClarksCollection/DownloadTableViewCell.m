//
//  DownloadTableViewCell.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "DownloadTableViewCell.h"
#import "ClarksColors.h"
#import "DownloadItem.h"
#import "Reachability.h"
#import "ClarksFonts.h"
#import "DownloadManagerViewController.h"

@implementation DownloadTableViewCell{
    DownloadItem *theItem;
    int cnt;
    DownloadManagerViewController *dmvc;
}

- (void)awakeFromNib {
    [NSTimer
        scheduledTimerWithTimeInterval:1.0f
        target:self
        selector:@selector(refresh)
        userInfo:nil repeats:YES];
    for (UIView *currentView in self.subviews){
        if([currentView isKindOfClass:[UIScrollView class]]){
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
}

- (UIViewController *)getViewController
{
    id vc = [self nextResponder];
    while(![vc isKindOfClass:[UIViewController class]] && vc!=nil)
    {
        vc = [vc nextResponder];
    }
    return vc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)cancelDownload:(id)sender {
    [theItem cancel];
}

- (IBAction)startDownload:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection] ;
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    self.counter = 0 ;
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to download."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (theItem.status == PAUSED)
        [theItem resume];
    else
        [theItem start];
    [self refresh];
}

-(void) setItem:(DownloadItem *) item{
    theItem = item;
    [self refresh];
}

- (void) refresh{
    if (theItem != nil) {
        self.titleLabel.attributedText = [ClarksFonts addSpaceBwLetters:[theItem.title uppercaseString] alpha:2.0];
        self.productCountLabel.hidden = YES;
        [self.downloadBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        if (theItem.status == DOWLOADING || theItem.status == INIT_DOWNLOAD) {
            self.downloadBtn.hidden = YES;
            self.downloadProgress.hidden = NO;
            self.stopBtn.hidden = NO;
            self.downloadProgress.progress = [theItem completedPercentage];
        }else{
            self.downloadBtn.hidden = NO;
            self.downloadProgress.hidden = YES;
            self.stopBtn.hidden = YES;
            if (theItem.status == NOT_STARTED || theItem.status == STOPPED) {
                [self.downloadBtn setTitle:@"D O W N L O A D" forState:UIControlStateNormal];
                [self.downloadBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
                [self.downloadBtn setTitle:@"D O W N L O A D" forState:UIControlStateHighlighted];
                self.downloadBtn.enabled = YES;
            }else if (theItem.status == PAUSED){
                [self.downloadBtn setTitle:@"R E S U M E" forState:UIControlStateNormal];
                [self.downloadBtn setTitle:@"R E S U M E" forState:UIControlStateHighlighted];
                [self.downloadBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
                self.downloadBtn.enabled = YES;
            }else{
                self.downloadBtn.hidden = NO;
                self.downloadBtn.enabled = NO;
                [self.downloadBtn setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
                [self.downloadBtn setTitle:@"D O W N L O A D E D" forState:UIControlStateDisabled];
                [self.downloadBtn setTitle:@"D O W N L O A D E D" forState:UIControlStateNormal];
                [self.downloadBtn setTitle:@"D O W N L O A D E D" forState:UIControlStateHighlighted];
            }
        }
    }
}
@end
