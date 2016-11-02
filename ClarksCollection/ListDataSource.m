//
//  ListDataSource.m
//  ClarksCollection
//
//  Created by Openly on 04/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ListDataSource.h"
#import "AppDelegate.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "TableViewCellButton.h"

@implementation ListDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.listofList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"list-cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    int i = (int)indexPath.row;
    UILabel *lblListName = (UILabel *)[cell viewWithTag:120];
    UILabel *lblProductsCount = (UILabel *)[cell viewWithTag:121];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (i <[appDelegate.listofList count]) {
        Lists *theList = (Lists *)[appDelegate.listofList objectAtIndex:i];
        NSString *text = theList.listName;
        NSString *count = [NSString stringWithFormat:@"(%lu products)",(unsigned long)[theList.listOfItems count]];
        lblListName.attributedText = [ClarksFonts addSpaceBwLetters:[text uppercaseString] alpha:2.0];
        lblProductsCount.attributedText = [ClarksFonts addSpaceBwLetters:[count uppercaseString] alpha:2.0];
        TableViewCellButton *editButton = [self makeEditButtonForCell:cell];
        editButton.indexPath = indexPath;
        [cell addSubview:editButton];
        TableViewCellButton *renameButton = [self makeRenameButtonForCell:cell];
        renameButton.indexPath = indexPath;
        [cell addSubview:renameButton];
        TableViewCellButton *deleteButton = [self makeDeleteButtonForCell:cell];
        deleteButton.indexPath = indexPath;
        [cell addSubview:deleteButton];
        TableViewCellButton *exportButton = [self makeExportButtonForCell:cell];
        exportButton.indexPath = indexPath;
        [cell addSubview:exportButton];
        TableViewCellButton *duplicateButton = [self makeDuplicateButtonForCell:cell];
        duplicateButton.indexPath = indexPath;
        [cell addSubview:duplicateButton];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78.0;
}

-(TableViewCellButton *)makeEditButtonForCell:(UITableViewCell *)cell{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Edit-icon.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 561;
    CGFloat Y = 24;
    button.frame = CGRectMake(X, Y, width, height);
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(editButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(TableViewCellButton *)makeRenameButtonForCell:(UITableViewCell *)cell{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Rename-Icon.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 753;
    CGFloat Y = 25;
    button.frame = CGRectMake(X, Y, width, height);
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(renameButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(TableViewCellButton *)makeExportButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Export-Icon.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 611;
    CGFloat Y = 21;
    button.frame = CGRectMake(X, Y, width, height);
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(exportButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(TableViewCellButton *)makeDuplicateButtonForCell:(UITableViewCell *)cell{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Duplicate-Icon.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 675;
    CGFloat Y = 21;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self
               action:@selector(duplicateButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(TableViewCellButton *)makeDeleteButtonForCell:(UITableViewCell *)cell{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Delete-Icon.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat width = image.size.width/2+2;
    CGFloat height = image.size.height/2+2;
    CGFloat X = 817;
    CGFloat Y = 23;
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self
               action:@selector(deleteButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(IBAction)deleteButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionDelete:(int)button.indexPath.row];
}

-(IBAction)exportButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionExport:(int)button.indexPath.row];
}

-(IBAction)duplicateButtonClicked:(id)sender {    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionDuplicate:(int)button.indexPath.row];
}

-(IBAction)renameButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionRename:(int)button.indexPath.row];
}

-(IBAction)editButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionAddToList:(int)button.indexPath.row];
}
@end
