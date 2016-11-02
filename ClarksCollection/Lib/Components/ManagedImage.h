//
//  ManagedImage.h
//  Clarks Collection
//
//  Created by Openly on 08/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagedImage : UIImageView{
    UIView *loader;
    NSString *curLocation;
    
    void (^handler)(void);
}
-(void) loadImage:(NSString *) location;
-(void) loadImage:(NSString *) location onComplete:(void(^)(void)) handler;
@end
