//
//  MenuView.m
//  ClarksCollection
//
//  Created by Adarsh on 13/05/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "MenuView.h"
#import "ClarksColors.h"
#import "User.h"
#import "Region.h"
#import "ImageDownloader.h"
#import "AppDelegate.h"
#import "SettingsUtil.h"
#import "DataReader.h"
#import "RegionSelectViewController.h"
#import "ImageDownloadManager.h"
#import "API.h"


@implementation MenuView{
    UIButton *updateBtn ;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        User *curUser = [User current];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ImageDownloader *dl = [ImageDownloader instance];
        Region *reg = [Region getCurrent];
        NSArray *menuButtons = [[NSArray alloc] initWithObjects:@"CATALOUGE",@"LISTS & EXPORTS",@"COLLECTIONS",@"MARKETING",@"SETTINGS",@"HELP", nil];
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        statusBarView.backgroundColor  =  [UIColor blackColor];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(88, 50, 125, 44)];
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Clarks-logo.png"];
        UIImage *logoImg = [UIImage imageWithContentsOfFile:fullpath];
        logo.image = logoImg;
        
        UIView *seperaterView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 300, 1)];
        seperaterView.backgroundColor = [ClarksColors gillsansBorderGray];
        
        UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 142, 300, 15)];
        userName.font = [UIFont fontWithName:@"GillSans-Light" size:15];
        [userName setTextColor:[ClarksColors gillsansDarkGray]];
        userName.attributedText = [self addSpaceBwLetters:[curUser.name uppercaseString]];
        userName.textAlignment = NSTextAlignmentCenter;
        
        UILabel *regName = [[UILabel alloc] initWithFrame:CGRectMake(38, 169, 225, 11)];
        regName.font = [UIFont fontWithName:@"GillSans-Light" size:11];
        [regName setTextColor:[ClarksColors gillsansMediumGray]];
        regName.attributedText = [self addSpaceBwLetters:[NSString stringWithFormat:@"%@ SELECTION", [reg.name uppercaseString]]];
        regName.textAlignment = NSTextAlignmentCenter;
        
        UILabel *testMode = [[UILabel alloc] initWithFrame:CGRectMake(93, 95, 115, 21)];
        testMode.text = @"( T E S T  M O D E )";
        testMode.font = [UIFont fontWithName:@"GillSans" size:11];
        [testMode setTextColor:[ClarksColors gillsansBlue]];
        testMode.textAlignment = NSTextAlignmentCenter;
        
        if(API.instance.isTestMode){
            testMode.hidden = NO ;
        }else{
            testMode.hidden = YES ;
        }
        
        UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(119, 190, 62, 7)];
        [changeBtn setTitle:@"C H A N G E" forState:UIControlStateNormal];
        [changeBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        [changeBtn setFont:[UIFont fontWithName:@"GillSans" size:7]];
        
        double a = 220;
        for (NSString *str in menuButtons) {
            [self addSubview:[self createMenuButtons:str i:&a]];
            a = a+58;
        }
        
        updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(73, 610, 155, 40)];
        [updateBtn setTitle:@"U P D A T E   A P P" forState:UIControlStateNormal];
        [updateBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        [updateBtn setFont:[UIFont fontWithName:@"GillSans" size:12]];
        [updateBtn addTarget:self action:@selector(didClickUpdate:) forControlEvents:UIControlEventTouchUpInside];
        updateBtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        updateBtn.layer.borderWidth = 1;
        updateBtn.layer.cornerRadius = 3;
        
        UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(83, 675, 135, 40)];
        [logoutBtn setTitle:@"L O G  O U T" forState:UIControlStateNormal];
        [logoutBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        [logoutBtn setFont:[UIFont fontWithName:@"GillSans" size:12]];
        [logoutBtn addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
        logoutBtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        logoutBtn.layer.borderWidth = 1;
        logoutBtn.layer.cornerRadius = 3;
        
        UILabel *downloadLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 731, 300, 12)];
        downloadLbl.font = [UIFont fontWithName:@"GillSans" size:7];
        [downloadLbl setTextColor:[ClarksColors gillsansMediumGray]];
        NSString *str;
        if([dl totalItems] == 0)
            str = @"DOWLOADED ALL IMAGES";
        else
            str =[NSString stringWithFormat:@"DOWLOADED %d OF %d IMAGES", [dl downloadedItems], [dl totalItems] ];
        downloadLbl.attributedText = [self addSpaceBwLetters:str];
        downloadLbl.textAlignment = NSTextAlignmentCenter;
        
        UILabel *versionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 747, 300, 12)];
        versionLbl.font = [UIFont fontWithName:@"GillSans" size:7];
        [versionLbl setTextColor:[ClarksColors gillsansMediumGray]];
        NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        versionLbl.attributedText = [self addSpaceBwLetters:[[NSString stringWithFormat:@"Version: %@. Data version %d", version, appDelegate.dataVersion] uppercaseString]];
        versionLbl.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:testMode];
        [self addSubview:userName];
        [self addSubview:regName];
        [self addSubview:changeBtn];
        [self addSubview:seperaterView];
        [self addSubview:statusBarView];
        [self addSubview:logo];
        [self addSubview:updateBtn];
        [self addSubview:logoutBtn];
        [self addSubview:downloadLbl];
        [self addSubview:versionLbl];
        
        [self registerForNotifications];
    }
    return self;
}

