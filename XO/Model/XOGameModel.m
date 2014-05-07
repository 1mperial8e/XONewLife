//
//  XOGameModel.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOGameModel.h"
#import "GameManager.h"

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
        _dimension = 3;
        [MPManager sharedInstance].delegate = self;
    }
    return self;
}
- (void) clear
{
    _gameColumns = [self gameColumns];
     _gameFieldMatrix = [XOMatrix matrixWithDimension:_gameColumns];
    _xTurn = YES;
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
- (void)setGameMode:(XOGameMode)gameMode
{
    _gameMode = gameMode;
    _player = XOPlayerFirst;
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
    if (_gameMode == XOGameModeMultiplayer)
    {
            int value = _player?-1:1;
            if ([_gameFieldMatrix setValue:value forIndexPath:indexPath]) {
                if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
                    [_delegate didChangeValue:value forIndexPath:indexPath];
                }
                _player= _player ? XOPlayerFirst : XOPlayerSecond;
            }
        NSLog(@"%@", _gameFieldMatrix);
    }
    else if (_gameMode == XOGameModeOnline)
    {
        if (!_player) {
            if ([_gameFieldMatrix setValue:1 forIndexPath:indexPath]) {
                if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
                    [_delegate didChangeValue:1 forIndexPath:indexPath];
                }
                _player=XOPlayerSecond;
                [[MPManager sharedInstance] sendPlayerMyMessage:[NSString stringWithFormat:@"X%i%i", indexPath.row, indexPath.section]];
            }
        }
    }
    else if (_gameMode == XOGameModeSingle)
    {
        if (!_player) {
            if ([_gameFieldMatrix setValue:1 forIndexPath:indexPath]) {
                if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
                    [_delegate didChangeValue:1 forIndexPath:indexPath];
                }
                _player=XOPlayerSecond;
            }
        }
    }
}
- (void)setMoveForIndexPath:(NSIndexPath *)indexPath
{
    if ([_gameFieldMatrix setValue:-1 forIndexPath:indexPath]) {
        if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
            [_delegate didChangeValue:-1 forIndexPath:indexPath];
        }
        _player=XOPlayerFirst;
    }
}
- (void)willChangeValueforIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - Game Delegate
- (void)didReceiveMessage:(NSString *)symbol :(NSString *)coords
{
    int row = [[coords substringToIndex:1] intValue];
    int section = [[coords substringFromIndex:1] intValue];
    [self setMoveForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

- (void)whoTurnFirst:(int)opponentRoll{
    if (opponentRoll==[GameManager sharedInstance].myRoll) {
        [[GameManager sharedInstance] tryToBeFirst];
        return;
    }
    else if (opponentRoll>[GameManager sharedInstance].myRoll) {
        self.player=XOPlayerSecond;
    }
    else{
        self.player=XOPlayerFirst;
    }
}

@end
