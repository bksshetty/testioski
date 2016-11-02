//
//  ItemsInListViewController.h
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lists.h"
#import "SWRevealViewController.h"

@interface ItemsInListViewController : UIViewController<SWRevealViewControllerDelegate>
-(void)setListIndex:(int)index;
@property Lists *list;
@property int listItemIndex;
@property NSString *preloaded ;
@property BOOL readOnly;
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnGridView;
@property (weak, nonatomic) IBOutlet UILabel *lblListTitel;
@property int index;
@property (weak, nonatomic) IBOutlet UIButton *btnTableView;
@property (weak, nonatomic) IBOutlet UIButton *addMoreBtn;

// Export List View Properties...
@property (weak, nonatomic) IBOutlet UIView *exportView;
- (IBAction)didClickClose:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *exportListField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
- (IBAction)didEndEditing:(id)sender;
- (IBAction)didValueChange:(id)sender;
- (IBAction)didClickSend:(id)sender;

- (IBAction)didClickPlus:(id)sender;
- (IBAction)didClickExport:(id)sender;

-(void) updateProductLabels;
- (IBAction)onGridView:(id)sender;
- (IBAction)onTableView:(id)sender;

@end