-(UIButton *) createMenuButtons: (NSString *)str i:(double *)cnt{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,*cnt, 300, 50)];
    [button setAttributedTitle:[self addSpaceBwLetters:[str uppercaseString]] forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[ClarksColors gillsansDarkGray]];
    [button setFont:[UIFont fontWithName:@"GillSans-Light" size:15]];
    [button addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0)];
    return button;
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod:) name:@"Logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod1:) name:@"noCatalouge" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod1:) name:@"Ignore" object:nil];
}

-(void) doLogout{
    NSLog(@"Logged out!!!");
}

-(void)yourCustomMethod1:(NSNotification*)_notification
{
    [self enableUpdateBtn:updateBtn];
}

/*** Your custom method called on notification ***/
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
    RegionSelectViewController *vc = [[RegionSelectViewController alloc] init];
    [vc.navigationController pushViewController:vc.navigationController.topViewController animated:YES];
    //[self dismissViewControllerAnimated:NO completion:nil];
    [ImageDownloadManager preload];
    [self enableUpdateBtn:updateBtn];
    
}

-(NSMutableAttributedString *) addSpaceBwLetters:(NSString *) btnName{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:btnName];
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [btnName length])];
    return attributedString;
}

-(void) didClickUpdate: (UIButton *)btn{
    [self disableUpdateBtn:btn];
    
    if ([[[SettingsUtil alloc] init]  networkRechabilityMethod]) {
        [self enableUpdateBtn:btn];
        return;
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"Data State: %u", appDelegate.dataState);
        if(appDelegate.dataState == DataIsCurrent ||
           appDelegate.dataState == DataError ||
           appDelegate.dataState == DataStateUnknown ||
           appDelegate.dataState == DataDownloaded) {
            [appDelegate downloadProductInfo:NO onComplete:^{
            }];
        }
    }
}

-(void) disableUpdateBtn: (UIButton *)btn{
    [btn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
    [btn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateSelected];
    [btn setTitle:@"D O W N L O A D I N G . . ." forState:UIControlStateNormal];
    [btn.layer setBorderColor:[ClarksColors gillsansGray].CGColor];
    btn.layer.borderWidth = 1;
    btn.enabled = NO;
}

-(void) enableUpdateBtn: (UIButton *)btn{
    [btn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
    [btn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateSelected];
    btn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    btn.layer.borderWidth = 1;
    [btn setTitle:@"U P D A T E  A P P" forState:UIControlStateNormal];
    btn.enabled = YES;
}


@end
