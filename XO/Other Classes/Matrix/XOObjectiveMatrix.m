//
//  XOObjectiveMatrix.m
//  XO
//
//  Created by Misha on 08.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOObjectiveMatrix.h"

@implementation XOObjectiveMatrix
#pragma mark - Lifecicle
- (id)init
{
    self = [super init];
    if (self) {
        _value = [NSMutableArray new];
    }
    return self;
}
- (void)setDimension:(int)dimension
{
    _dimension = dimension;
    for (int i = 0; i<dimension; i++) {
        //_value[i] = [[NSMutableArray alloc] initWithCapacity:dimension];
        [_value addObject:[[NSMutableArray alloc] initWithCapacity:dimension]];
        for (int j = 0; j<dimension; j++) {
            [_value[i] addObject:@0];
        }
    }
}
- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:[NSString stringWithFormat:@"XOObjectiveMatrix:\nDimention: %i\nValue:", _dimension]];
    for (int i = 0; i<_dimension; i++) {
        [result appendString:@"\n┃\t"];
        for (int j = 0; j < _dimension; j++) {
            [result appendString:[NSString stringWithFormat:@"%@\t", _value[i][j]]];
        }
        [result appendString:@"┃"];
    }
    return result;
}
- (void)dealloc{
    
}
#pragma mark - Private
- (int)vecrorSumByType:(XOVectorType)type indexPath:(NSIndexPath *)indexPath
{
    int result = 0;
    switch (type) {
        case XOVectorTypeHorisontal:
            for (int i = 0; i<_dimension; i++) {
                result+= [_value[indexPath.section][i] intValue];
            }
            break;
        case XOVectorTypeVertical:
            for (int i = 0; i<_dimension; i++) {
                result+= [_value[i][indexPath.row] intValue];
            }
            break;
        case XOVectorTypeDiagonalLeft:
            for (int i = 0; i<_dimension; i++) {
                result+=[_value[i][i] intValue];
            }
            break;
        case XOVectorTypeDiagonalRight:
            for (int i = 0; i<_dimension; i++) {
                result+=[_value[i][(_dimension-1)-i] intValue];
            }
            break;
        default:
            result = NSNotFound;
            break;
    }
    return result;
}
 - (int)movesLeft
{
    int result = 0;
    for (int i = 0; i<_dimension; i++) {
        for (int j = 0; j<_dimension; j++) {
            if ([_value[j][i] intValue]==XOPlayerNone)
            result ++;
        }
    }
    return result;
}
#pragma mark - Public
- (BOOL)setPlayer:(XOPlayer)player forIndexPath:(NSIndexPath *)indexPath
{
    if ([_value[indexPath.section][indexPath.row] intValue]==XOPlayerNone&&!_winner) {
        _value[indexPath.section][indexPath.row] = [NSNumber numberWithInt:player];
        [self checkWinners:indexPath];
        return YES;
    }
    return NO;
}
- (XOPlayer)playerForIndexPath:(NSIndexPath *)indexPath
{
    return [_value[indexPath.section][indexPath.row] intValue];
}
- (NSUInteger)count
{
    return [_value count];
}
- (void)checkWinners:(NSIndexPath *)indexPath
{
    int horisontal = [self vecrorSumByType:XOVectorTypeHorisontal indexPath:indexPath];
    int vertical = [self vecrorSumByType:XOVectorTypeVertical indexPath:indexPath];
    int diagL = [self vecrorSumByType:XOVectorTypeDiagonalLeft indexPath:indexPath];
    int diagR = [self vecrorSumByType:XOVectorTypeDiagonalRight indexPath:indexPath];
    
    if (fabs(horisontal)>=_dimension) {
        _winner = horisontal/_dimension;
        _vectorType = XOVectorTypeHorisontal;
    } else if (fabs(vertical)>=_dimension) {
        _winner = vertical/_dimension;
        _vectorType = XOVectorTypeVertical;
    } else if (fabs(diagL)>=_dimension) {
        _winner = diagL/_dimension;
        _vectorType = XOVectorTypeDiagonalLeft;
    } else if (fabs(diagR)>=_dimension) {
        _winner = diagR/_dimension;
        _vectorType = XOVectorTypeDiagonalRight;
    }
    if (_winner) {
        if ([_parrent respondsToSelector:@selector(setWinner:)]) {
            _lastMove = indexPath;
            [_parrent setWinner:_winner];
        }
    } else if (![self movesLeft]) {
        if ([_parrent respondsToSelector:@selector(setWinner:)]) {
            [_parrent setWinner:XOPlayerNone];
        }
    }
    
}
#pragma mark - Class Methods
+ (XOObjectiveMatrix *)matrixWithDimension:(int) dimension
{
    XOObjectiveMatrix *result = [XOObjectiveMatrix new];
    result.dimension = dimension;
    return result;
}
@end
