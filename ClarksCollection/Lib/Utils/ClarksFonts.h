//
//  NS360Fonts.h
//  NS 360
//
//  Created by Openly on 25/08/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClarksFonts : NSObject
+(UIFont *) clarksSansProLight:(float)size;
+(UIFont *) clarksSansProRegular:(float)size;
+(UIFont *) clarksSansProThin:(float)size;
+(UIFont *) clarksNarzissMediumBd:(float)size;
+ (NSMutableAttributedString *) addSpaceBwLetters:(NSString *) btnName alpha:(float)f;
@end