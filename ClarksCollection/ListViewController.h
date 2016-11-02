//
//  ListViewController.h
//  ClarksCollection
//
//  Created by Openly on 09/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@class PreloadedListDataSource;
@class ListDataSource;
@class AssortmentPlanningListDataSource;
@class Lists;

@interface ListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *staticLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property int savedListIndex;
-(void)actionExport:(int) listIndex;
-(void)actionDelete:(int) listIndex;
-(void)actionDuplicate:(int) listIndex;
@property (strong, nonatomic) IBOutlet PreloadedListDataSource *preloadedListDS;
-(void)actionRename:(int) listIndex;
-(void)actionAddToList:(int) listIndex ;

// Export View properties
@property (weak, nonatomic) IBOutlet UIView *exportView;
@property (weak, nonatomic) IBOutlet UITextField *exportListField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)didClickSend:(id)sender;
- (IBAction)didClickClose:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
- (IBAction)didClickPlus:(id)sender;
@property Lists *list;
@property int index;
- (IBAction)onEditingBegin:(id)sender;
- (IBAction)onEditingEnd:(id)sender;
- (IBAction)onEditingChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *yourListsBtn;
@property (weak, nonatomic) IBOutlet UIButton *preloadedListsBtn;
@property (weak, nonatomic) IBOutlet UIButton *assortmentPlanListBtn;
- (IBAction)selectYourList:(id)sender;
- (IBAction)selectPreloadedList:(id)sender;
- (IBAction)selectAssPlanList:(id)sender;
@property (strong, nonatomic) IBOutlet ListDataSource *yourListDS;
@property (strong, nonatomic) IBOutlet AssortmentPlanningListDataSource *assortmentPlanningListDS;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *maybeLaterbtn;
- (IBAction)didClickLater:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIView *editContainerView;


@end
