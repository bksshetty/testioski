//
//  SingleShoeViewController.m
//  ClarksCollection
//
//  Created by Openly on 15/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "SingleShoeViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "ManagedImage.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "ItemsInListViewController.h"
#import "ClarksUI.h"
#import "ManagedImage.h"
#import "CollectionViewCellButton.h"
#import "SWRevealViewController.h"
#import "DiscoverCollectionDetailViewController.h"
#import "MarketingMaterial.h"z
#import "MarketingCategory.h"
#import "MarketingDetailViewController.h"
#import "MixPanelUtil.h"
#import "ImageDownloader.h"
#import "DataReader.h"
#import "Image360.h"
#import <AVFoundation/AVFoundation.h>
#import "ItemColor.h"
#import "ProductDescView.h"

@interface SingleShoeViewController (){
    bool viewLoaded;
    ItemColor *curColor;
    int curColorIdx;
    BOOL isSlidePanelOpen;
    BOOL bFirstTime;
    BOOL isClicked;
    int i ;
    UIView *translucentView;
    UIView *translucentView1;
    NSArray *productDetails;
    int techs;
    NSMutableArray *images;
    int curImage;
    int oldX;
    ProductDescView *descriptionView;
    Image360 *image360;
    UIImageView *imageView1;
    AVPlayerLayer *layer;
    AVPlayer *player;
}

@end

