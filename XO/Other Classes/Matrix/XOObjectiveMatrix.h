//
//  XOObjectiveMatrix.h
//  XO
//
//  Created by Misha on 08.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@interface XOObjectiveMatrix : NSObject
@property (nonatomic) int dimension;
@property (nonatomic) NSMutableArray *value;
@property (nonatomic, weak) id parrent;
@property (nonatomic) XOPlayer winner;
@property (nonatomic) XOVectorType vectorType;
@property (nonatomic, strong) NSIndexPath *lastMove;

- (BOOL)setPlayer:(XOPlayer)player forIndexPath:(NSIndexPath *)indexPath;
- (XOPlayer)playerForIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)count;
+ (XOObjectiveMatrix *)matrixWithDimension:(int) dimension;

@end
