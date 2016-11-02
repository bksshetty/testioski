//
//  OpenDisclosureIndicator.h
//  ClarksCollection
//
//  Created by Openly on 10/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenDisclosureIndicator : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (OpenDisclosureIndicator *)accessoryWithColor:(UIColor *)color;

@end
