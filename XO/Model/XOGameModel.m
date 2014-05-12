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
#import "XOAI.h"

@interface XOGameModel () <UIAlertViewDelegate>
@property (nonatomic, strong) NSIndexPath *lastMove;
@end
@implementation XOGameModel
@synthesize gameColumns = _gameColumns;
@synthesize matrix;
#pragma mark - Static
static XOGameModel *_instance=Nil;
#pragma mark - Lifecicle
- (id)init
{
    self = [super init];
    if (self) {
        _gameColumns = [self gameColumns];
        _dimension = 3;
        [MPManager sharedInstance].delegate = self;
    }
    return self;
}
- (void) clear
{
    _gameColumns = [self gameColumns];
    matrix = [XOObjectiveMatrix matrixWithDimension:_gameColumns];
    matrix.parrent = self;
    _player = XOPlayerNone;
}
- (void) newGame: (NSTimer *)timer
{
    if ([[[timer userInfo] valueForKey:@"time"] intValue] == 0) {
        _player = _player*-1;
        //_player = _me;
       // _me = _me*-1;
        matrix = [XOObjectiveMatrix matrixWithDimension:_gameColumns];
        matrix.parrent = self;
        NSLog(@"%@", matrix);
        [((UIAlertView *)[timer.userInfo valueForKey:@"alert"]) dismissWithClickedButtonIndex:0 animated:YES];
        if ([_delegate respondsToSelector:@selector(reload)]) {
            [_delegate reload];
        }
        if ([_victoryDelegate respondsToSelector:@selector(drawVector:atLine:)]) {
            [_victoryDelegate drawVector:NSNotFound atLine:NSNotFound];
        }
        [timer invalidate];
        
    } else {
        int t = [[timer.userInfo valueForKey:@"time"] intValue]-1;
        [timer.userInfo setValue:[NSNumber numberWithInt:t] forKey:@"time"];
        ((UIAlertView *)[timer.userInfo valueForKey:@"alert"]).message = [NSString stringWithFormat:@"New game through %is", [[timer.userInfo objectForKey:@"time"] intValue]];
    }
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
    matrix = [XOObjectiveMatrix matrixWithDimension:gColumns];
    matrix.parrent = self;
}
- (void)setGameMode:(XOGameMode)gameMode
{
    _gameMode = gameMode;
}
- (void)setWinner:(XOPlayer)winner
{
    //_player = XOPlayerNone;
    _winner = winner;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_me==_winner?@"You win!":@"Player 2 win!" message:@"New game through 3s" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"time":@3, @"alert":alertView}];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(newGame:) userInfo:dict repeats:YES];
    [alertView show];
    if ([_timerDelegate respondsToSelector:@selector(stopTimer)])
    {
        [_timerDelegate stopTimer];
    }
    if ([_victoryDelegate respondsToSelector:@selector(drawVector:atLine:)]) {
            [_victoryDelegate drawVector:matrix.vectorType atLine:matrix.vectorType == XOVectorTypeVertical?(int)matrix.lastMove.row:(int)matrix.lastMove.section];
    }
    [self victory];
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
            int value = _player;
            if ([matrix setPlayer:_player forIndexPath:indexPath]) {
                _player = _player==XOPlayerNone?XOPlayerNone:_player*-1;
                if ([_timerDelegate respondsToSelector:@selector(resetTimer)]) {
                    [_timerDelegate resetTimer];
                }
                if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
                    [_delegate didChangeValue:value forIndexPath:indexPath];
                }
                if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
                    [_playersTurnDelegate nowTurn:_player];
                }
                if (_player==XOPlayerFirst) {
                    [[SoundManager sharedInstance] playOTurnSound];
                }
                else{
                    [[SoundManager sharedInstance] playXTurnSound];
                }
            }
    }
    else if (_gameMode == XOGameModeOnline)
    {
        if (_player == _me) {
            if ([matrix setPlayer:_me forIndexPath:indexPath]) {
                if ([_timerDelegate respondsToSelector:@selector(resetTimer)]) {
                    [_timerDelegate resetTimer];
                }
                if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
                    [_delegate didChangeValue:_me forIndexPath:indexPath];
                }
                _player=_me*-1;
                if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowMyTurn:)])) {
                [_playersTurnDelegate nowMyTurn:NO];
                }
                [[SoundManager sharedInstance] playXOSoundFor:_me];
                [[MPManager sharedInstance] sendPlayerMyMessage:[NSString stringWithFormat:@"%i%i", (int)indexPath.section, (int)indexPath.row]];
            }
        }
        NSLog(@"%@", matrix);
    }
    else if (_gameMode == XOGameModeSingle)
    {
        int value = _player;
        if (_player==_me) {
            if ([matrix setPlayer:value forIndexPath:indexPath]) {
                if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
                    [_delegate didChangeValue:value forIndexPath:indexPath];
                }
                _player=_me*-1;
                 [[SoundManager sharedInstance] playXOSoundFor:value];
            }
            XOAI *ai = [XOAI new];
            [ai moveWithTimer:2];
            
        } else if (_player&&!_winner){
            //XOAI *ai = [XOAI new];
            //NSIndexPath *aiMove = [ai makeMove];
            if ([matrix setPlayer:value forIndexPath:indexPath]) {
                if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
                    [_delegate didChangeValue:value forIndexPath:indexPath];
                }
                _player=_player*-1;
                [[SoundManager sharedInstance] playXOSoundFor:value];
            }
        }
       // NSLog(@"%@", matrix);
    }
    
}
- (void)setMoveForIndexPath:(NSIndexPath *)indexPath
{
    int value = _player;
    if ([matrix setPlayer:_player forIndexPath:indexPath]) {
        if ([_timerDelegate respondsToSelector:@selector(resetTimer)]) {
            [_timerDelegate resetTimer];
        }
        if ([_delegate respondsToSelector:@selector(didChangeValue:forIndexPath:)]) {
            [_delegate didChangeValue:value forIndexPath:indexPath];
        }
        if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowMyTurn:)])) {
                 [_playersTurnDelegate nowMyTurn:YES];
        }
       _player=_player*-1;        
        //[[SoundManager sharedInstance] playOTurnSound];
        [[SoundManager sharedInstance] playXOSoundFor:value];
    }
}
- (void)willChangeValueforIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) victory
{
    NSLog(@"victory");
    [self.delegate playerWin:_winner];
    [[GameManager sharedInstance].progress updateProgress:[GameManager sharedInstance].mode forPlayer:_winner];
    //[self clear];
    //_winner=XOPlayerNone;
}

#pragma mark - Game Delegate
- (void)didReceiveMessage:(NSString *)coords
{
    if (![MPManager sharedInstance].firstMessage) {
    int section = [[coords substringToIndex:1] intValue];
    int row = [[coords substringFromIndex:1] intValue];
    [self setMoveForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
}

- (void)whoTurnFirst:(int)opponentRoll{
    if (opponentRoll==[GameManager sharedInstance].myRoll) {
        [MPManager sharedInstance].firstMessage=YES;
        [[GameManager sharedInstance] tryToBeFirst];
        return;
    }
    else if (opponentRoll>[GameManager sharedInstance].myRoll) {
        self.player=XOPlayerFirst;
        if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
            //[_playersTurnDelegate nowTurn:XOPlayerFirst];
            [_playersTurnDelegate nowMyTurn:NO];
            self.me = XOPlayerSecond;
        }
    }
    else{
        if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
            //[_playersTurnDelegate nowTurn:XOPlayerFirst];
            [_playersTurnDelegate nowMyTurn:YES];
            self.me = XOPlayerFirst;
        }
    }
    self.player = XOPlayerFirst;
}

@end
