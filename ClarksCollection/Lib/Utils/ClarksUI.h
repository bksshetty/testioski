//
//  ClarksUI.h
//  Clarks Collection
//
//  Created by Openly on 26/08/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClarksUI : NSObject
+(UIView *) showLoader:(UIView *)view;
+(UIView *) showOverlay:(UIView *)view;
+(void) reposition: (UIView *) view x:(int) newX y:(int) newY;
+(void) setWidth: (UIView *) view width:(int) newWidth;

@end
