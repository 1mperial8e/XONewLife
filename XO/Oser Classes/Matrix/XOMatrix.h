//
//  XOMatrix.h
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kDimension = 0;
typedef enum
{
    XOMatrixFirstWin = 3,
    XOMatrixSecondWin = -3,
    XOMatrixNoWinners = 0
} XOResult;

@interface XOMatrix : NSObject
@property (nonatomic) int dimension;
@property (nonatomic) int *vectorValue;
@property (nonatomic, assign) int **value;
@property (nonatomic) int minComb;

- (int)checkMatrix;
- (id)initWithDimension:(int)dimension;
- (void)setValue:(int)value forAbscys:(int)abscys andOrdinat:(int)ordinat;
- (void)setValue:(int)value forPoint:(CGPoint)point;
- (BOOL)setValue:(int)value forIndexPath:(NSIndexPath *)indexPath;
- (int)valueForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)checkMatrixForIndexPath:(NSIndexPath *)indexPath;
+ (XOMatrix *)matrixWithDimension:(int)dimension;
@end
