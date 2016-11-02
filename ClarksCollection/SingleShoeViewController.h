//
//  SingleShoeViewController.h
//  ClarksCollection
//
//  Created by Openly on 15/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "ItemColor.h"
#import "SingleShoeDataSource.h"
#import "ManagedImage.h"
#import "SwipeView.h"
#import "SaveList.h"
#import "SelectList.h"
#import "TheNewListView.h"
#import "SWRevealViewController.h"
#import "ItemList.h"
#import "ListItemDataSource.h"
#import <AVFoundation/AVFoundation.h>

@interface SingleShoeViewController : UIViewController <SwipeViewDataSource, SwipeViewDelegate, UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate,SWRevealViewControllerDelegate>{
    Item *theItem;
}
@property (weak, nonatomic) IBOutlet UILabel *lblProductCount;
@property ItemColor* tmpColor;
-(void) setItem: (Item *) item withColorIndex:(int) withColorIndex;
@property (weak, nonatomic) IBOutlet UIView *plainView;
@property (weak, nonatomic) IBOutlet UILabel *shoeName;
@property (strong, nonatomic) IBOutlet UILabel *colorName;
@property int index;
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *productDescView;
@property (weak, nonatomic) IBOutlet UIView *productDetailView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet SingleShoeDataSource *colorDS;
@property (weak, nonatomic) IBOutlet SwipeView *swipeview;
@property CGFloat lastScale;

-(void) setColor: (int) idx;
-(BOOL) isActiveList;
-(void) addItemColorToActiveList:(ItemColor *)theColor;
-(void) removeItemColorFromActiveList:(ItemColor *)theColor;

@property int index1;
// All the slide out view
@property (weak, nonatomic) IBOutlet ItemList *itemListView;
@property (weak, nonatomic) IBOutlet SaveList *saveListView;
@property (weak, nonatomic) IBOutlet SelectList *selectListView;
@property (weak, nonatomic) IBOutlet TheNewListView *theNewListView;
@property (weak, nonatomic) IBOutlet UIView *shoeListCollectionView;
@property (weak, nonatomic) IBOutlet UIView *noListView;
@property (weak, nonatomic) IBOutlet UIButton *btnNewList;
@property (weak, nonatomic) IBOutlet UIScrollView *zoomScroll;
@property (weak, nonatomic) IBOutlet UIButton *tutBtn;

- (IBAction)didClickBack:(id)sender;

- (IBAction)didClickUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;

// List View
@property (weak, nonatomic) IBOutlet UIButton *btnListChange;
@property (weak, nonatomic) IBOutlet UILabel *lblListName;
- (IBAction)onListClearAll:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *viewListItem;
@property (weak, nonatomic) IBOutlet UITableView *itemListTableView;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (strong, nonatomic) IBOutlet ListItemDataSource *listItemDS;
- (IBAction)onChangeList:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *colorWaysLbl;
@property (weak, nonatomic) IBOutlet UILabel *techLbl;
@property (weak, nonatomic) IBOutlet UICollectionView *colorWaysView;

@property (weak, nonatomic) IBOutlet UICollectionView *techLogosGrid;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect;
- (IBAction)onClickTut:(id)sender;

// Save List
@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl1;
@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl4;

@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl2;
@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl3;
@property (weak, nonatomic) IBOutlet UIButton *nnewListbtn1;
@property (weak, nonatomic) IBOutlet UIButton *nnewListbtn2;
- (IBAction)onOpenAList:(id)sender;
- (IBAction)onCreateNewList:(id)sender;

@property NSString *isListView;
// New List
@property (weak, nonatomic) IBOutlet UILabel *lblCreateANewList;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNewList;
@property (weak, nonatomic) IBOutlet UITextField *txtNewList;
- (IBAction)onPerformCreateNewList:(id)sender;
- (IBAction)onEditingBeing:(id)sender;
- (IBAction)onEditingEnded:(id)sender;

//Select list
@property (weak, nonatomic) IBOutlet UILabel *lblSelectAListTo;
@property (weak, nonatomic) IBOutlet UIView *rightView;

//Close buttons
@property (weak, nonatomic) IBOutlet UIButton *btnCloseSaveList;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseItemList;
- (IBAction)closeLeftSlideOut:(id)sender;

@property UIImageView *imageView;

//Navigation
- (IBAction)onShowListSlideout:(id)sender;
- (IBAction)onShowCreateSelectNewList:(id)sender;

-(void) performNoActiveList;
-(void) updateListTable;
-(void) updateListViewListNameLabel;
-(void) showListView;
- (void)onTechClick:(UIButton *)btn;

@property (nonatomic) AVPlayer *avPlayer;
//@property (strong,nonatomic) AVPlayerViewController *avPlayerViewController;

@end
