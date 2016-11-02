//
//  AutoCompleteField.h
//  ClarksCollection
//
//  Created by Adarsh on 21/07/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoCompleteField : UITextField<UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *autocompleteTableView;
@property (nonatomic, retain) NSMutableArray *autocompleteUrls;
@property NSArray *userList;

@end
