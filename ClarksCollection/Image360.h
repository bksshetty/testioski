//
//  Image360.h
//  ClarksCollection
//
//  Created by Adarsh on 09/06/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemColor.h"

@interface Image360 : UIView

@property ItemColor *color;
-(void) setColor:(ItemColor *)color;
-(void) loadImages:(ItemColor*) col;

@end
