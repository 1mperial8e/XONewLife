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
    return ![self checkRow:indexPath];
}
- (int)checkRow:(NSIndexPath *)indexPath
{
    int result = 0;
//    int x0 = _dimension-_minComb-indexPath.row;
//    int length = (_dimension-(_minComb*2)-1);
//    int xn = x0+length;
//    
//    int *searchField = calloc(xn-x0, sizeof(int));
//    for (int i = x0; i<length; i++) {
//        searchField[i] = _value[indexPath.section][i];
//    }
//    int pointer = 0;
//    for (int i = pointer; i<_minComb+pointer; i++) {
//        result+=searchField[i];
//        if (fabs(result)>=_minComb) {
//            return result;
//        }
//        if (i+1==_minComb+pointer && pointer+_minComb<length)
//        {
//            pointer++;
//            result = 0;
//        }
//    }
    
    return result;
}
- (int)sumSection:(int **)matrix sect:(int)sect
{
    int result;
    for (int i = 0; i < _dimension; i++) {
        result+=matrix[i][sect];
    }
    return result;
}
/*- (int)sumDiag3r:(int **)matrix
{
    
}*/
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
        /*for (int j = 0; j<_dimension; j++) {
            _matrix[i][j] = 0;
        }*/
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
- (void) setValue:(int)value forPoint:(CGPoint)point
{
    _value[(int)point.x][(int)point.y] = value;
}
- (void)setValue:(int)value forAbscys:(int)abscys andOrdinat:(int)ordinat
{
    _value[abscys][ordinat] = value;
}
- (BOOL)setValue:(int)value forIndexPath:(NSIndexPath *)indexPath
{
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
