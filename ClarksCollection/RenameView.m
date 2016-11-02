//
//  RenameView.m
//  ClarksCollection
//
//  Created by Adarsh on 27/05/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "RenameView.h"
#import "ClarksColors.h"
#import "AppDelegate.h"

@implementation RenameView{
    UITextField *renameField;
    UITextField *renameField1;
    UIButton *btn;
    UIButton *btn1;
    int index;
}

- (id)initWithFrame:(CGRect)frame{
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
        renameField = [[UITextField alloc] initWithFrame:CGRectMake(80, 238, 679, 65)];
        renameField.backgroundColor = [UIColor whiteColor];
        renameField.layer.cornerRadius = 3;
        renameField.layer.borderWidth = 0;
        renameField.font = [UIFont fontWithName:@"GillSans-Light" size:17];
        renameField.placeholder = @"R E N A M E  Y O U R  L I S T";
        [renameField setTintColor:[ClarksColors gillsansDarkGray]];
        
        // Adding inset to textfield.
        UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        [renameField setLeftViewMode:UITextFieldViewModeAlways];
        [renameField setLeftView:spacerView2];
        
        // Center align the textfield
        renameField.center = CGPointMake(CGRectGetWidth(bottomView.bounds)/2.0f, 238);
        [renameField addTarget:self action:@selector(didEditingBegin) forControlEvents:UIControlEventEditingDidBegin];
        [renameField addTarget:self action:@selector(didEditingChange) forControlEvents:UIControlEventEditingChanged];
        
        renameField1 = [[UITextField alloc] initWithFrame:CGRectMake(80, 238, 679, 65)];
        renameField1.backgroundColor = [UIColor whiteColor];
        renameField1.layer.cornerRadius = 3;
        renameField1.layer.borderWidth = 0;
        renameField1.font = [UIFont fontWithName:@"GillSans-Light" size:17];
        renameField1.placeholder = @"R E N A M E  Y O U R  L I S T";
        [renameField1 setTintColor:[ClarksColors gillsansDarkGray]];
        
        // Adding inset to textfield.
        UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        [renameField1 setLeftViewMode:UITextFieldViewModeAlways];
        [renameField1 setLeftView:spacerView3];
        renameField1.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.preloadedOrAssortmentEdit) {
            renameField.font = [UIFont fontWithName:@"GillSans-Light" size:12];
            renameField.placeholder = [@"T o  E d i t  t h i s  l i s t,  y o u  h a v e  t o  d u p l i c a t e  i t  t o  y o u r  l i s t s  s e c t i o n." uppercaseString];
            renameField1.font = [UIFont fontWithName:@"GillSans-Light" size:12];
            renameField1.placeholder = [@"T o  E d i t  t h i s  l i s t,  y o u  h a v e  t o  d u p l i c a t e  i t  t o  y o u r  l i s t s  s e c t i o n." uppercaseString];
        }
        
        // Center align the textfield
        renameField1.center = CGPointMake(CGRectGetWidth(bottomView.bounds)/2.0f, 138);
        [renameField1 addTarget:self action:@selector(didEditingBegin) forControlEvents:UIControlEventEditingDidBegin];
        renameField1.hidden = YES;
        [renameField1 addTarget:self action:@selector(didEditingChange) forControlEvents:UIControlEventEditingChanged];
        
        // Creating "CREATE" button
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 349, 118, 40)];
        [btn setTitle:@"S A V E" forState:UIControlStateNormal];
        [btn setTintColor:[ClarksColors gillsansGray]];
        btn.font = [UIFont fontWithName:@"GillSans" size:13];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        btn.layer.cornerRadius = 5;
        btn.center = CGPointMake(CGRectGetWidth(bottomView.bounds)/2.0f, 349);
        [btn addTarget:self action:@selector(didClickCreate:) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = NO;
        // NSLog(@"Hello World");
        
        btn1= [[UIButton alloc] initWithFrame:CGRectMake(0, 349, 118, 40)];
        [btn1 setTitle:@"S A V E" forState:UIControlStateNormal];
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
        //        [topView addSubview:topView1];
        
        // Adding Duplicate Textfield.
        [bottomView addSubview:renameField];
        [bottomView addSubview:renameField1];
        [bottomView addSubview:btn];
        [bottomView addSubview:btn1];
    
        [self addSubview:topView];
        [self addSubview:bottomView];
    }
    return self;
}

-(void) didEditingBegin{
    [renameField1 performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    renameField.hidden = YES;
    renameField1.hidden = NO;
    btn1.hidden = NO;
    btn.hidden = YES;
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rename" object:nil userInfo:nil];
        [renameField1 performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0];
        self.hidden = YES;
    }
}

-(void) didEditingChange{
    if ([renameField1.text isEqualToString:@""]) {
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

-(void) didClickCreate:(UIButton *)sender{
    [renameField1 performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.preloadedOrAssortmentEdit) {
        [appDelegate.listofList addObject:self.list];
        index = (int)[appDelegate.listofList count] - 1;
    }
    Lists *listToBeRenamed = [appDelegate.listofList objectAtIndex:index];
    BOOL uniqueListName = YES;
    NSString *newListName = [renameField1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for(Lists *theList in appDelegate.listofList) {
        if([theList.listName isEqualToString:newListName]) {
            uniqueListName = NO;
            break;
        }
    }
    if(uniqueListName == NO){
        NSString *message= [NSString stringWithFormat:@"%@ already exits",newListName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already exists"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    listToBeRenamed.listName = newListName;
    [appDelegate saveList];
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rename" object:nil userInfo:nil];
}

-(void) getIndex: (int)idx{
    index = idx;
}

-(void) didClickClose{
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rename" object:nil userInfo:nil];
    [renameField1 performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0];
}

@end
