//
//  Image360ViewController.h
//  ClarksCollection
//
//  Created by Openly on 31/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemColor.h"

@interface Image360ViewController : UIViewController{
    NSMutableArray *images;
    int curImage;
    int oldX;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property ItemColor *itemColor;

@end
