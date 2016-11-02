//
//  ExportListViewController.h
//  ClarksCollection
//
//  Created by Openly on 13/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Lists;

@interface ExportListViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UITextField *txtEMail;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)onListSend:(id)sender;
- (IBAction)doNothing:(id)sender;
- (IBAction)onValueChanged:(id)sender;
- (IBAction)onEditingBegin:(id)sender;
- (IBAction)onEditingEnded:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property int index;
@property Lists *list;
@end
