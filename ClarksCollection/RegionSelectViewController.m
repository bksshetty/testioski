//
//  RegionSelectViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "RegionSelectViewController.h"
#import "AssortmentSelectViewController.h"
#import "SWRevealViewController.h"
#import "ClarksColors.h"
#import "PListHelper.h"
#import "User.h"
#import "MenubarViewController.h"
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "DownloadManagerViewController.h"
#import "Region.h"
#import "DataReader.h"
#import "API.h"
#import "ClarksUI.h"
#import "ClarksFonts.h"
#import "ImageDownloadManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface RegionSelectViewController ()
{
    BOOL btnState[5];
    Region *region ;
}
@end

@implementation RegionSelectViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        regions = [Region loadAll];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        regions = [Region loadAll];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    NSArray *allregionArray = [[NSArray alloc] initWithObjects:
                               @"ASIA PACIFIC",
                               @"EUROPE",
                               @"AMERICAS",
                               @"GLOBAL",
                               nil];
    User *curUser = [User current];
    if([curUser.regions count] == 1) {
        NSString *regionString  = curUser.regions[0];
        int i =0;
        for (Region *reg in regions) {
            if ([reg.name isEqualToString:regionString]) {
                region = reg;
                [Region setCurrent:reg];
            }
        }
        for(NSString *str in allregionArray) {
            if([str isEqualToString:regionString])
                btnState[i] = true;
            else
                btnState[i]=false;
            i++;
        }
        [self gotoNextScreen];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:false];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear: (BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewDidDisappear:animated];
}

-(void)createLeftBtn : (NSString *)btnName i:(float *)cnt tag:(int)t{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = t ;
    [button addTarget:self
               action:@selector(onClickRegion:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setAttributedTitle:[self addSpaceBwLetters:btnName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor] ;
    button.frame = CGRectMake(334.0, 365+ *cnt, 165.0, 40.0) ;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:204 green:204 blue:204 alpha:1].CGColor;
    button.layer.cornerRadius = 3;
    [button setTitleColor:[UIColor colorWithRed:204 green:204 blue:150.0/256.0 alpha:1.0] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont fontWithName:@"GillSans" size:13.0]];
    [self.btnArray addObject:button];
    [self.view addSubview:button];
}

-(void)createRightBtn : (NSString *)btnName i:(float *)cnt tag:(int)t{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = t ;
    [button addTarget:self
               action:@selector(onClickRegion:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setAttributedTitle:[self addSpaceBwLetters:btnName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor] ;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [ClarksColors gillsansGray].CGColor;
    button.layer.cornerRadius = 3;
    [button setTitleColor:[UIColor colorWithRed:204 green:204 blue:204 alpha:1.0] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont fontWithName:@"GillSans" size:13.0]];
    button.frame = CGRectMake(524.0, 365+ *cnt, 165.0, 40.0) ;
    [self.btnArray addObject:button];
    [self.view addSubview:button];
}

-(NSMutableAttributedString *) addSpaceBwLetters:(NSString *) btnName{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:btnName];
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [btnName length])];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[ClarksColors gillsansGray]
                             range:NSMakeRange(0, [btnName length])];
    return attributedString;
}

-(NSMutableAttributedString *) addColorToLabel: (NSString *) str{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [str length])];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[ClarksColors gillsansBlue]
                             range:NSMakeRange(0, [str length])];
    return attributedString;
}

