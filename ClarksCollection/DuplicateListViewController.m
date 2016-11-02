//
//  DuplicateListViewController.m
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DuplicateListViewController.h"
#import "ListViewController.h"
#import "AppDelegate.h"
#import "ClarksColors.h"
#import "ClarksUI.h"
#import "ClarksFonts.h"
#import "SWRevealViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface DuplicateListViewController ()

@end

@implementation DuplicateListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: viewDidLoad: Entry");
#endif
    [super viewDidLoad];
    self.view.backgroundColor = [ClarksColors clarkLightGrey] ;
    // Do any additional setup after loading the view.
    self.lblDuplicate.font = [ClarksFonts clarksSansProThin:40.0f];
    self.txtField.font =[ClarksFonts clarksSansProThin:20.0f];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 20)];
    [self.txtField setLeftViewMode:UITextFieldViewModeAlways];
    
    UIColor *color = [ClarksColors clarksMediumGrey];
    
    [self.txtField setLeftView:spacerView2];
    self.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name your list" attributes:@{NSForegroundColorAttributeName:color}];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.txtField.delegate = self;
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: viewDidLoad: Exit");
#endif
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Swipe Up");
        [self.navigationController popViewControllerAnimated:YES];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"Swipe Down");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) repositionButtons
{
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: repositionButtons: Entry");
#endif
    CGRect f = self.lblDuplicate.frame;
    [ClarksUI reposition:self.lblDuplicate x:f.origin.x y:76];
    
    f = self.txtField.frame;
    [ClarksUI reposition:self.txtField x:f.origin.x y:168];

    
    f = self.btnCreate.frame;
    [ClarksUI reposition:self.btnCreate x:f.origin.x y:244];
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: repositionButtons: Exit");
#endif
}

-(void) unRepositionButtons
{
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: unRepositionButtons: Entry");
#endif
    CGRect f = self.lblDuplicate.frame;
    [ClarksUI reposition:self.lblDuplicate x:f.origin.x y:76+135];
    
    f = self.txtField.frame;
    [ClarksUI reposition:self.txtField x:f.origin.x y:168+135];
    
    
    f = self.btnCreate.frame;
    [ClarksUI reposition:self.btnCreate x:f.origin.x y:244+135];
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: unRepositionButtons: Exit");
#endif
}

- (IBAction)doDuplicateLIst:(id)sender {
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: doDuplicateLIst: Entry");
#endif
    [self.view endEditing:YES];
    [self.txtField resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *listToBeDuplicated = [appDelegate.listofList objectAtIndex:self.index];
    BOOL uniqueListName = YES;
    
    NSString *newListName = [self.txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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
    [self goBack];
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: doDuplicateLIst: Exit");
#endif
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)doNothing:(id)sender {
    [self goBack];
}


- (IBAction)onValueChanged:(id)sender {
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: onValueChanged: Entry");
#endif
    NSString *newListName = [self.txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([newListName length] >0)
        self.btnCreate.enabled = YES;
    else
        self.btnCreate.enabled = NO;
#ifdef DEBUG
    CLSNSLog(@"DuplicateListViewController: onValueChanged: Exit");
#endif
}


- (IBAction)onEditingBegin:(id)sender {
    [self repositionButtons];
}

- (IBAction)onEditingEnded:(id)sender {
    [self unRepositionButtons];
}
@end
