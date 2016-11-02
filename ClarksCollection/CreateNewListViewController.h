//
//  CreateNewListViewController.h
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewListViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblCreateNewList;
@property (weak, nonatomic) IBOutlet UITextField *txtListName;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;

- (IBAction)onEditingBegin:(id)sender;
- (IBAction)onEditingEnded:(id)sender;
- (IBAction)onCreateNewList:(id)sender;

- (IBAction)onValueChanged:(id)sender;
-(NSString *)readFile:(NSURL *)fileName ;
@end
