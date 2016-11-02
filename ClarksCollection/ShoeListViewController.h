//
//  ShoeListViewController.h
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoeListDataSource.h"
#import "SearchView.h"
#import "TopBarView.h"
#import "FilterView.h"
#import "ItemList.h"
#import "SelectList.h"
#import "SaveList.h"
#import "TheNewListView.h"
#import "Filters.h"
#import "FilterDataSource.h"
#import "ListItemDataSource.h"
#import "ListItem.h"
#import "SWRevealViewController.h"

@interface ShoeListViewController : UIViewController<UITextFieldDelegate, SWRevealViewControllerDelegate>{
    UIView *collectionViewOverlay;
}
@property (weak, nonatomic) IBOutlet UILabel *listLbl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)didClickBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenList;
@property (weak, nonatomic) IBOutlet UIView *navBar;
- (IBAction)didClickMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet FilterDataSource *filterDS;
@property (strong, nonatomic) IBOutlet ShoeListDataSource *shoeListDS;
@property (strong, nonatomic) IBOutlet ListItemDataSource *listItemDS;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIView *noListView;

@property (weak, nonatomic) IBOutlet UITableView *filterTable;
@property (weak, nonatomic) IBOutlet UICollectionView *shoeListCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnApply;
@property (weak, nonatomic) IBOutlet UIButton *btnClearAll;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UILabel *lblSearch;
@property (weak, nonatomic) IBOutlet UILabel *lblActiveList;
@property (weak, nonatomic) IBOutlet UILabel *lblListName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductCount;

@property (weak, nonatomic) IBOutlet UIButton *btnListChange;
@property (weak, nonatomic) IBOutlet UIButton *viewListItem;
@property (weak, nonatomic) IBOutlet UITextField *txtNewList;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateANewList;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNewList;
@property (weak, nonatomic) IBOutlet UIButton *btnTopBarFilter;
@property (weak, nonatomic) IBOutlet UIButton *btnFilterViewFilter;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchViewSearch;
@property (weak, nonatomic) IBOutlet ItemList *itemListView;
@property (weak, nonatomic) IBOutlet SearchView *searchView;
@property (weak, nonatomic) IBOutlet TopBarView *topBarView;
@property (weak, nonatomic) IBOutlet FilterView *filterView;
@property (weak, nonatomic) IBOutlet SaveList *saveListView;
@property (weak, nonatomic) IBOutlet SelectList *selectListView;
@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl1;
@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl4;

@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl2;
@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl3;
@property (weak, nonatomic) IBOutlet UIButton *nnewListbtn1;
@property (weak, nonatomic) IBOutlet UIButton *nnewListbtn2;

@property (weak, nonatomic) IBOutlet UITableView *itemListTableView;

@property (weak, nonatomic) IBOutlet UILabel *lblYourList;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectAListTo;

@property (weak, nonatomic) IBOutlet UIButton *btnNewList;
@property (weak, nonatomic) IBOutlet UIButton *btnNavBarList;

@property (strong,nonatomic) Item *tmpItem;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseSaveList;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseNewListView;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseSelectList;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseItemList;
@property (weak, nonatomic) IBOutlet UILabel *activeListName;

@property (weak, nonatomic) IBOutlet UILabel *noListLbl1;
@property (weak, nonatomic) IBOutlet UILabel *noListlbl2;
@property (weak, nonatomic) IBOutlet UIButton *btnListClearAll;
- (IBAction)performSearch:(id)sender;
- (IBAction)onCloseFilter:(id)sender;
- (IBAction)onFilterClearAll:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *rightView;
- (IBAction)onFilterApply:(id)sender;
- (IBAction)onListClearAll:(id)sender;
- (IBAction)onPerformCreateNewList:(id)sender;
- (IBAction)onChangeList:(id)sender;

- (IBAction)closeSearchView:(id)sender;
- (IBAction)onFilter:(id)sender;
- (IBAction)openMenu:(id)sender;
- (IBAction)onListName:(id)sender;
- (IBAction)onShowCreateSelectNewList:(id)sender;
- (IBAction)onShowListSlideOut:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backFromListChange;

- (IBAction)onSearch:(id)sender;
- (IBAction)onOpenAList:(id)sender;
- (IBAction)onCollectionChange:(id)sender;
@property (weak, nonatomic) IBOutlet TheNewListView *theNewListView;
- (IBAction)onCreateNewList:(id)sender;
- (IBAction)onEditingBegin:(id)sender;
- (IBAction)onEditingEnded:(id)sender;
- (IBAction)closeLeftSlideOut:(id)sender;
- (IBAction)goBackToListInShoeList:(id)sender ;

-(void)setupCollections:(NSArray *)collections;

-(void) showListView;

-(void) addItemToActiveList:(Item *)theItem;
-(void) removeItemFromActiveList:(Item *)theItem;
-(BOOL) isActiveList;
-(void) performNoActiveList;
-(void) updateListTable;
-(void) updateListViewListNameLabel;
-(void) deleteCollectionViewChecks:(NSString *)itemName;
@end
