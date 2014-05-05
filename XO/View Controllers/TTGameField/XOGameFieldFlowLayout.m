//
//  XOGameFieldFlowLayout.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOGameFieldFlowLayout.h"
@interface XOGameFieldFlowLayout ()
@property (nonatomic) int squareColumn;
@end
@implementation XOGameFieldFlowLayout
- (CGSize)itemSize
{
    _squareColumn = (int)sqrt([self.collectionView numberOfItemsInSection:0]);
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width-(10*_squareColumn), self.collectionView.bounds.size.height-(10*_squareColumn));
    CGSize itemSize = CGSizeMake(size.width/_squareColumn, size.height/_squareColumn);
    return itemSize;
}
@end
