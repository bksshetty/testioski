//
//  AppDelegate.h
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lists.h"


typedef enum {
    DataStateUnknown = 0,
    DataIsCurrent =1,
    VersionCheck = 2,
    DataIsDownloading =3,
    DataDownloaded = 4,
    DataError = 5
    
}DataState;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) Lists* activeList;
@property (strong,nonatomic) NSIndexPath *selectedTerritory;
@property (strong,nonatomic) NSMutableArray* listofList;
@property (strong,nonatomic) NSArray* itemList;
@property(strong,nonatomic) NSMutableArray *filtereditemArray;
@property NSString *selectedAssortmentName;
@property int dataVersion;
@property DataState dataState;
@property int firstLaunch ;
@property BOOL preloadedOrAssortmentEdit ;
@property double minAppVersion ;
@property NSString *verificationStatus ;
@property BOOL mixpanelBlockedUser ;
@property NSString *discoverColl ;
@property BOOL memdiumSizedImageRequired ;
@property NSInteger selectedMenuIndex;
@property NSString *isDeleteView;
@property NSString *isDuplicateView;
@property NSString *isCreateView;

-(void) saveList;
-(void) restoreList;
-(void) markListAsActive:(Lists *)theList;
-(void) removeItemColorFromActiveList:(Item *)theItem itemColor:(ItemColor *)theColor;
-(void) reconcileFilteredArrayWithActiveList;
-(void) downloadProductInfo:(BOOL) updateLocalData onComplete:(void(^)(void)) handler;
-(void) tryUpdate;
-(void) updateLists;
- (void) doUpdateLists ;


@end
