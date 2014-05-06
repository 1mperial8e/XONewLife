//
//  XOGameModel.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOGameModel.h"

@interface XOGameModel ()
@end
@implementation XOGameModel
@synthesize gameColumns = _gameColumns;
#pragma mark - Static
static XOGameModel *_instance=Nil;
#pragma mark - Lifecicle
- (id)init
{
    self = [super init];
    if (self) {
        _gameColumns = [self gameColumns];
        _xTurn = YES;
    }
    return self;
}
#pragma mark - Custom Accsesors
- (int) gameColumns
{
    if (!_gameColumns) {
        [self setGameColumns:3];
    }
    return _gameColumns;
}
- (void)setGameColumns:(int)gColumns
{
    _gameColumns = gColumns;
    _gameFieldMatrix = [XOMatrix matrixWithDimension:gColumns];
}
#pragma mark - Class Methods
+ (XOGameModel*)sharedInstance{
    @synchronized(self) {
        if (_instance==nil) {
            _instance=[[self alloc] init];
        }
        return _instance;
    }
}
#pragma mark - GameFieldViewController Delegate
- (void)willChangeValueForIndexPath:(NSIndexPath *)indexPath
{
    int value = _xTurn?1:-1;
//    if (_gameMode == XOGameModeMultiplayer)
//    {
        _xTurn = [_gameFieldMatrix setValue:value forIndexPath:indexPath]?!_xTurn:_xTurn;
        if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
            [_delegate didChangeValue:value forIndexPath:indexPath];
        }
//    } else {
//        
//    }
}
- (void)willChangeValueforIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - Protocol Methods

@end
