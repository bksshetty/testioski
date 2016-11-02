//
//  ListItemDataSource.m
//  ClarksCollection
//
//  Created by Openly on 14/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ListItemDataSource.h"
#import "ClarksColors.h"
#import "ManagedImage.h"
#import "ListItem.h"
#import "AppDelegate.h"
#import "TableViewCellButton.h"
#import "ShoeListViewController.h"
#import "SingleShoeViewController.h"
#import "Item.h"
#import "ItemColor.h"
#import "ClarksFonts.h"
#import "itemInListCollectionViewDataSource.h"

@implementation ListItemDataSource{
    NSMutableArray* uiListOfCollections;
    NSMutableArray* uiItemCountForSection;
    NSMutableArray* uiListOfItems;
}

-(void)setUpEmptyData {
    [uiListOfCollections removeAllObjects];
    [uiItemCountForSection removeAllObjects];
    [uiListOfItems removeAllObjects];
}

-(void)setUpData {
    if(uiListOfCollections == nil)
        uiListOfCollections = [[NSMutableArray alloc] initWithCapacity:2];
    else
        [uiListOfCollections removeAllObjects];
    if(uiItemCountForSection == nil)
        uiItemCountForSection = [[NSMutableArray alloc] initWithCapacity:2];
    else
        [uiItemCountForSection removeAllObjects];
    if(uiListOfItems == nil)
        uiListOfItems = [[NSMutableArray alloc]  initWithCapacity:2];
    else
        [uiListOfItems removeAllObjects];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    ListItem *theItem;
    for (theItem in curList.listOfItems) {
        BOOL bCollectionAlreadyExists = NO;
        NSString *strCollectionName = theItem.collectionName;
        for (NSString *collectionName in uiListOfCollections) {
            if([strCollectionName isEqualToString:collectionName]){
                bCollectionAlreadyExists = YES;
                break;
            }
        }
        if(bCollectionAlreadyExists == NO) {
            [uiListOfCollections addObject:strCollectionName];
        }
    }
    for (NSString *uiCollectionName in uiListOfCollections) {
        int count = 0;
        for (theItem in curList.listOfItems) {
            if([uiCollectionName isEqualToString:theItem.collectionName]) {
                [uiListOfItems addObject:theItem];
                count++;
            }
        }
        [uiItemCountForSection addObject:[NSNumber numberWithInt:count]];
    }
    return;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int nSection =(int)[uiListOfCollections count];
    return nSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    int itemCountForCollection = [curList noOfItemsForCollecton:uiListOfCollections[section]];
    return itemCountForCollection;
}

