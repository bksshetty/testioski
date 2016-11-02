//
//  ViewController.m
//  ScrollViews
//
//  Created by Matt Galloway on 29/02/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "ViewController.h"
#import "ManagedImage.h"
#import "SWRevealViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface ViewController ()
@property (nonatomic, strong) ManagedImage *imageView;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;
@end

@implementation ViewController{
    UIView *translucentView;
}

@synthesize scrollView = _scrollView;

@synthesize imageView = _imageView;

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    self.imageView.frame = contentsFrame;
}

- (IBAction)didClickBack:(id)sender {
    if (translucentView.isHidden) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // Figure out the rect we want to zoom to, then zoom to it
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = 150;//pointInView.x - (w / 2.0f);
    CGFloat y = 100;//pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusBarView.backgroundColor  =  [UIColor blackColor];
    [self.view addSubview:statusBarView];
    self.revealViewController.delegate = self;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"Swipe Up");
        if (translucentView.isHidden) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"Swipe Down");
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.title = @"";
    
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/loading.gif"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:fullpath];
    self.imageView = [[ManagedImage alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size={.width=1024.0f, .height=682.0f}};
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.frame.size;
    [self updateSrollviewPos];
    
    [self.imageView loadImage:theColor.largeImages[imageIdx] onComplete:^{
        UIImage *image = self.imageView.image;
        self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=CGSizeMake(image.size.width/2,image.size.height/2)};
        self.scrollView.contentSize = image.size;
        [self updateSrollviewPos];
        NSLog(@"Zoom: %f, Image size: %fx%f, Scrollview Size: %fx%f",self.scrollView.zoomScale, self.imageView.frame.size.width,self.imageView.frame.size.height,self.scrollView.frame.size.width,self.scrollView.frame.size.height);
    }];
    
    
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
}

-(void) updateSrollviewPos{
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.5f;
    self.scrollView.zoomScale = 0.6f;
    
    [self centerScrollViewContents];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position{
    if (position == FrontViewPositionLeft) {
        self.view.alpha = 1;
        translucentView.hidden = YES;
    }else if(position == FrontViewPositionRight){
        self.view.alpha = 0.15;
        translucentView.hidden = NO;
    }
}
- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress{
    if (progress > 1) {
        self.view.alpha = 0.15;
    }else if(progress == 0){
        self.view.alpha = 1;
        translucentView.hidden = YES;
    }else{
        self.view.alpha = 1 - (0.85 * progress);
        translucentView.hidden = NO;
    }
    NSLog(@"%f - %f",progress, self.view.alpha);
}

-(void) setColor :(ItemColor *) color andImgIdx: (int) imgIdx{
    theColor = color;
    imageIdx = imgIdx;
}
@end