@implementation SingleShoeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewLoaded = false;
        isSlidePanelOpen = NO;
        bFirstTime = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
    [self.view addSubview:translucentView];
    translucentView.hidden = YES;
    translucentView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 724,768)];
    translucentView1.backgroundColor = [UIColor blackColor];
    translucentView1.alpha = 0.85;
    [self.view addSubview:translucentView1];
    translucentView1.hidden = YES;
    NSArray *labels = [NSArray arrayWithObjects:@"GENDER",@"COLLECTION",@"UPPER MATERIALS",@"SOLE",@"CONSTRUCTION",@"HEEL HEIGHT",@"LINING",@"SOCK",@"LENGTH",@"WIDTH",@"HEIGHT", nil];
    statusBarView.backgroundColor  =  [UIColor blackColor];
    NSString *heelHeight ;
    self.btnNewList.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.btnNewList.layer.borderWidth = 1;
    self.btnNewList.layer.cornerRadius = 3;
    self.btnCreateNewList.layer.borderColor = [ClarksColors gillsansGray].CGColor;
    self.btnCreateNewList.layer.borderWidth = 1;
    self.btnCreateNewList.layer.cornerRadius = 3;
    [self.btnCreateNewList setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
    self.btnCreateNewList.enabled = NO;
    self.txtNewList.layer.cornerRadius = 3;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.txtNewList];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    self.txtNewList.layer.cornerRadius = 3;
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [self.txtNewList setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtNewList setLeftView:spacerView2];
    if(theItem.heelHeight != nil && [theItem.heelHeight length]>0)
        heelHeight = [NSString stringWithFormat:@"%@ mm", theItem.heelHeight];
    else
        heelHeight = theItem.heelHeight;
    UIView *descView = [[UIView alloc] initWithFrame:CGRectMake(0, 621, 323, 146)];
    descView.center = CGPointMake(CGRectGetWidth(self.scrollView.bounds)/2.0f, 681);
    descView.hidden = YES;
    self.tutBtn.hidden = YES;
    self.revealViewController.frontViewShadowRadius = 0;
    [self.scrollView addSubview:descView];
    NSString *gender ;
    if (theItem.gender[0] == nil) {
        gender = @"";
    }else{
        gender = theItem.gender[0];
    }
    NSArray *values = [NSArray arrayWithObjects:gender,theItem.collectionName,theItem.upperMaterial, theItem.sole, theItem.construction, heelHeight, theItem.lining, theItem.sock,theItem.length,theItem.width,theItem.height, nil];
    [self.view addSubview:statusBarView];
    isClicked = TRUE;
    int a =0, b =8, cnt = 0;
    if ([curColor.material length] == 0) {
        self.productDetailView.hidden = YES;
        descView.hidden = NO;
        if (!values || [values count] > 0) {
            for(int x=0; x<[labels count]; x++){
                if (!values[x] || [values[x] length]!=0) {
                    [self createSeperaterView:a v:descView];
                    [self createLeftLabels:labels[x] yValue:b v: descView];
                    [self createRightLabels:[values[x] uppercaseString] yValue:b v: descView];
                    a = a+24;
                    b = b+24;
                    cnt++;
                }
            }
        }
        if (cnt != 0) {
            [self createSeperaterView:a v: descView];
        }
    }else{
        self.productDetailView.hidden = NO;
        descView.hidden = YES;
        if (!values || [values count] > 0) {
            for(int x=0; x<[labels count]; x++){
                if (!values[x] && [values[x] length] != 0) {
                    NSLog(@"Value : %@",values[x]);
                    [self createSeperaterView:a v:self.productDetailView];
                    [self createLeftLabels:labels[x] yValue:b v: self.productDetailView];
                    [self createRightLabels:[values[x] uppercaseString] yValue:b v:self.productDetailView];
                    a = a+24;
                    b = b+24;
                    cnt++;
                }
            }
        }
        if (cnt != 0) {
            [self createSeperaterView:a v:self.productDetailView];
        }
    }
    viewLoaded = true;
    [self displayItem];
    self.pageControl.hidesForSinglePage = YES;
    self.scrollView.contentSize = CGSizeMake(1024, 4433);
    self.scrollView.scrollEnabled = YES;
    self.viewListItem.layer.borderWidth = 1;
    self.viewListItem.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    self.viewListItem.layer.cornerRadius = 3;
    productDetails = [[NSArray alloc] init];
    productDetails = [curColor.material componentsSeparatedByString:@"%"];
    NSLog(@"Material : %@",curColor.material);
    descriptionView = [[ProductDescView alloc] initWithFrame:CGRectMake(537, 621, 397, 146)];
    self.productDescView.hidden = YES;
    [descriptionView createDescLabels:productDetails];
    [self.scrollView addSubview:descriptionView];
    float height = 0;
    if ([theItem.colors count]%4 == 0) {
        height = [theItem.colors count]/4;
    }else{
        height = [theItem.colors count]/4 + 1;
    }
    NSLog(@"Total Number of Tech Logos: %d", [self getNumberOfTechLogos]);
    int diff = [descriptionView getTotalHeight]-self.productDescView.frame.size.height;
    if (diff <= 0) {
        diff = 0;
    }
    NSLog(@"Diff is %d", diff);
    if ([self getNumberOfTechLogos] < 1 && [theItem.colors count] <= 4) {
        self.techLbl.hidden = YES;
        self.techLogosGrid.hidden = YES;
        CGRect f = self.colorWaysLbl.frame;
        if ([curColor.material isEqualToString:@""] && [values count] == 0) {
            if (diff >200)
                [ClarksUI reposition:self.colorWaysLbl x:f.origin.x y:f.origin.y-390+diff];
            else
                [ClarksUI reposition:self.colorWaysLbl x:f.origin.x y:f.origin.y-350+diff];
            f = self.colorWaysView.frame;
            [ClarksUI reposition:self.colorWaysView x:f.origin.x y:f.origin.y-350+diff];
            self.scrollView.contentSize = CGSizeMake(1024, 4433-381*3-350+diff);
            f = self.plainView.frame;
            [ClarksUI reposition:self.plainView x:f.origin.x y:f.origin.y-381*3-350+diff];
        }else{
            if (diff >200)
                [ClarksUI reposition:self.colorWaysLbl x:f.origin.x y:f.origin.y-230+diff];
            else
                [ClarksUI reposition:self.colorWaysLbl x:f.origin.x y:f.origin.y-190+diff];
            f = self.colorWaysView.frame;
            [ClarksUI reposition:self.colorWaysView x:f.origin.x y:f.origin.y-190+diff];
            self.scrollView.contentSize = CGSizeMake(1024, 4433-381*3-190+diff);
            f = self.plainView.frame;
            [ClarksUI reposition:self.plainView x:f.origin.x y:f.origin.y-381*3-190+diff];
        }
    }else if ([self getNumberOfTechLogos] >= 1 && [theItem.colors count] <= 4){
        if ([curColor.material isEqualToString:@""] && [values count] == 0) {
            self.techLbl.hidden = NO;
            self.techLogosGrid.hidden = NO;
            self.scrollView.contentSize = CGSizeMake(1024, 4433-381*3+diff-160);
            CGRect f = self.plainView.frame;
            [ClarksUI reposition:self.plainView x:f.origin.x y:f.origin.y-381*3+diff];
        }else{
            self.techLbl.hidden = NO;
            self.techLogosGrid.hidden = NO;
            self.scrollView.contentSize = CGSizeMake(1024, 4433-381*3+diff);
            CGRect f = self.plainView.frame;
            [ClarksUI reposition:self.plainView x:f.origin.x y:f.origin.y-381*3+diff];
        }
        
    }else if ([self getNumberOfTechLogos] < 1 && [theItem.colors count] > 4){
        if ([curColor.material isEqualToString:@""] && [values count] == 0) {
            self.techLbl.hidden = YES;
            self.techLogosGrid.hidden = YES;
            CGRect f = self.colorWaysLbl.frame;
            [ClarksUI reposition:self.colorWaysLbl x:f.origin.x y:f.origin.y-190+diff];
            f = self.colorWaysView.frame;
            [ClarksUI reposition:self.colorWaysView x:f.origin.x y:f.origin.y-190+diff];
            self.scrollView.contentSize = CGSizeMake(1024, 4433-190- 380*(4-height)+diff-160);
            f = self.plainView.frame;
            [ClarksUI reposition:self.plainView x:f.origin.x y: f.origin.y-190- 380*(4-height)+diff];
        }else{
            self.techLbl.hidden = YES;
            self.techLogosGrid.hidden = YES;
            CGRect f = self.colorWaysLbl.frame;
            [ClarksUI reposition:self.colorWaysLbl x:f.origin.x y:f.origin.y-190+diff];
            f = self.colorWaysView.frame;
            [ClarksUI reposition:self.colorWaysView x:f.origin.x y:f.origin.y-190+diff];
            self.scrollView.contentSize = CGSizeMake(1024, 4433-190- 380*(4-height)+diff);
            f = self.plainView.frame;
            [ClarksUI reposition:self.plainView x:f.origin.x y: f.origin.y-190- 380*(4-height)+diff];
        }
    }else{
        if ([curColor.material isEqualToString:@""] && [values count] == 0) {
            self.techLbl.hidden = NO;
            self.techLogosGrid.hidden = NO;
            self.scrollView.contentSize = CGSizeMake(1024, 4433- 381*(4-height)+diff-160);
        }else{
            self.techLbl.hidden = NO;
            self.techLogosGrid.hidden = NO;
            self.scrollView.contentSize = CGSizeMake(1024, 4433- 381*(4-height)+diff);
        }
    }
    if ([curColor.material isEqualToString:@""]) {
        self.productDetailView.center = CGPointMake(512, 621);
    }
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.swipeview addGestureRecognizer:doubleTap];
    self.scrollView.delegate = self;
    
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.delegate = self;
    [self.scrollView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    UIPanGestureRecognizer *panLeft = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan)];
    [self.rightView addGestureRecognizer:panLeft];
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)sender{
    NSLog(@"Double tap recognized");
    self.swipeview.center = CGPointMake(self.swipeview.bounds.size.width/2,
                              self.swipeview.bounds.size.height/2);
    self.swipeview.transform = CGAffineTransformIdentity;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        _lastScale = [gestureRecognizer scale];
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        CGFloat currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 2.0;
        const CGFloat kMinScale = 1.0;
        
        CGFloat newScale = 1 -  (_lastScale - [gestureRecognizer scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform], newScale, newScale);
        [gestureRecognizer view].transform = transform;
        _lastScale = [gestureRecognizer scale];  // Store the previous scale factor for the next pinch gesture call
    }
    NSLog(@"Recieved pinch");
    NSLog(@"Scale is: %f", gestureRecognizer.scale);
}

