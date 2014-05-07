//
//  XOMatrix.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOMatrix.h"

@implementation XOMatrix

- (int)checkMatrix
{
    return 0;
}
- (BOOL)checkMatrixForIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (id) initWithDimension:(int)dimension
{
    self = [super init];
    if (self) {
        _dimension = dimension;
        [self configureMatrix];
        self.vectorValue = calloc((_dimension*_dimension), sizeof(int));
        if (_minComb) {
            _minComb = _dimension;
        }
    }
    return self;
}
- (void)setVectorValue:(int *)vectorValue
{
    self->_vectorValue = vectorValue;
    for (int i = 0; i<_dimension; i++) {
        for (int j = 0; j<_dimension; j++) {
            _value[i][j] = vectorValue[(_dimension*i)+j];
        }
    }
}
- (void) configureMatrix
{
    _value = calloc(_dimension, sizeof(int));//(_dimension*sizeof(int));
    for(int i = 0; i < _dimension; i++) {
        _value[i] = calloc(_dimension , sizeof(int));
        for (int j = 0; j<_dimension; j++) {
            _aValue[i][j] = [NSNumber numberWithInt:0];
        }
    }
}
- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] init];
       for (int i = 0; i<_dimension; i++) {
        [result appendString:@"\n┃"];
        for (int j=0; j<_dimension; j++) {
            [result appendString:[NSString stringWithFormat:@"\t%i", _value[i][j]]];
        }
        [result appendString:@"\t┃"];
    }
    return result;
}
#pragma mark - Public
- (BOOL)setValue:(int)value forIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
    if (![self valueForIndexPath:indexPath]) {
        _value[indexPath.section][indexPath.row] = value;
        return YES;
    }
    return NO;
}
- (int)valueForIndexPath:(NSIndexPath *)indexPath
{
    return _value[indexPath.section][indexPath.row];
}
#pragma mark - Class Methods
+ (XOMatrix *)matrixWithDimension:(int)dimension
{
    XOMatrix *matrix = [[XOMatrix alloc] initWithDimension:dimension];
    return matrix;
}
@end
