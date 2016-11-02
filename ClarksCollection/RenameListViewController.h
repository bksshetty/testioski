//
//  RenameListViewController.h
//  ClarksCollection
//
//  Created by Openly on 21/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lists.h"

@interface RenameListViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblRename;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIButton *btnRenamee;
@property (weak, nonatomic) IBOutlet UILabel *preLoadedEditText1;
@property (weak, nonatomic) IBOutlet UILabel *preLoadedEditText2;
@property int index;
@property Lists *list;
@property BOOL isDuplicate;


- (IBAction)doRenameLIst:(id)sender;
- (IBAction)doNothing:(id)sender;
- (IBAction)onValueChanged:(id)sender;

- (IBAction)onEditingEnded:(id)sender;
- (IBAction)onEditingBegin:(id)sender;

@end
