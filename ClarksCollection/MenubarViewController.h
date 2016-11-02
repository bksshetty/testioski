//
//  MenubarViewController.h
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeTeritoryViewController.h"

@interface MenubarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblTestMode ;
@property (weak, nonatomic) IBOutlet UIButton *btnCatalogue;
@property (weak, nonatomic) IBOutlet UIButton *btnList;
@property (weak, nonatomic) IBOutlet UIButton *btnDiscoverCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnMarketing;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;
@property (weak, nonatomic) IBOutlet UILabel *lblDownloadInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateData;
@property (weak, nonatomic) IBOutlet UIButton *btnSettings;
@property NSString *userName; 
@property (weak, nonatomic) IBOutlet UILabel *userNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *regionNamelbl;

- (IBAction)doUpdateData:(id)sender;

- (IBAction)doLogout:(id)sender;
-(void) updateRegion;
@end
