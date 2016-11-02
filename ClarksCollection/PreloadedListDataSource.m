//
//  PreloadedListDataSource.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 29/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "PreloadedListDataSource.h"
#import "DataReader.h"
#import "Region.h"
#import "ClarksFonts.h"
#import "TableViewCellButton.h"
#import "AppDelegate.h"
#import "RenameListViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation PreloadedListDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *data = [DataReader read];
        NSArray *preloaded_list = [data valueForKey:@"preloaded_lists"] ;
        NSArray *regions = [preloaded_list valueForKey:@"regions"] ;
        for (NSDictionary *reg in regions) {
            if ([[reg valueForKey:@"name"]
                 isEqualToString: [Region getCurrent].name]) {
                self.list = [reg valueForKey:@"lists"];
            }
        }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"list-cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *lblListName = (UILabel *)[cell viewWithTag:120];
    UILabel *lblProductsCount = (UILabel *)[cell viewWithTag:121];
    for (UIView *v in [cell subviews]) {
        if ([v class] == [TableViewCellButton class]) {
            [v removeFromSuperview];
        }
    }
    NSString *listName = [self.list[indexPath.row] valueForKey:@"name"];
    NSString *count = [NSString stringWithFormat:@"(%lu products)", (unsigned long)[[self.list[indexPath.row] valueForKey:@"color_ids"] count] ];
    lblListName.attributedText =[ClarksFonts addSpaceBwLetters:[listName uppercaseString] alpha:2.0];
    lblProductsCount.attributedText = [ClarksFonts addSpaceBwLetters:[count uppercaseString] alpha:2.0];
    TableViewCellButton *renameButton = [self makeRenameButtonForCell:cell];
    renameButton.indexPath = indexPath;
    [cell addSubview:renameButton];
    TableViewCellButton *exportButton = [self makeExportButtonForCell:cell];
    exportButton.indexPath = indexPath;
    [cell addSubview:exportButton];
    return cell;
}

-(TableViewCellButton *)makeExportButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Export-Icon.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 816;
    CGFloat Y = 21;
    button.frame = CGRectMake(X, Y, width, height);
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(exportButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(TableViewCellButton *)makeRenameButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Edit-icon.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat width = (image.size.width/2) +2;
    CGFloat height = (image.size.height/2) ;
    CGFloat X = 756;
    CGFloat Y = 25;
    button.frame = CGRectMake(X, Y, width, height);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(renameButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(IBAction)exportButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionExport:(int)button.indexPath.row];
}

-(IBAction)renameButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.preloadedOrAssortmentEdit = TRUE ;
    [self.parentVC actionRename:(int)button.indexPath.row];
}
@end
