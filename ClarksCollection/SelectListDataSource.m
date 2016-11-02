//
//  SelectListDataSource.m
//  ClarksCollection
//
//  Created by Openly on 14/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "SelectListDataSource.h"
#import "ClarksFonts.h"
#import "AppDelegate.h"
#import "Lists.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation SelectListDataSource
{
    NSMutableArray *list;
}

- (instancetype)init
{
    if(self)
    {
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.listofList count];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"select-a-list";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    int i =(int)indexPath.row;
    UILabel *lblListName = (UILabel *)[cell viewWithTag:120];
    UILabel *lblProductsCount = (UILabel *)[cell viewWithTag:220];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *theList = (Lists *)[appDelegate.listofList objectAtIndex:i];
    NSAttributedString *text = [self addSpaceBwLetters:[theList.listName uppercaseString]];
    lblListName.attributedText = text;
    NSAttributedString *count = [self addSpaceBwLetters:[[NSString stringWithFormat:@"(%lu products)",(unsigned long)[theList.listOfItems count]] uppercaseString]];
    lblProductsCount.attributedText = count;
    [lblListName sizeToFit];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

-(NSMutableAttributedString *) addSpaceBwLetters:(NSString *) btnName{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:btnName];
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [btnName length])];
    return attributedString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *theListToBeAddedTo = (Lists *)[appDelegate.listofList objectAtIndex:indexPath.row];
    UIFont *font1 = [UIFont fontWithName:@"GillSans-Light" size:15];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: font1 forKey:NSFontAttributeName];
    float spacing = 2.0f;
    NSMutableAttributedString *aAttrString1 = [[NSMutableAttributedString alloc] initWithString:[theListToBeAddedTo.listName uppercaseString] attributes: arialDict];
    [aAttrString1 addAttribute:NSKernAttributeName
                         value:@(spacing)
                         range:NSMakeRange(0, [theListToBeAddedTo.listName length])];
    NSString *count = [NSString stringWithFormat:@" (%lu)",(unsigned long)[theListToBeAddedTo.listOfItems count]];
    UIFont *font2 = [UIFont fontWithName:@"GillSans-Light" size:10];
    NSDictionary *arialDict2 = [NSDictionary dictionaryWithObject: font2 forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString2 = [[NSMutableAttributedString alloc] initWithString:[count uppercaseString] attributes: arialDict2];
    [aAttrString2 addAttribute:NSKernAttributeName
                         value:@(spacing)
                         range:NSMakeRange(0, [count length])];
    self.parentVC.listLbl.hidden = NO;
    [aAttrString1 appendAttributedString:aAttrString2];
    self.parentVC.activeListName.attributedText  = aAttrString1;
    [self.parentVC.activeListName sizeToFit];
    if(self.parentVC.tmpItem !=nil)
    {
        [theListToBeAddedTo addItemToList:self.parentVC.tmpItem];
        [appDelegate saveList];
        self.parentVC.tmpItem = nil;
    }
    [appDelegate markListAsActive:theListToBeAddedTo];
    if(self.singleShoeParentVC.tmpColor !=nil){
        [self.singleShoeParentVC addItemColorToActiveList:self.singleShoeParentVC.tmpColor];
        [appDelegate saveList];
        self.singleShoeParentVC.tmpColor =nil;
    }
    if(self.parentVC.isViewLoaded && self.parentVC.view.window) {
        self.parentVC.selectListView.hidden = YES;
        [self.parentVC.shoeListCollectionView setUserInteractionEnabled:YES];
        [self.parentVC showListView];
    }
    if(self.singleShoeParentVC.isViewLoaded && self.singleShoeParentVC.view.window) {
        self.singleShoeParentVC.selectListView.hidden = YES;
        [self.singleShoeParentVC.shoeListCollectionView setUserInteractionEnabled:YES];
        [self.singleShoeParentVC showListView];
    }
    [appDelegate reconcileFilteredArrayWithActiveList];
}

@end
