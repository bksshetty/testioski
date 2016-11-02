//
//  ProductDetailView.m
//  ClarksCollection
//
//  Created by Adarsh on 28/06/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "ProductDetailView.h"
#import "ClarksColors.h"

@implementation ProductDetailView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
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

@end
