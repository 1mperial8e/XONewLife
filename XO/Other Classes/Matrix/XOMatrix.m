//
//  XOMatrix.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//
typedef enum {
    MatrixValueFirs = -1,
    MatrixValueSecond = 1,
    MatrixValueNon = 0
} MatrixValue;
#import "XOMatrix.h"
#import "Constants.h"
@interface Vector : NSObject
@property (nonatomic) int **matrix;
@property (nonatomic, readonly) int *horisontalVector;
@property (nonatomic, readonly) int *verticalVector;
@property (nonatomic, readonly) int *leftDiagonalVector;
@property (nonatomic, readonly) int *rightDiagonalVector;
@property (nonatomic) int comb;
@property (nonatomic) CGPoint point1;
@property (nonatomic) CGPoint point2;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, readonly, getter = dimension) int dimension;

+ (Vector *)vectorWithMatrix:(int **)matrix indexPath:(NSIndexPath *)indexPath;
@end
@implementation Vector
@synthesize dimension;
@synthesize horisontalVector = _horisontalVector;
@synthesize verticalVector = _verticalVector;
@synthesize leftDiagonalVector = _leftDiagonalVector;
@synthesize rightDiagonalVector = _rightDiagonalVector;
int leftDiagonalVectorSize;
int rightDiagonalVectorSize;
#pragma mark - Custom Accsessors
#define LEN(x)  (sizeof(x) / sizeof(x[0]))
- (id)initWithMatrix:(int **)matrix andIndexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self) {
        _matrix = matrix;
        _indexPath = indexPath;
        _horisontalVector = [self horisontalVector];
        _verticalVector = [self verticalVector];
        _leftDiagonalVector = [self leftDiagonalVector];
        _comb=_comb?_comb:[self dimension];
    }
    return self;
}
- (int *)horisontalVector
{
    if (!_horisontalVector) {
    _horisontalVector = calloc(dimension, sizeof(int));
        for (int i=0; i<[self dimension]; i++) {
            _horisontalVector[i] = _matrix[_indexPath.section][i];
        }
    }
        return _horisontalVector;
}

