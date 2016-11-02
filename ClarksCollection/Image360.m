//
//  Image360.m
//  ClarksCollection
//
//  Created by Adarsh on 09/06/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "Image360.h"
#import "ImageDownloader.h"
#import "ClarksUI.h"
#import "ItemColor.h"

@implementation Image360{
    NSMutableArray *images;
    int curImage;
    int oldX;
    UIImageView *imageView;
    UIView *loadingView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        loadingView = [ClarksUI showLoader:self];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 984, 630)];
        [self addSubview:imageView];
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(950, 10, 40, 40)];
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/cross-btn-icon.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
        [closeBtn setBackgroundImage:image forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(didClickClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) didClickClose{
    self.hidden = YES;
}

-(void) loadImages:(ItemColor*) col{
    [self loadAllImages:[col.images360 mutableCopy] onComplete:^(NSMutableArray *theImages) {
        images = theImages;
        [loadingView removeFromSuperview];
        curImage = 0;
        UIPanGestureRecognizer *panRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imagePan:)];
        [imageView addGestureRecognizer:panRec];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageWithData:images[curImage]];
    }];
}

- (void) loadAllImages: (NSMutableArray *)images360 onComplete:(void(^)(NSMutableArray *))handler{
    
    NSMutableArray *allImages = [[NSMutableArray alloc] init];
    if ([images360 count] < 1) {
        handler(allImages);
        return;
    }
    NSString *nextImage = [images360 firstObject];
    [images360 removeObjectAtIndex:0];
    [[ImageDownloader instance] priorityDownload:nextImage onComplete:^(NSData *theData) {
        if(theData != nil)
            [allImages addObject:theData];
        [self loadAllImages:images360 onComplete:^(NSArray *others) {
            [allImages addObjectsFromArray:others];
            handler(allImages);
        }];
    }];
}

- (void) swipeLeft{
    curImage++;
    if(curImage >= [images count]){
        curImage = 0;
    }
    imageView.image = [UIImage imageWithData:images[curImage]];
}

- (void) swipeRight{
    curImage--;
    if(curImage < 0){
        curImage = (int)[images count] - 1;
    }
    imageView.image = [UIImage imageWithData:images[curImage]];
}

- (void) imagePan :(UIPanGestureRecognizer *) sender{
    CGPoint pnt = [sender translationInView:imageView];
    float x = pnt.x;
    static float prevX;
    if (x > prevX + 20) {
        [self swipeRight];
    }else if(x < prevX - 20){
        [self swipeLeft];
    }
    if (x > prevX + 20 || x < prevX - 20) {
        prevX = x;
    }
}

@end