-(void)createCenterBtn : (NSString *)btnName i:(float *)cnt tag:(int)t{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = t ;
    [button addTarget:self
               action:@selector(onClickRegion:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setAttributedTitle:[self addSpaceBwLetters:btnName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:204.0 green:204.0 blue:204.0 alpha:1.0].CGColor;
    button.layer.cornerRadius = 3;
    [button setTitleColor:[UIColor colorWithRed:204 green:204 blue:204 alpha:1.0] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"GillSans" size:13.0]];
    button.frame = CGRectMake(429.0, 478, 165.0, 40.0) ;
    [self.btnArray addObject:button];
    [self.view addSubview:button];
}

-(void)onClickRegion : (UIButton *)btn{
    for (UIButton *btn in self.btnArray) {
        btn.layer.borderColor = [UIColor colorWithRed:204 green:204 blue:204 alpha:1].CGColor;
        [btn setAttributedTitle:[self addSpaceBwLetters:btn.titleLabel.text] forState:UIControlStateNormal];
    }
    btn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    [btn setAttributedTitle:[self addColorToLabel:btn.titleLabel.text] forState:UIControlStateNormal];
    
    for (Region *reg in regions) {
        NSString *regionName ;
        if ([btn.titleLabel.text isEqualToString:@"EUROPE"]) {
            regionName = @"EUROPE";
        }else{
            regionName = btn.titleLabel.text;
        }
        if ([reg.name isEqualToString:regionName]) {
            region = reg;
            break;
        }
    }
    [self selectDeselectBtn:btn btnNo:(int)btn.tag];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    float i = 0, b = 0  ;
    int cnt = 1, a= 0;
    int regionCnt = 0 ;
    self.btnArray = [[NSMutableArray alloc] init];
    User *curUser = [User current];
    self.userName.attributedText = [self addSpaceBwLetters:[curUser.name uppercaseString]];
    NSArray *allregionArray = [[NSArray alloc] initWithObjects:@"EUROPE",
                               @"ASIA PACIFIC",
                               @"AMERICAS",
                               @"GLOBAL",
                               nil];
    [self.navigationController setNavigationBarHidden:YES];
    for (NSString *reg in allregionArray) {
        if (regionCnt == 5) {
            break;
        }
        if (a%2 == 0){
            [self createLeftBtn:reg i:&i tag:cnt];
            i = i + 60;
            cnt++;
        }else{
            [self createRightBtn:reg i:&b tag:cnt];
            b = b + 60;
            cnt++;
        }
        a++ ;
        regionCnt++ ;
    }
    self.btnApply.layer.borderColor = [UIColor colorWithRed:204 green:204 blue:204 alpha:1].CGColor;
    self.btnApply.layer.borderWidth =1 ;
    self.btnApply.layer.cornerRadius = 3;
    if (regions == nil && [regions count]==0) {
            UIView *loader = [ClarksUI showLoader:self.view];
            [[API instance] getOnlyData:@"products" onComplete:^(NSData *data) {
                [loader removeFromSuperview];
                NSArray *paths = NSSearchPathForDirectoriesInDomains
                (NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *fileName = [NSString stringWithFormat:@"%@/data.json",
                                      documentsDirectory];
                [data writeToFile:fileName atomically:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Regions Available"
                                                                message:@"No regions are available. Please retry by logging out and logging in. If the problem persists please contact the adminstrator."
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Logout",nil];
                [alert show];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate tryUpdate];
            }];
    }
    UIButton *btn;
    if([curUser.regions count] == 1) {
        for( btn in _btnArray) {
            btn.hidden = YES;
        }
        self.btnReset.hidden = YES;
        self.btnSelectAll.hidden = YES;
        self.btnApply.hidden = YES;
        self.lblHello.hidden = YES;
        self.lblSelectRegion.hidden = YES;
        self.lblVersion.hidden = YES;
    }
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    self.lblVersion.text = [NSString stringWithFormat:@"Version: %@", version];
    User *curUsr = [User current];
    self.lblHello.text = [NSString stringWithFormat:@"Hello %@,", curUsr.name];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil userInfo:nil];
    }
}

- (IBAction)applySelected:(UIButton *)sender {
    [self gotoNextScreen];
}

-(void) gotoNextScreen{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.firstLaunch == 0) {
        [self performSegueWithIdentifier:@"download_manager" sender:self];
    } else {
        [self performSegueWithIdentifier:@"assortment_select" sender:self];
    }
}

-(void) selectDeselectBtn:(id)sender btnNo:(int)btnNo{
    // Perform action such as enabling Apply and
    BOOL isAnyBtnSelected = true;
    int i =0;
    while(i < 5){
        btnState[i] = false;
        i++;
    }
    self.btnNum = btnNo;
    btnState[btnNo-1] = true;
    if(isAnyBtnSelected){
        [self.btnApply setEnabled:YES];
        self.btnApply.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        [self.btnApply setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
    }
    else{
        [self.btnApply setEnabled:NO];
        self.btnApply.layer.borderColor = [UIColor colorWithRed:204 green:204 blue:204 alpha:1].CGColor;
        [self.btnApply setTitleColor:[UIColor colorWithRed:204 green:204 blue:204 alpha:1] forState:UIControlStateNormal];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{int i =0;
    NSMutableArray *regionArray =  [[NSMutableArray alloc] initWithCapacity:5];
    if([regions count]!= 0){
        while(i < [regions count]){
            if(btnState[i] == true){
                [regionArray addObject:regions[i]];
                break ;
            }
            i++;
        }
        if ([regionArray count]!= 0 && regionArray != nil) {
            NSLog(@"REGION: %@", region.name);
            [Region setCurrent: region];
            [[MixPanelUtil instance] track:@"region_selected" args:((Region *)regionArray[0]).name];
            [(MenubarViewController *)[self.revealViewController rearViewController] updateRegion];
        }
    }
}
@end