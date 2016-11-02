//
//  ChangeTeritoryViewController.h
//  ClarksCollection
//
//  Created by Openly on 21/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeTeritoryViewController : UIViewController{
    //Used to store the bounds of the viewController
    CGRect realBounds;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lbl;

- (IBAction)onClose:(id)sender;
- (IBAction)onApply:(id)sender;

@end
