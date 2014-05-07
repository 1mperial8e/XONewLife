//
//  XOMatrix.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//
typedef enum {
    XOVectorTypeHorisontal,
    XOVectorTypeVertical,
    XOVectorTypeDiagonalLeft,
    XOVectorTypeDiagonalRight
    
} XOVectorType;
#import "XOMatrix.h"
@interface Vector : NSObject
@property (nonatomic) int **matrix;
@property (nonatomic, readonly) int *horisontalVector;
@property (nonatomic) int *verticalVector;
@property (nonatomic) int *leftDiagonalVector;
@property (nonatomic) int *rightDiagonalVector;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, readonly) int dimension;

+ (Vector *)vectorWithMatrix:(int **)matrix indexPath:(NSIndexPath *)indexPath;
@end
@implementation Vector
@synthesize dimension;
@synthesize horisontalVector = _horisontalVector;
@synthesize verticalVector = _verticalVector;
@synthesize leftDiagonalVector = _leftDiagonalVector;
@synthesize rightDiagonalVector = _rightDiagonalVector;

#pragma mark - Custom Accsessors

- (id)initWithMatrix:(int **)matrix andIndexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self) {
        _matrix = matrix;
        _indexPath = indexPath;
        _horisontalVector = [self horisontalVector];
        _verticalVector = [self verticalVector];
    }
    return self;
}
- (int *)horisontalVector
{
    if (!_horisontalVector) {
    _horisontalVector = calloc(dimension, sizeof(int));
    for (int i=0; i<dimension; i++) {
        _horisontalVector[i] = _matrix[_indexPath.row][i];
    }
    }
    return _horisontalVector;
}
- (int *)verticalVector
{
    _verticalVector = calloc(dimension, sizeof(int));
    for (int i=0; i<dimension; i++) {
        _verticalVector[i] = _matrix[i][_indexPath.section];
    }
    return _verticalVector;
}
- (int)dimension
{
    return sizeof(_matrix)/sizeof(_matrix[0]);
}
- (int)count:(XOVectorType)type
{
    int result = 0;
    switch (type) {
        case XOVectorTypeHorisontal:
            result = sizeof(_horisontalVector)/sizeof(_horisontalVector[0]);
            break;
        case XOVectorTypeVertical:
            result = sizeof(_verticalVector)/sizeof(_verticalVector[0]);
            break;
        case XOVectorTypeDiagonalLeft:
            result = sizeof(_leftDiagonalVector)/sizeof(_leftDiagonalVector[0]);
            break;
        case XOVectorTypeDiagonalRight:
            result = sizeof(_rightDiagonalVector)/sizeof(_rightDiagonalVector[0]);
        default:
            result = NSNotFound;
            break;
    }
    return result;
}
- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"Horisontal: ┃\t"];
    for (int i=0; i<[self count:XOVectorTypeHorisontal]; i++) {
        [result appendString:[NSString stringWithFormat:@"%i\t", _horisontalVector[i]]];
    }
    [result appendString:@"┃\nVertical: ┃\t"];
    for (int i=0; i<[self count:XOVectorTypeVertical]; i++) {
        [result appendString:[NSString stringWithFormat:@"%i\t", _verticalVector[i]]];
    }
    [result appendString:@"┃"];
    return result;
}
#pragma mark - Class Methods
+ (Vector *)vectorWithMatrix:(int **)matrix indexPath:(NSIndexPath *)indexPath
{
    Vector *vector = [[Vector alloc] initWithMatrix:matrix andIndexPath:indexPath];
    return vector;
}
@end

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
        //Vector *v = [Vector vectorWithMatrix:_value indexPath:indexPath];
        //NSLog(@"%@", v);
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
