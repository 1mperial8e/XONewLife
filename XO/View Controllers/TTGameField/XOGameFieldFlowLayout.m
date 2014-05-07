//
//  XOGameFieldFlowLayout.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOGameFieldFlowLayout.h"
#import "XOGameModel.h"
struct itemAtr
{
    int size;
    int space;
};
struct XOItemAttributes
{
    float size;
    float space;
};
@interface XOGameFieldFlowLayout ()
@property (nonatomic) int squareColumn;
@property (nonatomic) struct itemAtr atr;
@property (nonatomic) struct XOItemAttributes attrib;

@end
@implementation XOGameFieldFlowLayout
@synthesize attrib;
- (CGSize)itemSize
{
    if (!attrib.space&&!attrib.size) {
        float fullSize = self.collectionView.bounds.size.width/[XOGameModel sharedInstance].dimension;
        attrib.space = fullSize*0.1;
        attrib.size = fullSize-attrib.space;
        self.sectionInset = UIEdgeInsetsMake(attrib.space, 0, 0, 0);
    }
    //NSLog(@"%f, %f, %f, %f", attrib.size, attrib.space, self.collectionView.bounds.size.width, fullSize);
    return CGSizeMake(attrib.size, attrib.size);
}

@end
