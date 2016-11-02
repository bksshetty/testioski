//
//  DeleteView.h
//  ClarksCollection
//
//  Created by Adarsh on 20/05/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface DeleteView : UIView
-(void) getIndex: (int)idx;

@property (nonatomic, readonly) ListViewController *listViewController;

@end
