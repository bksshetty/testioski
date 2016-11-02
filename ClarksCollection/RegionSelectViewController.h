//
//  RegionSelectViewController.h
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region.h"

@interface RegionSelectViewController : UIViewController {
    NSArray *regions;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSelectAll;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;
@property (weak, nonatomic) IBOutlet UIButton *btnApply;

-(void)createLeftBtn : (NSString *)btnName i:(float *)cnt tag:(int)t ;
-(void)createRightBtn : (NSString *)btnName i:(float *)cnt tag:(int)t ;
-(void)createCenterBtn : (NSString *)btnName i:(float *)cnt tag:(int)t ;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property NSMutableArray* btnArray ;
@property int btnNum;
@property (weak, nonatomic) IBOutlet UILabel *lblHello;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectRegion;




@end