-(TableViewCellButton *)makeDeleteButtonForCell:(UITableViewCell *)cell{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/gray-cross-icon.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 263;
    CGFloat Y = 45;
    button.frame = CGRectMake(X, Y, width, height);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(deleteButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(IBAction)deleteButtonClicked:(id)sender{
    TableViewCellButton *button = (TableViewCellButton *)sender;
    NSIndexPath *indexPath = button.indexPath;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    int i,t= 0;
    for(i = 0; i< indexPath.section; i++)
        t+=[[uiItemCountForSection objectAtIndex:i] intValue];
    t+=indexPath.row;
    ListItem *theDeletedItem = [uiListOfItems objectAtIndex:t];
    int currCountInSection =(int) [[uiItemCountForSection objectAtIndex:indexPath.section] integerValue];
    currCountInSection--;
    if(currCountInSection <=0){
        [uiListOfCollections removeObjectAtIndex:indexPath.section];
        [uiItemCountForSection removeObjectAtIndex:indexPath.section];
    }else {
        [uiItemCountForSection replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithInt:currCountInSection]];
    }
    [curList deleteItemColorFromList:theDeletedItem.itemNumber];
    [uiListOfItems removeObjectAtIndex:t];
    [appDelegate saveList];
    BOOL bAnyOtherColorInTheList = NO;
    for (ListItem *theListItem in curList.listOfItems) {
        if([theListItem.name isEqualToString:theDeletedItem.name]) {
            bAnyOtherColorInTheList = YES;
            break;
        }
    }
    if(self.shoeListViewController.isViewLoaded && self.shoeListViewController.view.window) {
        if(bAnyOtherColorInTheList == NO)
            [self.shoeListViewController deleteCollectionViewChecks: theDeletedItem.name];
        [self.shoeListViewController updateListViewListNameLabel];
        [self.shoeListViewController.listTable reloadData];
    }
    BOOL itemFound = NO;
    for(Item *theItem in appDelegate.filtereditemArray) {
        if([theItem.name isEqualToString:theDeletedItem.name]) {
            for(ItemColor *theColor in theItem.colors) {
                if([theColor.colorId isEqualToString:theDeletedItem.itemNumber]) {
                    theColor.isSelected = NO;
                    itemFound = YES;
                    break;
                }
            }
        }
        if(itemFound) {
            if(bAnyOtherColorInTheList == NO) {
                theItem.isSelected = NO;
            }
            break;
        }
    }
    if(self.singleShoeViewController.isViewLoaded && self.singleShoeViewController.view.window) {
        [self.singleShoeViewController updateListViewListNameLabel];
        [self.singleShoeViewController.listTable reloadData];
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"list_shoe_cell";
    int section = (int)indexPath.section;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [[cell viewWithTag:502] setHidden:YES];
    [[cell viewWithTag:503] setHidden:YES];
    int i,t= 0;
    for(i = 0; i< section; i++)
        t+=[[uiItemCountForSection objectAtIndex:i] intValue];
    t+=indexPath.row;
    UILabel *lblShoeName = (UILabel *)[cell viewWithTag:111];
    UILabel *lblShoeColor = (UILabel *)[cell viewWithTag:112];
    ManagedImage *shoeImage= (ManagedImage *)[cell viewWithTag:110];
    if(t >= [uiListOfItems count]) {
        return cell;
    }
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.jpg"];
    shoeImage.image = [UIImage imageWithContentsOfFile:fullpath];
    ListItem *listItem = (ListItem *)[uiListOfItems objectAtIndex:t];
    lblShoeName.attributedText = [ClarksFonts addSpaceBwLetters:[listItem.name uppercaseString] alpha:2.0];
    lblShoeColor.attributedText =  [ClarksFonts addSpaceBwLetters:[listItem.itemColor uppercaseString] alpha:2.0];    [shoeImage loadImage:listItem.imageSmall];
    itemInListCollectionViewDataSource *listCollectionViewDataSource = [[itemInListCollectionViewDataSource alloc] init];
    if (![listCollectionViewDataSource checkIfItemIsAvailable:(ListItem *)[uiListOfItems objectAtIndex:t]]) {
        [[cell viewWithTag:502] setHidden:NO];
        [[cell viewWithTag:503] setHidden:NO];
    }
    TableViewCellButton *deleteButton = [self makeDeleteButtonForCell:cell];
    deleteButton.indexPath = indexPath;
    [cell addSubview:deleteButton];
    return cell;
}

-(NSAttributedString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [ClarksFonts addSpaceBwLetters:[uiListOfCollections[section] uppercaseString] alpha:2.0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITextField *lbl = [[UITextField alloc] init];
    lbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    int itemCountForCollection = [curList noOfItemsForCollecton:uiListOfCollections[section]];
    NSString *headerLbl = [NSString stringWithFormat: @"%@ (%d)", uiListOfCollections[section], itemCountForCollection];
    lbl.attributedText = [ClarksFonts addSpaceBwLetters:[headerLbl uppercaseString] alpha:2.0];
    [lbl setTextColor:[ClarksColors gillsansMediumGray]];
    lbl.backgroundColor = [ClarksColors gillsansBorderGray];
    lbl.font =[UIFont fontWithName:@"GillSans-Light" size:10];
    lbl.userInteractionEnabled =NO;
    lbl.alpha = 1.0;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 22)];
    [lbl setLeftViewMode:UITextFieldViewModeAlways];
    [lbl setLeftView:spacerView];
    return lbl;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor colorWithRed:247.0f/255.0f
                                     green:246.0f/255.0f
                                      blue:244.0f/255.0f
                                     alpha:1.0f];
   UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
   [header.textLabel setTextColor:[UIColor colorWithRed:114.0f/255.0f
                                               green:114.0f/255.0f
                                                blue:114.0f/255.0f
                                                alpha:1.0f]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int i,t= 0;
    for(i = 0; i< indexPath.section; i++)
        t+=[[uiItemCountForSection objectAtIndex:i] intValue];
    t+=indexPath.row;
    ListItem *listItem = (ListItem *)[uiListOfItems objectAtIndex:t];
    Item *theItem = [listItem getItem];
    int colorIdx = [listItem getItemColorIdx:theItem];
    if (theItem == nil || colorIdx < 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot find Item"
                                                        message:@"The selected item cannot be found in the catalogue. Please make sure the item is available in current collection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        UIViewController *curCtrl;
        if(self.shoeListViewController != nil){
            curCtrl = self.shoeListViewController;
        }else{
            curCtrl = self.singleShoeViewController;
        }
        SingleShoeViewController *ctrl = [curCtrl.storyboard instantiateViewControllerWithIdentifier:@"single_shoe"];
        [ctrl setItem:theItem withColorIndex:[listItem getItemColorIdx:theItem]];
        [curCtrl.navigationController pushViewController:ctrl animated:YES];
    }
}
@end
