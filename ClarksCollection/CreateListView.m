
//
//  CreateListView.m
//  ClarksCollection
//
//  Created by Adarsh on 21/05/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "CreateListView.h"
#import "ClarksColors.h"
#import "Lists.h"
#import "AppDelegate.h"
#import "ClarksUI.h"

@implementation CreateListView{
    UITextField *field;
    UITextField *field1;
    UIButton *createBtn;
    UIButton *createBtn1;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Adding a status bar with black background.
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        statusBarView.backgroundColor  =  [UIColor blackColor];
        
        // Adding Top View.
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(724, 0, 300, 768)];
        rightView.backgroundColor = [UIColor whiteColor];
        
        // Adding Bottom View.
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 724, 768)];
        leftView.backgroundColor = [UIColor blackColor];
        leftView.alpha = 0.85;
        
        // Creating a label
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 300, 20)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.text = @"C R E A T E  A  N E W  L I S T";
        lbl.font = [UIFont fontWithName:@"GillSans-Light" size:20];
        [lbl setTextColor:[ClarksColors gillsansDarkGray]];
        
        // Adding a seperater view
        UIView *seperater = [[UIView alloc] initWithFrame:CGRectMake(0,120, 1024, 1)];
        seperater.backgroundColor = [ClarksColors gillsansBorderGray];
        
        field = [[UITextField alloc] initWithFrame:CGRectMake(10, 338 , 280, 65)];
        field.backgroundColor = [ClarksColors gillsansBorderGray];
        field.layer.borderWidth = 0 ;
        field.placeholder = @"N A M E  Y O U R  L I S T . . .";
        field.layer.cornerRadius = 3;
        field.font = [UIFont fontWithName:@"GillSans-Light" size:15];
        [field setTextColor:[ClarksColors gillsansDarkGray]];
        field.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        [field setLeftViewMode:UITextFieldViewModeAlways];
        [field setLeftView:spacerView2];
        [field addTarget:self action:@selector(didEditingBegin) forControlEvents:UIControlEventEditingDidBegin];
        field.delegate = self;
        
        field1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 178 , 280, 65)];
        field1.backgroundColor = [ClarksColors gillsansBorderGray];
        field1.layer.borderWidth = 0 ;
        field1.placeholder = @"N A M E  Y O U R  L I S T . . .";
        field1.layer.cornerRadius = 3;
        field1.font = [UIFont fontWithName:@"GillSans-Light" size:15];
        [field1 setTextColor:[ClarksColors gillsansDarkGray]];
        field1.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        [field1 setLeftViewMode:UITextFieldViewModeAlways];
        [field1 setLeftView:spacerView3];
        [field1 addTarget:self action:@selector(didEditingBegin) forControlEvents:UIControlEventEditingDidBegin];
        field1.delegate = self;
        field1.hidden = YES;
        [field1 addTarget:self action:@selector(didEditingEnd) forControlEvents:UIControlEventEditingDidEnd];
        [field1 addTarget:self action:@selector(didEditingChange) forControlEvents:UIControlEventEditingChanged];

        // Adding Create button to the right view
        createBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 428,120, 40)];
        [createBtn setTitle:@"C R E A T E" forState:UIControlStateNormal];
        createBtn.layer.borderWidth = 1;
        createBtn.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        createBtn.layer.cornerRadius = 3;
        createBtn.font = [UIFont fontWithName:@"GillSans" size:13];
        [createBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        createBtn.center = CGPointMake(CGRectGetWidth(rightView.bounds)/2.0f, 450);
        createBtn.enabled = NO;
        [createBtn addTarget:self action:@selector(didClickCreate) forControlEvents:UIControlEventTouchUpInside];
        
        createBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 328,120, 40)];
        [createBtn1 setTitle:@"C R E A T E" forState:UIControlStateNormal];
        createBtn1.layer.borderWidth = 1;
        createBtn1.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        createBtn1.layer.cornerRadius = 3;
        createBtn1.font = [UIFont fontWithName:@"GillSans" size:13];
        [createBtn1 setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        createBtn1.center = CGPointMake(CGRectGetWidth(rightView.bounds)/2.0f, 278);
        [createBtn1 addTarget:self action:@selector(didClickCreate) forControlEvents:UIControlEventTouchUpInside];
        createBtn1.hidden = YES;
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
        
        // Adding seperater in right view
        [rightView addSubview:seperater];
        [rightView addSubview:lbl];
        [rightView addSubview:field];
        [rightView addSubview:field1];
        [rightView addSubview:createBtn];
        [rightView addSubview:createBtn1];
        [rightView addSubview:statusBarView];
        
        [self addSubview:rightView];
        [self addSubview:leftView];
    }
    return self;
}

-(void) didEditingBegin{
    field1.hidden = NO;
    [field1 performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    field.hidden = YES;
    createBtn1.hidden = NO;
    createBtn.hidden = YES;
}

-(void) didEditingEnd{
    field1.hidden = YES;
    field.hidden = NO;
    createBtn1.hidden = YES;
    createBtn.hidden = NO;
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        self.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"create" object:nil userInfo:nil];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        self.hidden = YES;
    }
}

-(void) didEditingChange{
    if (![field1.text isEqualToString:@""]) {
        [createBtn1 setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        [createBtn setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        createBtn1.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        createBtn.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        createBtn.enabled = YES;
        createBtn1.enabled = YES;
    }else{
        [createBtn1 setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        [createBtn setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        createBtn1.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        createBtn.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        createBtn.enabled = NO;
        createBtn1.enabled = NO;
    }
}

-(void) didClickCreate{
    [field1 performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0];
    field1.autocapitalizationType = UITextAutocapitalizationTypeWords  ;
    NSString *newListName = [field1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCreateView = @"NO";
    BOOL uniqueListName = YES;
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
    Lists *newList = [[Lists alloc]init];
    newList.listName = newListName;
    [appDelegate.listofList addObject:newList];
    [appDelegate saveList];
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"create" object:nil userInfo:nil];
}
@end
