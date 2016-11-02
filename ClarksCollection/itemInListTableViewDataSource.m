//
//  itemInListTableViewDataSource.m
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "itemInListTableViewDataSource.h"
#import "AppDelegate.h"
#import "ManagedImage.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "TableViewCellButton.h"
#import "ListViewController.h"
#import "itemInListCollectionViewDataSource.h"

@implementation itemInListTableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.parentVC.list.listOfItems count];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"item-in-list-table";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [[cell viewWithTag:500] setHidden:YES];
    ListItem *theListItem = self.parentVC.list.listOfItems[indexPath.row];
    UILabel *lblName = (UILabel *)[cell viewWithTag:120];
    lblName.attributedText = [ClarksFonts addSpaceBwLetters:[theListItem.name  uppercaseString] alpha:2.0];
    ManagedImage *shoeImage= (ManagedImage *)[cell viewWithTag:122];
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.jpg"];
    shoeImage.image = [UIImage imageWithContentsOfFile:fullpath];
    [shoeImage loadImage: theListItem.imageSmall];
    shoeImage.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *articleCode = (UILabel *)[cell viewWithTag:123];
    UILabel *colorName1 = (UILabel *)[cell viewWithTag:124];
    UILabel *colorName = (UILabel *)[cell viewWithTag:125];
    UILabel *sizeAndFit = (UILabel *)[cell viewWithTag:126];
    articleCode.attributedText = [ClarksFonts addSpaceBwLetters:[theListItem.itemNumber uppercaseString] alpha:2.0];
    colorName1.attributedText = [ClarksFonts addSpaceBwLetters:[theListItem.itemColor uppercaseString] alpha:2.0];
    colorName.attributedText = [ClarksFonts addSpaceBwLetters:[theListItem.itemColor uppercaseString] alpha:2.0];
    sizeAndFit.attributedText = [ClarksFonts addSpaceBwLetters:[[NSString stringWithFormat:@"%@/%@", theListItem.size,theListItem.fit] uppercaseString] alpha:2.0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    itemInListCollectionViewDataSource *listCollectionViewDataSource = [[itemInListCollectionViewDataSource alloc] init];
    if (![listCollectionViewDataSource checkIfItemIsAvailable:theListItem]) {
        [[cell viewWithTag:500] setHidden:NO];
    }
    if (!self.parentVC.readOnly) {
        TableViewCellButton *deleteButton = [self makeDeleteButtonForCell:cell];
        deleteButton.indexPath = indexPath;
        [cell addSubview:deleteButton];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.parentVC.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.parentVC.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.parentVC.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.parentVC.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(TableViewCellButton *)makeDeleteButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/blue-btn-resized.png"];
    image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat X = 912;
    CGFloat Y = 67;
    button.frame = CGRectMake(X, Y, 17, 17);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(deleteItemFromList:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(IBAction)deleteItemFromList:(id)sender
{
    TableViewCellButton *button = (TableViewCellButton *)sender;
    int indexPath = (int)button.indexPath.row;
    [self.parentVC.list.listOfItems removeObjectAtIndex:indexPath];
    [self.parentVC.tableView reloadData];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveList];
}
@end
