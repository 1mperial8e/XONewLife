//
//  XOGameModel.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOGameModel.h"
#import "GameManager.h"
#import "SoundManager.h"

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
    _player = XOPlayerNone;
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
}
- (void)setWinner:(XOPlayer)winner
{
    _player = XOPlayerNone;
    _winner = winner;
    if ([_timerDelegate respondsToSelector:@selector(stopTimer)])
    {
        [_timerDelegate stopTimer];
    }
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
            //int value = _player?-1:1;
            if ([_gameFieldMatrix setValue:_player forIndexPath:indexPath]) {
                if ([_timerDelegate respondsToSelector:@selector(resetTimer)]) {
                    [_timerDelegate resetTimer];
                }
                if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
                    [_delegate didChangeValue:_player forIndexPath:indexPath];
                }
                _player= _player *-1;
                if (_gameFieldMatrix.winner) {
                    if ([_victoryDelegate respondsToSelector:@selector(drawVector:atLine:)]) {
                        [_victoryDelegate drawVector:_gameFieldMatrix.vectorType atLine:indexPath.row];
                        self.winner = _gameFieldMatrix.winner;
                        _gameFieldMatrix.winner =XOPlayerNone;
                        _player = XOPlayerNone;
                    }
                    if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
                        [_playersTurnDelegate nowTurn:_player];
                    }
                }
                if (_player==XOPlayerFirst) {
                    [[SoundManager sharedInstance] playOTurnSound];
                }
                else{
                    [[SoundManager sharedInstance] playXTurnSound];
                }
            }
        //NSLog(@"%@", _gameFieldMatrix);
    }
    else if (_gameMode == XOGameModeOnline)
    {
        if (_player == XOPlayerFirst) {
            if ([_gameFieldMatrix setValue:-1 forIndexPath:indexPath]) {
                if ([_timerDelegate respondsToSelector:@selector(resetTimer)]) {
                    [_timerDelegate resetTimer];
                }
                if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
                    [_delegate didChangeValue:1 forIndexPath:indexPath];
                }
                _player=XOPlayerSecond;
                if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
                [_playersTurnDelegate nowTurn:XOPlayerSecond];
                }
                [[SoundManager sharedInstance] playXTurnSound];
                [[MPManager sharedInstance] sendPlayerMyMessage:[NSString stringWithFormat:@"%i%i", indexPath.row, indexPath.section]];
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
                if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
                [_playersTurnDelegate nowTurn:XOPlayerSecond];
                }
                [[SoundManager sharedInstance] playXTurnSound];
                _player=XOPlayerSecond;
            }
        }
    }
}
- (void)setMoveForIndexPath:(NSIndexPath *)indexPath
{
    if ([_gameFieldMatrix setValue:-1 forIndexPath:indexPath]) {
        if ([_timerDelegate respondsToSelector:@selector(resetTimer)]) {
            [_timerDelegate resetTimer];
        }
        if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
            [_delegate didChangeValue:-1 forIndexPath:indexPath];
        }
        if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
                 [_playersTurnDelegate nowTurn:XOPlayerFirst];
        }
       _player=XOPlayerFirst;
        [[SoundManager sharedInstance] playOTurnSound];
    }
}
- (void)willChangeValueforIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void) victory
{
    NSLog(@"victory");
}
#pragma mark - Game Delegate
- (void)didReceiveMessage:(NSString *)coords
{
    int row = [[coords substringToIndex:1] intValue];
    int section = [[coords substringFromIndex:1] intValue];
    [self setMoveForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

- (void)whoTurnFirst:(int)opponentRoll{
    if (opponentRoll==[GameManager sharedInstance].myRoll) {
        [MPManager sharedInstance].firstMessage=YES;
        [[GameManager sharedInstance] tryToBeFirst];
        return;
    }
    else if (opponentRoll>[GameManager sharedInstance].myRoll) {
        self.player=XOPlayerSecond;
        if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
            [_playersTurnDelegate nowTurn:XOPlayerSecond];
        }
    }
    else{
        self.player=XOPlayerFirst;
        if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
            [_playersTurnDelegate nowTurn:XOPlayerFirst];
        }
    }
}

@end
