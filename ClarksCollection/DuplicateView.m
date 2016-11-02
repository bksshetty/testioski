//
//  DuplicateView.m
//  ClarksCollection
//
//  Created by Adarsh on 19/05/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "DuplicateView.h"
#import "ClarksColors.h"
#import "AppDelegate.h"
#import "ListViewController.h"
#import "Lists.h"
#import "ClarksUI.h"

@implementation DuplicateView{
    int index;
    UITextField *duplicateField;
    UITextField *duplicateField1;
    UIButton *btn;
    UIButton *btn1;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Adding a status bar with black background.
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
        statusBarView.backgroundColor  =  [UIColor blackColor];
        
        // Adding Top View.
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 80)];
        topView.backgroundColor = [UIColor whiteColor];
        
        // Adding Bottom View.
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 1024, 688)];
        bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        
        // Creating a duplicate Textfield
        duplicateField = [[UITextField alloc] initWithFrame:CGRectMake(80, 238, 679, 65)];
        duplicateField.backgroundColor = [UIColor whiteColor];
        duplicateField.layer.cornerRadius = 3;
        duplicateField.layer.borderWidth = 0;
        [duplicateField setTintColor:[ClarksColors gillsansDarkGray]];
        duplicateField.font = [UIFont fontWithName:@"GillSans-Light" size:17];
        duplicateField.placeholder = @"N A M E  Y O U R  D U P L I C A T E  L I S T . . .";
        
        // Adding inset to textfield.
        UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        [duplicateField setLeftViewMode:UITextFieldViewModeAlways];
        [duplicateField setLeftView:spacerView2];
        
        // Center align the textfield
        duplicateField.center = CGPointMake(CGRectGetWidth(bottomView.bounds)/2.0f, 238);
        [duplicateField addTarget:self action:@selector(didEditingBegin) forControlEvents:UIControlEventEditingDidBegin];
        [duplicateField addTarget:self action:@selector(didEditingChange) forControlEvents:UIControlEventEditingChanged];
        
        duplicateField1 = [[UITextField alloc] initWithFrame:CGRectMake(80, 238, 679, 65)];
        duplicateField1.backgroundColor = [UIColor whiteColor];
        duplicateField1.layer.cornerRadius = 3;
        duplicateField1.layer.borderWidth = 0;
        duplicateField1.font = [UIFont fontWithName:@"GillSans-Light" size:17];
        duplicateField1.placeholder = @"N A M E  Y O U R  D U P L I C A T E  L I S T . . .";
        
        [duplicateField1 setTintColor:[ClarksColors gillsansDarkGray]];
        
        // Adding inset to textfield.
        UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        [duplicateField1 setLeftViewMode:UITextFieldViewModeAlways];
        [duplicateField1 setLeftView:spacerView3];
        duplicateField1.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        
        // Center align the textfield
        duplicateField1.center = CGPointMake(CGRectGetWidth(bottomView.bounds)/2.0f, 138);
        [duplicateField1 addTarget:self action:@selector(didEditingBegin) forControlEvents:UIControlEventEditingDidBegin];
        duplicateField1.hidden = YES;
        [duplicateField1 addTarget:self action:@selector(didEditingChange) forControlEvents:UIControlEventEditingChanged];
        
        // Creating "CREATE" button
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 349, 118, 40)];
        [btn setTitle:@"C R E A T E" forState:UIControlStateNormal];
        [btn setTintColor:[ClarksColors gillsansGray]];
        btn.font = [UIFont fontWithName:@"GillSans" size:13];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        btn.layer.cornerRadius = 5;
        btn.center = CGPointMake(CGRectGetWidth(bottomView.bounds)/2.0f, 349);
        [btn addTarget:self action:@selector(didClickCreate:) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = NO;
        
        btn1= [[UIButton alloc] initWithFrame:CGRectMake(0, 349, 118, 40)];
        [btn1 setTitle:@"C R E A T E" forState:UIControlStateNormal];
        [btn1 setTintColor:[ClarksColors gillsansGray]];
        btn1.font = [UIFont fontWithName:@"GillSans" size:13];
        btn1.layer.borderWidth = 1;
        btn1.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        btn1.layer.cornerRadius = 5;
        btn1.center = CGPointMake(CGRectGetWidth(bottomView.bounds)/2.0f, 249);
        [btn1 addTarget:self action:@selector(didClickCreate:) forControlEvents:UIControlEventTouchUpInside];
        btn1.enabled = NO;
        btn1.hidden = YES;
        
        // Creating "CLOSE" button
        UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(882, 45, 106, 16)];
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/close-icon.png"];
        UIImage *closeImg = [UIImage imageWithContentsOfFile:fullpath];
        [btnClose setImage:closeImg forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(didClickClose) forControlEvents:UIControlEventTouchUpInside];
        
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeUp];
        
        // Adding close button to the topView
        [topView addSubview:btnClose];
        [topView addSubview: statusBarView];
        
        // Adding Duplicate Textfield.
        [bottomView addSubview:duplicateField];
        [bottomView addSubview:duplicateField1];
        [bottomView addSubview:btn];
        [bottomView addSubview:btn1];
        
        [self addSubview:topView];
        [self addSubview:bottomView];
    }
    return self;
}
-(void) didEditingBegin{
    [duplicateField1 performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    duplicateField.hidden = YES;
    duplicateField1.hidden = NO;
    btn1.hidden = NO;
    btn.hidden = YES;
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"duplicate" object:nil userInfo:nil];
        self.hidden = YES;
    }
}

-(void) didEditingChange{
    if ([duplicateField1.text isEqualToString:@""]) {
        [btn1 setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        [btn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        btn1.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        btn.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        btn.enabled = YES;
        btn1.enabled = YES;
    }else{
        [btn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        [btn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        btn1.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        btn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        btn.enabled = YES;
        btn1.enabled = YES;
    }
}

-(void) getIndex: (int)idx{
    index = idx;
}

-(void) didClickClose{
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duplicate" object:nil userInfo:nil];
    [duplicateField1 performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0];
}

-(void) didClickCreate:(UIButton *)sender{
    [duplicateField1 performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *listToBeDuplicated = [appDelegate.listofList objectAtIndex:index];
    BOOL uniqueListName = YES;
    NSString *newListName = [duplicateField1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for(Lists *theList in appDelegate.listofList) {
        if([theList.listName isEqualToString:newListName]) {
            uniqueListName = NO;
            break;
        }
    }
    if(uniqueListName == NO){
        NSString *message= [NSString stringWithFormat:@"%@ arleady exits",newListName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already exists"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    Lists *newList = [[Lists alloc]init];
    newList.listName = newListName;
    for(ListItem *theListItem in listToBeDuplicated.listOfItems){
        ListItem *newListItem = [[ListItem alloc]initWithListItem:theListItem];
        [newList addItemColorToList:newListItem withPositionCheck:NO];
    }
    [appDelegate.listofList addObject:newList];
    [appDelegate saveList];
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duplicate" object:nil userInfo:nil];
}
@end