-(void)textFieldDidChange: (UITextField *)field{
    if ([self.txtNewList.text isEqualToString:@""]) {
        self.btnCreateNewList.enabled = NO;
        self.btnCreateNewList.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        [self.btnCreateNewList setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        self.btnCreateNewList.layer.borderWidth = 1;
    }else{
        self.btnCreateNewList.enabled = YES;
        self.btnCreateNewList.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        [self.btnCreateNewList setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        self.btnCreateNewList.layer.borderWidth = 1;
    }
}

-(void) didPan{
    self.isListView = @"YES";
    translucentView1.hidden = NO;
    self.revealViewController.panGestureRecognizer.enabled = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isDuplicateView = @"YES";
    Lists *activeList = appDelegate.activeList;
    if(activeList == nil) {
        [self hideAllSlideOutViews];
        [self slideOutCollectionView];
        self.itemListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.selectListView.hidden = NO;
        [self.itemListTableView reloadData];
    }else {
        [self slideOutCollectionView];
        self.itemListView.hidden = NO;
        [self.listItemDS setUpData];
        [self.listTable reloadData];
        [self updateListViewListNameLabel];
    }
    [self slideOutCollectionView];
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

- (void) createLeftLabels: (NSString *)name yValue:(int)y v:(UIView *)view1{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(2,y, 160,9)];
    lbl.font= [UIFont fontWithName:@"GillSans-Light" size:9];
    [lbl setTextColor:[ClarksColors gillsansDarkGray]];
    lbl.text = name;
    [view1 addSubview:lbl];
}

- (void) createRightLabels: (NSString *)name yValue:(int)y v:(UIView *)view1{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(162,y, 162,9)];
    lbl.font= [UIFont fontWithName:@"GillSans-Light" size:9];
    [lbl setTextColor:[ClarksColors gillsansDarkGray]];
    lbl.text = name;
    lbl.textAlignment = UITextAlignmentRight;
    [view1 addSubview:lbl];
}

-(void) createSeperaterView: (int)y v:(UIView *)view1{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, 323, 1 )];
    view.backgroundColor = [ClarksColors gillsansGray];
    [view1 addSubview:view];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        self.isListView = @"NO";
        translucentView1.hidden = YES;
        self.revealViewController.panGestureRecognizer.enabled = YES;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.isDuplicateView = @"NO";
        [self hideAllSlideOutViews];
        [self slideBackInCollectionView];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL) isActiveList {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if(activeList != nil)
        return YES;
    return NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([self.isListView isEqualToString:@"YES"]) {
        appDelegate.isDuplicateView = @"YES";
        self.revealViewController.panGestureRecognizer.enabled = NO;
    }
    self.revealViewController.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.txtNewList.delegate = self;
    self.itemListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.title = theItem.name;
    self.btnListChange.hidden = NO ;
    imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 65, 930, 500)];
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Drawing" ofType:@"png"]];
    imageView1.image = img;
    NSURL *streamURL = [NSURL URLWithString:@"http://dy9opnuafumhf.cloudfront.net/Aa.mov"];
    player = [AVPlayer playerWithURL:streamURL];
    layer = [AVPlayerLayer layer];
    [layer setPlayer:player];
    [layer setFrame:CGRectMake(40, 95, 845, 440)];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void) setItem:(Item *)item withColorIndex:(int)index{
    theItem = item;
    if (index > [theItem.colors count]) {
        return;
    }else if(index == [theItem.colors count]){
        index--;
    }
    curColor = theItem.colors[index];
    curColorIdx = index;
    [self displayItem];
}

