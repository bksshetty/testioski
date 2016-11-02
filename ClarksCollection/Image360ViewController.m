//
//  Image360ViewController.m
//  ClarksCollection
//
//  Created by Openly on 31/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "Image360ViewController.h"
#import "ImageDownloader.h"
#import "ClarksUI.h"
#import "SWRevealViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface Image360ViewController (){
    UIView *translucentView;
}

@end

@implementation Image360ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
#ifdef DEBUG
    CLSNSLog(@"Image360ViewController: viewDidLoad: Entry");
#endif
    [super viewDidLoad];
    
    UIView *loadingView = [ClarksUI showLoader:self.view];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate = self;
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    translucentView.backgroundColor = [UIColor blackColor];
    translucentView.alpha = 0.85;
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    
    [self loadAllImages:[self.itemColor.images360 mutableCopy] onComplete:^(NSMutableArray *theImages) {
        images = theImages;
        [loadingView removeFromSuperview];
        
        curImage = 0;
        
        UIPanGestureRecognizer *panRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imagePan:)];
        [self.imageView addGestureRecognizer:panRec];
        
        self.imageView.image = [UIImage imageWithData:images[curImage]];
    }];
}

-(void) viewDidAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate = self;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        translucentView.hidden = YES;
    } else {
        translucentView.hidden = NO;
        revealController.frontViewShadowRadius = 0;
        
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        translucentView.hidden = YES;
    } else {
        translucentView.hidden = NO;
        revealController.frontViewShadowRadius = 0;
    }
}

- (void) loadAllImages: (NSMutableArray *)images360 onComplete:(void(^)(NSMutableArray *))handler{
#ifdef DEBUG
    CLSNSLog(@"Image360ViewController: loadAllImages: Entry");
#endif
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
#ifdef DEBUG
    CLSNSLog(@"Image360ViewController: loadAllImages: Exit");
#endif
}

- (void) swipeLeft{
#ifdef DEBUG
    CLSNSLog(@"Image360ViewController: swipeLeft: Entry");
#endif
    curImage++;
    if(curImage >= [images count]){
        curImage = 0;
    }
    self.imageView.image = [UIImage imageWithData:images[curImage]];
#ifdef DEBUG
    CLSNSLog(@"Image360ViewController: swipeLeft: Exit");
#endif
}

- (void) swipeRight{
#ifdef DEBUG
    CLSNSLog(@"Image360ViewController: swipeRight: Entry");
#endif
    curImage--;
    if(curImage < 0){
        curImage = (int)[images count] - 1;
    }
        self.imageView.image = [UIImage imageWithData:images[curImage]];
#ifdef DEBUG
    CLSNSLog(@"Image360ViewController: swipeRight: Exit");
#endif
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) imagePan :(UIPanGestureRecognizer *) sender{
#ifdef DEBUG
    CLSNSLog(@"Image360ViewController: imagePan: Entry");
#endif
    CGPoint pnt = [sender translationInView:self.imageView];
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
#ifdef DEBUG
    CLSNSLog(@"Image360ViewController: imagePan: Exit");
#endif
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