- (int *)verticalVector
{
    _verticalVector = calloc(dimension, sizeof(int));
    for (int i=0; i<[self dimension]; i++) {
        _verticalVector[i] = _matrix[i][_indexPath.row];
    }
    
    return _verticalVector;
}
- (int *)leftDiagonalVector
{
    int comb = [self dimension];
    int r0 = _indexPath.section, c0 = _indexPath.row, cm = comb-1, rm = comb-1;
    if (_indexPath.section-_indexPath.row > 0&&_indexPath.row) {
        r0=_indexPath.section-_indexPath.row;
        c0=0;
    } else if (_indexPath.section-_indexPath.row < 0&&_indexPath.row) {
        c0=_indexPath.row-_indexPath.section;
        r0 = 0;
    } else if (_indexPath.section-_indexPath.row == 0)
    {
        r0=0;
        c0=0;
    }
    if (_indexPath.section==comb||_indexPath.row == comb) {
        cm = _indexPath.section;
        rm = _indexPath.row;
    } else if (_indexPath.row>_indexPath.section) {
        rm =comb-1;
        cm =comb-r0-1;
    } else if (_indexPath.row<_indexPath.section) {
        cm = comb-1;
        rm = comb-c0-1;
    }
    leftDiagonalVectorSize = r0>c0?comb-r0:comb-c0;
    if (leftDiagonalVectorSize <comb)
        return 0;
    _leftDiagonalVector = calloc(leftDiagonalVectorSize, sizeof(int));
    int i = 0;
    while (c0!=[self dimension]&&r0!=[self dimension]) {
        _leftDiagonalVector[i] = _matrix[r0][c0];
        c0++;
        r0++;
        i++;
}
    return _leftDiagonalVector;
}
- (int *)rightDiagonalVector
{
    _rightDiagonalVector = calloc(3, sizeof(int));
    int comb = [self dimension];
    int **a = calloc(comb, sizeof(int));
    for (int i = 0; i<comb; i++) {
        a[i] = calloc(comb, sizeof(int));
        for (int j = comb-1; j>=0; j--) {
            a[i][(comb-1)-j]= _matrix[i][j];
        }
    }
    if (_indexPath.row == _indexPath.section)
    {
        for (int i = 0; i<comb; i++) {
            for (int j =0; j<comb; j++) {
                _rightDiagonalVector[i] = _matrix[i][j];
            }
        }
    } else {
            _rightDiagonalVector = nil;
    }
    rightDiagonalVectorSize = 3;
//    int r0 = _indexPath.section, c0 = _indexPath.row, cm = comb-1, rm = comb-1;
//    if (_indexPath.section-_indexPath.row > 0&&_indexPath.row) {
//        r0=_indexPath.section-_indexPath.row;
//        c0=0;
//    } else if (_indexPath.section-_indexPath.row < 0&&_indexPath.row) {
//        c0=_indexPath.row-_indexPath.section;
//        r0 = 0;
//    } else if (_indexPath.section-_indexPath.row == 0)
//    {
//        r0=0;
//        c0=0;
//    }
//    if (_indexPath.section==comb||_indexPath.row == comb) {
//        cm = _indexPath.section;
//        rm = _indexPath.row;
//    } else if (_indexPath.row>_indexPath.section) {
//        rm =comb-1;
//        cm =comb-r0-1;
//    } else if (_indexPath.row<_indexPath.section) {
//        cm = comb-1;
//        rm = comb-c0-1;
//    }
//    rightDiagonalVectorSize = r0>c0?comb-r0:comb-c0;
//    if (rightDiagonalVectorSize <comb)
//        return 0;
//    _rightDiagonalVector = calloc(rightDiagonalVectorSize, sizeof(int));
//    int i = 0;
//    while (c0!=[self dimension]&&r0!=[self dimension]) {
//        _rightDiagonalVector[i] = a[r0][c0];
//        c0++;
//        r0++;
//        i++;
//    }
    return _rightDiagonalVector;
}
- (int)dimension
{
    return sizeof(_matrix)-1;
}
- (int)count:(XOVectorType)type
{
    int result = 0;
    switch (type) {
        case XOVectorTypeHorisontal:
            result = sizeof(_horisontalVector)-1;
            break;
        case XOVectorTypeVertical:
            result = sizeof(_verticalVector)-1;
            break;
        case XOVectorTypeDiagonalLeft:
            result = leftDiagonalVectorSize;//LEN(_leftDiagonalVector);
            break;
        case XOVectorTypeDiagonalRight:
            result = rightDiagonalVectorSize;
        default:
            result = NSNotFound;
            break;
    }
    return result;
}
- (int)sum:(XOVectorType)type
{
    int result = 0;
    switch (type) {
        case XOVectorTypeHorisontal:
            for (int i = 0; i<sizeof(_horisontalVector)-1; i++) {
                result+= _horisontalVector[i];
            }
            break;
        case XOVectorTypeVertical:
            for (int i = 0; i<sizeof(_verticalVector)-1; i++) {
                result+= _verticalVector[i];
            }
            break;
        case XOVectorTypeDiagonalLeft:
            for (int i = 0; i<leftDiagonalVectorSize; i++) {
                result+= _leftDiagonalVector[i];
            }
            //result = leftDiagonalVectorSize;//LEN(_leftDiagonalVector);
            break;
        case XOVectorTypeDiagonalRight:
            for (int i = 0; i<rightDiagonalVectorSize; i++) {
                result+= _rightDiagonalVector[i];
            }
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
    [result appendString:@"┃\nLeftDiagonal:┃\t"];
    for (int i=0; i<[self count:XOVectorTypeDiagonalLeft]&&_leftDiagonalVector; i++) {
        [result appendString:[NSString stringWithFormat:@"%i\t", _leftDiagonalVector[i]]];
    }
    [result appendString:@"┃\nRightDiagonal:┃\t"];
    for (int i=0; i<rightDiagonalVectorSize&&_rightDiagonalVector; i++) {
        int p =[self count:XOVectorTypeDiagonalRight];
        [result appendString:[NSString stringWithFormat:@"%i\t", _rightDiagonalVector[i]]];
    }
    [result appendString:@"┃\n"];
    return result;
}

- (void)dealloc
{
    free(_horisontalVector);
    free(_verticalVector);
    //free(_matrix);
    free(_leftDiagonalVector);
    free(_rightDiagonalVector);
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
            NSLog(@"XOVectorTypeVertical");
        } else if  (fabs([self sum:XOVectorTypeVertical indexPath:indexPath])>2) {
            NSLog(@"XOVectorTypeHorisontal");
        } else if (fabs([self sum:XOVectorTypeDiagonalLeft indexPath:indexPath])>2) {
            NSLog(@"XOVectorTypeDiagonalLeft");
        } else if (fabs([self sum:XOVectorTypeDiagonalRight indexPath:indexPath])>2) {
            NSLog(@"XOVectorTypeDiagonalRight");
        }
        return YES;
    }
    return NO;
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
#pragma mark - Class Methods
+ (XOMatrix *)matrixWithDimension:(int)dimension
{
    XOMatrix *matrix = [[XOMatrix alloc] initWithDimension:dimension];
    return matrix;
}
@end