- (void) displayItem{
    self.pageControl.currentPage = self.index1;
    if (viewLoaded && theItem != nil) {
        self.shoeName.attributedText = [ClarksFonts addSpaceBwLetters:[theItem.name uppercaseString] alpha:2.0];
        self.title = theItem.name;
        self.colorName.attributedText = [ClarksFonts addSpaceBwLetters:[curColor.name uppercaseString] alpha:2.0];;
        [[MixPanelUtil instance] track:@"details"];
        [self.swipeview reloadData];
        self.swipeview.bounces = NO;
    }
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 1)
        return [theItem.colors count];
    if (collectionView.tag == 2)
        return [theItem.technologies count];
    return 0;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if (collectionView.tag == 1) {
        static NSString *identifier1 = @"Cell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        ItemColor *color = ((ItemColor *)theItem.colors[indexPath.row]);
        ManagedImage *shoeImage= (ManagedImage *)[cell viewWithTag:1];
        if ([color.largeImages[0] rangeOfString:@"unavailable"].location == NSNotFound)
            [shoeImage loadImage:color.largeImages[0]];
        UILabel *articleLbl = (UILabel *) [cell viewWithTag:2];
        UILabel *colorLbl = (UILabel *)[cell viewWithTag:3];
        UILabel *sizeAndFitLbl = (UILabel *)[cell viewWithTag:4];
        UILabel *fadLbl = (UILabel *)[cell viewWithTag:5];
        articleLbl.text = color.colorId;
        colorLbl.text = [color.name uppercaseString];
        sizeAndFitLbl.text = [NSString stringWithFormat:@"%@ / %@", theItem.size,theItem.fit];
        NSLog(@"FAD Value: %@",color.fad);
        if(![color.fad isKindOfClass:[NSNull class]]){
            fadLbl.text = color.fad;
        }else{
            UILabel *fad = (UILabel *)[cell viewWithTag:6];
            UIView *fadView = (UIView *)[cell viewWithTag:7];
            fad.hidden = YES;
            fadView.hidden = YES;
            fadLbl.text = @"";
        }
        UIButton *btn = (UIButton *)[cell viewWithTag:10];
        [btn setTitle:color.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onClickPlus:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (collectionView.tag == 2) {
        static NSString *identifier2 = @"Tech-Cell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
        NSDictionary *data = [DataReader read];
        NSString *imgName = [NSString stringWithFormat:@"%@",[theItem.technologies[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
        imgName = [imgName lowercaseString];
        NSDictionary *techLogos = [data valueForKey:@"technologies"];
        NSDictionary *techLogoObjs  = [techLogos valueForKey:imgName];
        NSString *techLogos_urls = [techLogoObjs valueForKey:@"logo"];
        NSString *idx = [techLogoObjs valueForKey:@"story_id"];
        NSLog(@"Tech Logo: %@", techLogos_urls);
        [[ImageDownloader instance] priorityDownload:techLogos_urls onComplete:^(NSData *theData) {
            if (theData == nil)
                techs = 0;
            UIImage *img = [UIImage imageWithData:theData];
            UIButton *btn = (UIButton *)[cell viewWithTag:1];
            [btn setTitle:idx forState:UIControlStateNormal];
            btn.contentMode = UIViewContentModeScaleAspectFit ;
            btn.adjustsImageWhenHighlighted = NO;
            btn.titleLabel.layer.opacity = 0.0f;
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onTechClick:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
        NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    if( cellCount >0 ){
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount;
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth<contentWidth ){
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
    }
    return UIEdgeInsetsZero;
}

-(void) onClickPlus:(UIButton*)btn{
    UICollectionViewCell *cell = (UICollectionViewCell*)[[btn superview] superview];
    ItemColor *theColor;
    for (ItemColor *col in theItem.colors) {
        if ([col.name isEqualToString:btn.titleLabel.text]) {
            theColor = col;
        }
    }
    if ([self isActiveList] == NO) {
        self.tmpColor = theColor;
        [self performNoActiveList];
        return;
    }
    BOOL currentState = theColor.isSelected;
    if(currentState == NO){
        theColor.isSelected = YES;
        [self addItemColorToActiveList:theColor];
    }else{
        theColor.isSelected = NO;
        [self removeItemColorFromActiveList:theColor];
    }
    UIImage *image;
    if(theColor.isSelected){
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/blue-cancel-icon.png"];
        image = [UIImage imageWithContentsOfFile:fullpath];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
    }else{
        NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/gray-plus-icon.png"];
        image = [UIImage imageWithContentsOfFile:fullpath];
        cell.layer.borderWidth = 0;
    }
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self
               action:@selector(onClickPlus:)
     forControlEvents:UIControlEventTouchUpInside];
    [self updateListTable];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self setColor: (int)indexPath.row];
    _index = (int) indexPath.row;
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
    image360.hidden = YES;
}

- (void)onTechClick:(UIButton *)btn{
    NSString *curTech = [[btn titleForState:UIControlStateNormal] lowercaseString];
    NSArray *categories = [MarketingCategory loadAll];
    for (MarketingCategory *cat in categories) {
       for (MarketingMaterial *mat in cat.marketingMaterials) {
            if ([[mat.idx lowercaseString] isEqualToString:curTech]) {
                NSLog(@"Marketing Material Name: %@", mat.name);
                MarketingDetailViewController *mdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"marketing_detail"];
                [[MixPanelUtil instance] track:@"tech_logo_clicked" args:((NSString *) @"Technology Logo Clicked")];
                mdvc.theMarketingData = mat;
                [self.navigationController pushViewController:mdvc animated:NO];
                    return;
            }
        }
    }
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return [curColor.largeImages count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    self.pageControl.numberOfPages = [curColor.largeImages count];
    self.pageControl.backgroundColor = [UIColor clearColor];
    if (view == nil) {
        CGRect frame = CGRectMake(170, 46, 687, 407);
        view = [[ManagedImage alloc] initWithFrame: frame];
    }
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/translucent.jpg"];
    ((ManagedImage *)view).image = [UIImage imageWithContentsOfFile:fullpath];
    [((ManagedImage *)view) loadImage:curColor.largeImages[index]];
    NSLog(@"Image Path :%@", curColor.largeImages[index]);
    self.index1 = (int)index;
    ((ManagedImage *)view).contentMode = UIViewContentModeScaleAspectFit;
    return view;
}

- (int) presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return (int)[curColor.largeImages count];
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    int index=(int)swipeView.currentItemIndex;
    self.pageControl.currentPage = index;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index{
    if (theItem.has360 && [curColor.images360 count] != 0 && index == 0) {
        NSLog(@"Control coming here!!!");
        image360  = [[Image360 alloc] initWithFrame:CGRectMake(10, 5, 1004, 680)];
        image360.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        image360.layer.borderWidth = 1;
        [image360 loadImages:curColor];
        [self.scrollView addSubview:image360];
    }else{
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"image_zoom"];
        [[MixPanelUtil instance] track:@"zoomImage"];
        [self.navigationController pushViewController:vc animated:YES];
        [vc setColor:curColor andImgIdx:(int)index];
    }
}

-(void) setColor: (int) idx{
    if (idx >= [theItem.colors count])
        return;
    curColor = theItem.colors[idx];
    self.pageControl.numberOfPages = [curColor.largeImages count];
    [[MixPanelUtil instance] track:@"color"];
    [self displayItem];
}

-(void) addItemColorToActiveList:(ItemColor *)theColor {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if(activeList != nil) {
        ListItem *theListItem  = [[ListItem alloc ]initWithItemAndColor:theItem withColor:theColor];
        [activeList addItemColorToList:theListItem withPositionCheck:YES];
        [appDelegate saveList];
        theColor.isSelected = YES;
        theItem.isSelected = YES;
    }
}

-(void) removeItemColorFromActiveList:(ItemColor *)theColor {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate removeItemColorFromActiveList:theItem itemColor:theColor];
    BOOL bAnyItemSelected = NO;
    for (ItemColor *theTempColor in theItem.colors) {
        if(theTempColor.isSelected) {
            bAnyItemSelected = YES;
            break;
        }
    }
    if(bAnyItemSelected == NO)
        theItem.isSelected = NO;
}

#pragma mark - List
- (IBAction)onListClearAll:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    [curList emptyList];
    [self.listItemDS setUpEmptyData];
    [self updateListViewListNameLabel];
    for(Item *theCurItem in appDelegate.filtereditemArray)
        [theCurItem markItemAsDeselected];
    [appDelegate saveList];
    [self.listTable reloadData];
}

- (IBAction)onPerformCreateNewList:(id)sender {
    NSString *newListName = [self.txtNewList.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.view endEditing:YES];
    [self.txtNewList resignFirstResponder];
    BOOL uniqueListName = YES;
    for(Lists *theList in appDelegate.listofList) {
        if([theList.listName isEqualToString:newListName]) {
            uniqueListName = NO;
            break;
        }
    }
    if(uniqueListName == NO){
        NSString *message= [NSString stringWithFormat:@"%@ already exits",newListName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already exists"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    Lists *newList = [[Lists alloc]init];
    newList.listName = newListName;
    [appDelegate markListAsActive:newList];
    if(self.tmpColor != nil) { // We had a parked item to add
        [self addItemColorToActiveList:self.tmpColor];
        self.tmpColor = nil;
    }
    [appDelegate.listofList addObject:newList];
    [self hideAllSlideOutViews];
    [self updateListViewListNameLabel];
    [self showListView];
    [appDelegate saveList];
}

- (IBAction)onEditingBeing:(id)sender {
    [self repositionNewListViewButtons];
}

- (IBAction)onEditingEnded:(id)sender {
    [self unRepositionNewListViewButtons];
}

-(void) updateListViewListNameLabel {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    int count = (int)[curList.listOfItems count] ;
    NSString *productCount = [[NSString stringWithFormat:@"(%lu PRODUCTS)",(unsigned long)[curList.listOfItems count]] uppercaseString];
    self.lblListName.attributedText = [ClarksFonts addSpaceBwLetters:[curList.listName uppercaseString] alpha:2.0];
    self.lblProductCount.attributedText = [ClarksFonts addSpaceBwLetters:productCount alpha:2.0];
    if(count <=0){
        self.noListView.hidden = NO;
        self.viewListItem.enabled = NO;
        self.viewListItem.layer.borderColor = [ClarksColors gillsansGray].CGColor;
        [self.viewListItem setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        [self.btnCloseItemList setTitleColor:[ClarksColors gillsansGray] forState:UIControlStateNormal];
        self.btnCloseItemList.enabled = NO;
        self.listTable.hidden = YES;
    }else{
        self.viewListItem.enabled = YES;
        self.viewListItem.layer.borderColor = [ClarksColors gillsansBlue].CGColor;
        [self.viewListItem setTitleColor:[ClarksColors gillsansBlue] forState:UIControlStateNormal];
        [self.btnCloseItemList setTitleColor:[ClarksColors gillsansDarkGray] forState:UIControlStateNormal];
        self.btnCloseItemList.enabled = YES;
        self.noListView.hidden = YES;
        self.listTable.hidden = NO;
    }
}

-(void) showListView{
    translucentView1.hidden = NO;
    self.revealViewController.panGestureRecognizer.enabled = NO;
    [self slideOutCollectionView];
    self.itemListView.hidden = NO;
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self updateListViewListNameLabel];
}

- (IBAction)onOpenAList:(id)sender {
    translucentView1.hidden = NO;
    self.revealViewController.panGestureRecognizer.enabled = NO;
    [self hideAllSlideOutViews];
    [self slideOutCollectionView];
    self.itemListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectListView.hidden = NO;
    [self.itemListTableView reloadData];
}

- (IBAction)onCreateNewList:(id)sender {
    [self hideAllSlideOutViews];
    self.txtNewList.text = @"";
    self.theNewListView.hidden = NO;
}

-(void)updateListTable {
    [self updateListViewListNameLabel];
    [self.listItemDS setUpData];
    if(self.itemListView.hidden)
        return;
    [self.listTable reloadData];
}

-(void) performNoActiveList {
    [self.shoeListCollectionView setUserInteractionEnabled:NO];
    [self onOpenAList:nil];
    return;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onShowListSlideout:(id)sender {
    if(isSlidePanelOpen) {
        [self closeLeftSlideOut:sender];
        return;
    }
    [self hideAllSlideOutViews];
    [self slideOutCollectionView];
    self.itemListView.hidden = NO;
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self updateListViewListNameLabel];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"discover_collection"]) {
        DiscoverCollectionDetailViewController *destVC = (DiscoverCollectionDetailViewController *)segue.destinationViewController;
        [[MixPanelUtil instance] track:@"discover_selected_via_shoe"];
        [destVC setupTransitionFromShoeDetail:theItem.collectionName];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([segue.destinationViewController class] != [ItemsInListViewController class]) {
        return;
    }else {
        ItemsInListViewController *itemsInListVC = (ItemsInListViewController *)segue.destinationViewController;
        int index = (int)[appDelegate.listofList indexOfObject:appDelegate.activeList];
        [self.shoeListCollectionView setUserInteractionEnabled:YES];
        [itemsInListVC setListIndex:index];
    }
}

-(void) unRepositionNewListViewButtons {
    CGRect f = self.lblCreateANewList.frame;
    [ClarksUI reposition:self.lblCreateANewList x:f.origin.x y:189];
    f = self.txtNewList.frame;
    [ClarksUI reposition:self.txtNewList x:f.origin.x y:287];
    f = self.btnCreateNewList.frame;
    [ClarksUI reposition:self.btnCreateNewList x:f.origin.x y:364];
}

-(void) repositionNewListViewButtons {
    CGRect f = self.lblCreateANewList.frame;
    [ClarksUI reposition:self.lblCreateANewList x:f.origin.x y:189-100];
    f = self.txtNewList.frame;
    [ClarksUI reposition:self.txtNewList x:f.origin.x y:287-100];
    f = self.btnCreateNewList.frame;
    [ClarksUI reposition:self.btnCreateNewList x:f.origin.x y:364-100];
}

- (IBAction)onChangeList:(id)sender {
    [self onOpenAList:sender];
}

- (IBAction)closeLeftSlideOut:(id)sender {
    [self slideBackInCollectionView];
    [self hideAllSlideOutViews];
    self.tmpColor = nil;
}

-(void) slideOutCollectionView{
    CGRect f = self.shoeListCollectionView.frame;
    [ClarksUI reposition:self.shoeListCollectionView x:-314 y:f.origin.y];
    isSlidePanelOpen = YES;
}

-(void) slideBackInCollectionView{
    CGRect f = self.shoeListCollectionView.frame;
    [ClarksUI reposition:self.shoeListCollectionView x:0 y:f.origin.y];
    isSlidePanelOpen = NO;
}

-(int) getNumberOfTechLogos{
    int a = 0;
    NSDictionary *data = [DataReader read];
    if(theItem.technologies != nil) {
        if([theItem.technologies count] >0) {
            for (NSString *tech in theItem.technologies) {
                NSString *imgName = [NSString stringWithFormat:@"%@",[tech stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
                imgName = [imgName lowercaseString];
                NSDictionary *techLogos = [data valueForKey:@"technologies"];
                NSDictionary *techLogoObjs  = [techLogos valueForKey:imgName];
                NSString *techLogos_urls = [techLogoObjs valueForKey:@"logo"];
                if (techLogos_urls != nil || [techLogos_urls length] != 0) {
                    a++;
                }
            }
        }
    }
    return a;
}

-(void) hideAllSlideOutViews {
    [self.shoeListCollectionView setUserInteractionEnabled:YES];
    self.itemListView.hidden = YES;
    self.saveListView.hidden = YES;
    self.selectListView.hidden = YES;
    self.theNewListView.hidden = YES;
    isSlidePanelOpen = NO;
}

- (IBAction)didClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickUp:(id)sender {
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
}

- (IBAction)onClickTut:(id)sender {
    if (isClicked){
        [player play];
        [self.scrollView addSubview:imageView1];
        [self.scrollView.layer addSublayer:layer];
        isClicked = NO;
    }else{
        [player pause];
        [layer removeFromSuperlayer];
        [imageView1 removeFromSuperview];
        isClicked = YES;
    }
}

@end
