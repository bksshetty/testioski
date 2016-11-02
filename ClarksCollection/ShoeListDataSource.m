//
//  ShoeListDataSource.m
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ShoeListDataSource.h"
#import "CollectionViewCellButton.h"
#import "Collection.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "ManagedImage.h"
#import "ShoeListViewController.h"
#import "AppDelegate.h"

@implementation ShoeListDataSource {
    NSArray *collections;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.filtereditemArray count];
}

-(void) setupCollections:(NSArray *)collectionsArray{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    collections = collectionsArray;
    NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithCapacity:collectionsArray.count];
    BOOL bFirstTime = true;
    NSString *tempTitleLable;
    for (id collectionObject in collectionsArray) {
        Collection *collection = (Collection*)collectionObject;
        if(bFirstTime){
            tempTitleLable = collection.name;
            bFirstTime = false;
        }else{
            tempTitleLable = [NSString stringWithFormat:@"%@, %@",tempTitleLable,collection.name];
        }
        for (id itemObject in collection.items) {
            Item *theItem = (Item *)itemObject;
            [theItem markItemAsDeselected];
            theItem.collectionName = collection.name;
            [tmpArray addObject:theItem];
        }
    }
    self.titleLable = tempTitleLable;
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:tmpArray];
    self.itemArray = orderedSet.array;
    appDelegate.filtereditemArray = [[NSMutableArray alloc]initWithCapacity:self.itemArray.count];
    for(Item *item in self.itemArray)
        [appDelegate.filtereditemArray addObject:item];
    [appDelegate reconcileFilteredArrayWithActiveList];
    return;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shoe_list_cell" forIndexPath:indexPath];
    for (UIView *oldViews in cell.subviews){
        if([oldViews isKindOfClass:[CollectionViewCellButton class]])
            [oldViews removeFromSuperview];
    }
    Item *theItem = appDelegate.filtereditemArray[indexPath.row];
    UILabel *lbl = (UILabel *)[cell viewWithTag:103];
    ManagedImage *shoeImage= (ManagedImage *)[cell viewWithTag:102];
    if (theItem.name != nil)
        lbl.attributedText = [ClarksFonts addSpaceBwLetters:[theItem.name uppercaseString] alpha:2.0];
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.png"];
    shoeImage.image = [UIImage imageWithContentsOfFile:fullpath];
    [shoeImage loadImage: theItem.image];
    BOOL bIsSelected = theItem.isSelected;
    CollectionViewCellButton *addButton = [self makeAddButtonForCell:cell withState:bIsSelected];
    addButton.indexPath = (int)indexPath.row;
    [cell addSubview:addButton];
    [[cell viewWithTag:100] setHidden: !theItem.has360];
    UILabel *lblCollection = (UILabel *)[cell viewWithTag:104];
    lblCollection.attributedText = [ClarksFonts addSpaceBwLetters:[theItem.collectionName uppercaseString] alpha:2.0];
    NSString *tierString ;
    if (theItem.tier != nil) {
        tierString = [theItem.tier componentsJoinedByString: @", "] ;
        UILabel *lblTier = (UILabel *)[cell viewWithTag:301];
        [lblTier setFont:[ClarksFonts clarksSansProRegular:9.0f]] ;
        [lblTier setTextColor:[ClarksColors clarksMediumGrey]];
        lblTier.text = [tierString uppercaseString] ;
        lblTier.hidden = YES;
    }
    return cell;
}

-(void) setupFilterArray {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.filtereditemArray removeAllObjects];
    if([self.searchTerm length] == 0){
        [self resetFilterArrayFromFilterList ];
    }else{
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", self.searchTerm];
        appDelegate.filtereditemArray = [[self.itemArray filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    }
    [appDelegate reconcileFilteredArrayWithActiveList];
}

-(void) resetFilterArrayFromFilterList {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.filtereditemArray removeAllObjects];
    for(Item *item in self.itemArray)
        [appDelegate.filtereditemArray addObject:item];
    [appDelegate reconcileFilteredArrayWithActiveList];
}

-(void) setupFilterArrayFromFilterList {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.filtereditemArray removeAllObjects];
    NSString *strFilterString;
    NSMutableArray *filterArr = [[NSMutableArray alloc]init];
    for(NSString *key in [self.filters allKeys]){
        [filterArr addObject: [[self.filters valueForKey:key] componentsJoinedByString: @") OR ("]];
    }
    if([filterArr count] > 0){
        strFilterString = [NSString stringWithFormat:@"((%@))", [filterArr componentsJoinedByString:@")) AND (("]];
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:strFilterString];
        appDelegate.filtereditemArray = [[self.itemArray filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    }else{
        for(Item *item in self.itemArray)
            [appDelegate.filtereditemArray addObject:item];
    }
    [appDelegate reconcileFilteredArrayWithActiveList];
}

-(CollectionViewCellButton *)makeAddButtonForCell:(UICollectionViewCell *)cell withState:(BOOL)withState{
    CollectionViewCellButton *button = [CollectionViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image;
    float borderWidth;
    if(withState){
        borderWidth = 1.0f;
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/blue-btn-resized.png"];
        image = [UIImage imageWithContentsOfFile:fullpath];
    }else{
        borderWidth=0.0f;
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/plus-btn-resized.png"];
        image = [UIImage imageWithContentsOfFile:fullpath];
    }
    button.cell.layer.borderWidth=borderWidth;
    button.cell.layer.borderColor=[ClarksColors gillsansBlue].CGColor;
    button.frame = CGRectMake(2, 290,250, 45);
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 116, 22, 116);
    [button addTarget:self
               action:@selector(addToList:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(IBAction)addToList:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CollectionViewCellButton *button = (CollectionViewCellButton *)sender;
    Item *theItem = appDelegate.filtereditemArray[button.indexPath];
    BOOL curState = theItem.isSelected;
    float borderWidth;
    UIImage *image;
    if ([self.parentVC isActiveList] == NO) {
        self.parentVC.tmpItem = theItem;
        [self.parentVC performNoActiveList];
        return;
    }
    if(curState == NO){
        borderWidth = 1.0f;
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/blue-btn-resized.png"];
        image = [UIImage imageWithContentsOfFile:fullpath];
        [theItem markItemAsSelected];
        [self.parentVC addItemToActiveList:theItem];
    }else{
        borderWidth=0.0f;
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/plus-btn-resized.png"];
        image = [UIImage imageWithContentsOfFile:fullpath];
        [theItem markItemAsDeselected];
        [self.parentVC removeItemFromActiveList:theItem];
    }
    button.cell.layer.borderWidth=borderWidth;
    button.cell.layer.borderColor=[ClarksColors gillsansBlue].CGColor;
    button.frame = CGRectMake(2, 290,250, 45);
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 116, 22, 116);
    button.frame = CGRectMake(2, 290,250, 45);
    [self.parentVC updateListTable];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.current = appDelegate.filtereditemArray[indexPath.row];
}
@end