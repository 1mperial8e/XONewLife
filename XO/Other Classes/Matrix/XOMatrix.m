//
//  XOMatrix.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOMatrix.h"
#import "Constants.h"


#pragma mark - Matrix
@implementation XOMatrix

- (int)checkMatrix
{
    return 0;
}
- (BOOL)checkMatrixForIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
#pragma mark - Math Matrix
- (int *)getVectorIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
            _value[i][j] = vectorValue[(_dimension*i)+j]? vectorValue[(_dimension*i)+j]: MatrixValueNon;
        }
    }
}
- (void) configureMatrix
{
    _value = calloc(_dimension, sizeof(int));//(_dimension*sizeof(int));
    for(int i = 0; i < _dimension; i++) {
        _value[i] = calloc(_dimension , sizeof(int));
        for (int j = 0; j<_dimension; j++) {
            _value[i][j] = MatrixValueNon;
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
    //NSLog(@"%@", indexPath);
    

    if ([self valueForIndexPath:indexPath]==MatrixValueNon) {
         _value[indexPath.section][indexPath.row] = value;
        if (fabs([self sum:XOVectorTypeHorisontal indexPath:indexPath])>2) {
            self.winner = [self sum:XOVectorTypeHorisontal indexPath:indexPath]/3;
            self.vectorType = XOVectorTypeHorisontal;
            NSLog(@"XOVectorTypeVertical");
        } else if  (fabs([self sum:XOVectorTypeVertical indexPath:indexPath])>2) {
            self.winner = [self sum:XOVectorTypeVertical indexPath:indexPath]/3;
            self.vectorType = XOVectorTypeVertical;
            NSLog(@"XOVectorTypeHorisontal");
        } else if (fabs([self sum:XOVectorTypeDiagonalLeft indexPath:indexPath])>2) {
            self.winner = [self sum:XOVectorTypeDiagonalLeft indexPath:indexPath]/3;
            self.vectorType = XOVectorTypeDiagonalLeft;
            NSLog(@"XOVectorTypeDiagonalLeft");
        } else if (fabs([self sum:XOVectorTypeDiagonalRight indexPath:indexPath])>2) {
            self.winner = [self sum:XOVectorTypeDiagonalRight indexPath:indexPath]/3;
            self.vectorType = XOVectorTypeDiagonalRight;
            NSLog(@"XOVectorTypeDiagonalRight");
        }
        return YES;
    }
    return NO;
}
- (NSDictionary *)setTurnValue:(int)value forIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *result;
    if ([self valueForIndexPath:indexPath]==MatrixValueNon) {
        _value[indexPath.section][indexPath.row] = value;
        if (fabs([self sum:XOVectorTypeHorisontal indexPath:indexPath])>2) {
            [result setValue:[NSNumber numberWithInt:[self sum:XOVectorTypeHorisontal indexPath:indexPath]/3] forKey:@"win"];
            [result setValue:[NSNumber numberWithInt:XOVectorTypeHorisontal] forKey:@"vType"];
        } else if  (fabs([self sum:XOVectorTypeVertical indexPath:indexPath])>2) {
            [result setValue:[NSNumber numberWithInt:[self sum:XOVectorTypeVertical indexPath:indexPath]/3] forKey:@"win"];
            [result setValue:[NSNumber numberWithInt:XOVectorTypeVertical] forKey:@"vType"];
        } else if (fabs([self sum:XOVectorTypeDiagonalLeft indexPath:indexPath])>2) {
            [result setValue:[NSNumber numberWithInt:[self sum:XOVectorTypeDiagonalLeft indexPath:indexPath]/3] forKey:@"win"];
            [result setValue:[NSNumber numberWithInt:XOVectorTypeDiagonalLeft] forKey:@"vType"];
        } else if (fabs([self sum:XOVectorTypeDiagonalRight indexPath:indexPath])>2) {
            [result setValue:[NSNumber numberWithInt:[self sum:XOVectorTypeDiagonalRight indexPath:indexPath]/3] forKey:@"win"];
            [result setValue:[NSNumber numberWithInt:XOVectorTypeDiagonalRight] forKey:@"vType"];
        }
    }
    return [NSDictionary dictionaryWithDictionary: result];
}
- (int)sum:(XOVectorType)type indexPath:(NSIndexPath *)indexPath
{
    int result = 0;
    switch (type) {
        case XOVectorTypeHorisontal:
            for (int i = 0; i<3; i++) {
                result+= _value[indexPath.section][i];
            }
            break;
        case XOVectorTypeVertical:
            for (int i = 0; i<3; i++) {
                result+= _value[i][indexPath.row];
            }
            break;
        case XOVectorTypeDiagonalLeft:
            for (int i = 0; i<3; i++) {
                    result+=_value[i][i];
            }
            break;
        case XOVectorTypeDiagonalRight:
            for (int i = 0; i<3; i++) {
                result+=_value[i][2-i];
            }
            break;
        default:
            result = NSNotFound;
            break;
    }
    return result;
}
- (int)valueForIndexPath:(NSIndexPath *)indexPath
{
      return _value[indexPath.section][indexPath.row];
}
- (void) dealloc
{
    free(_value);
    free(_vectorValue);
    
}
#pragma mark - Class Methods
+ (XOMatrix *)matrixWithDimension:(int)dimension
{
    XOMatrix *matrix = [[XOMatrix alloc] initWithDimension:dimension];
    return matrix;
}
@end
