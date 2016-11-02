//
//  MyCollectionViewFlowLayout.m
//  ClarksCollection
//
//  Created by Adarsh on 27/06/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "MyCollectionViewFlowLayout.h"

@implementation MyCollectionViewFlowLayout

- (void)awakeFromNib
{
//    self.itemSize = CGSizeMake(75.0, 75.0);
    self.minimumInteritemSpacing = 0.0;
    self.minimumLineSpacing = 0.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

#pragma mark - Pagination
- (CGFloat)pageWidth {
    return self.itemSize.width + self.minimumLineSpacing;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat rawPageValue = self.collectionView.contentOffset.x / self.pageWidth;
    CGFloat currentPage = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue);
    CGFloat nextPage = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue);
    
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocity.x) > [self flickVelocity];
    if (pannedLessThanAPage && flicked) {
        proposedContentOffset.x = nextPage * self.pageWidth;
    } else {
        proposedContentOffset.x = round(rawPageValue) * self.pageWidth;
    }
    
    return proposedContentOffset;
}

- (CGFloat)flickVelocity {
    return 0.3;
}

@end
