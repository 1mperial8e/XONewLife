//
//  XOOMatrix.m
//  XO
//
//  Created by Misha on 06.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOOMatrix.h"

@implementation XOOMatrix
- (id) initWithDimension:(int)dimension
{
    self = [super init];
    if (self) {
        _dimension = dimension;
        self.vectorValue = calloc((_dimension*_dimension), sizeof(int));
        if (_minComb) {
            _minComb = _dimension;
        }
    }
    return self;
}
@end
