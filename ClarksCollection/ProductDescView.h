//
//  ProductDescView.h
//  ClarksCollection
//
//  Created by Adarsh on 28/06/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemColor.h"

@interface ProductDescView : UIView

-(void) createDescLabels: (NSArray*)arr;
-(int) getTotalHeight;
@end
