//
//  ProductDescView.m
//  ClarksCollection
//
//  Created by Adarsh on 28/06/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "ProductDescView.h"
#import "ClarksColors.h"
#import "ItemColor.h"
#import "ClarksFonts.h"

@implementation ProductDescView{
    NSArray *productDetails;
    int a;
}

-(void) createDescLabels: (NSArray*)arr {
    a = 5;
    for (NSString *str in arr) {
            NSLog(@"Desc String: %@",str);
            NSLog(@"Length of String : %lu",(unsigned long)[str length]);
            if (![str isEqualToString:@""]) {
                NSString *temp = str;
                UILabel *lbl1 = [[UILabel alloc] init];
                lbl1.text = @"\u2022   ";
                lbl1.font = [UIFont fontWithName:@"GillSans" size:10];
                lbl1.frame = CGRectMake(0, a ,9, 10);
                [lbl1 setTextColor:[ClarksColors gillsansDarkGray]];
                [self addSubview:lbl1];
                UILabel *lbl = [[UILabel alloc] init];
                if (([str length] > 70)) {
                    NSRange range = [temp rangeOfComposedCharacterSequencesForRange:(NSRange){0, 70}];
                    temp = [temp substringWithRange:range];
                    NSString *trimmedString=[str substringFromIndex:MAX((int)[str length]-((int)[str length]-(int)[temp length]),0)];
                    NSString *temp1 = trimmedString;
                    if ([temp1 length] > 70) {
                        NSRange range = [temp1 rangeOfComposedCharacterSequencesForRange:(NSRange){0, 70}];
                        temp1 = [temp1 substringWithRange:range];
                    }
                    lbl.attributedText = [ClarksFonts addSpaceBwLetters:[temp uppercaseString] alpha:1.0];
                    lbl.numberOfLines = 0;
                    lbl.font = [UIFont fontWithName:@"GillSans-Light" size:8];
                    lbl.lineBreakMode = NSLineBreakByCharWrapping;
                    lbl.frame = CGRectMake(8, a,397, 9);
                    [lbl setTextColor:[ClarksColors gillsansDarkGray]];
                    [self addSubview:lbl];
                    UILabel *lbl2 = [[UILabel alloc] init];
                    lbl2.attributedText = [ClarksFonts addSpaceBwLetters:[temp1 uppercaseString] alpha:1.0];
                    lbl2.font = [UIFont fontWithName:@"GillSans-Light" size:8];
                    [lbl2 setTextColor:[ClarksColors gillsansDarkGray]];
                    lbl2.frame = CGRectMake(8, a+12,397, 9);
                    lbl2.lineBreakMode = NSLineBreakByCharWrapping;
                    a = a+12+25;
                    [self addSubview:lbl2];
                }else{
                    lbl.attributedText = [ClarksFonts addSpaceBwLetters:[temp uppercaseString] alpha:1.0];
                    lbl.numberOfLines = 0;
                    lbl.font = [UIFont fontWithName:@"GillSans-Light" size:8];
                    lbl.lineBreakMode = NSLineBreakByCharWrapping;
                    lbl.frame = CGRectMake(8, a,397, 9);
                    [lbl setTextColor:[ClarksColors gillsansDarkGray]];
                    [self addSubview:lbl];
                    a = a+25;
                }
            }
    }
//    self.contentSize = CGSizeMake(397, a+5);
}

-(int) getTotalHeight{
    return a;
}
@end
