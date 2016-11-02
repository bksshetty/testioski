//
//  AssortmentSelectViewController.h
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssortmentDatasource.h"
#import "Region.h"
#import "Assortment.h"
#import "SWRevealViewController.h"

@interface AssortmentSelectViewController : UIViewController<SWRevealViewControllerDelegate>{
    Assortment *curAssortment;
    NSString *assortmentName ;
}
@property (strong, nonatomic) IBOutlet AssortmentDatasource *assortmentDS;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,retain)NSString *assortmentName ;
+(AssortmentSelectViewController*)getInstance ;

@end
