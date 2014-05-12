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
@property (nonatomic, strong) UIAlertView *waitingForUser;
@property (nonatomic, strong) UIAlertView *alertForNewGame;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL myTurn;
@end
@implementation XOGameModel
@synthesize gameColumns = _gameColumns;
@synthesize opponentNewGame = _opponentNewGame;
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
    _winner = XOPlayerNone;
}
- (void) newGame: (NSTimer *)timer
{
    if ([[[timer userInfo] valueForKey:@"time"] intValue] == 0) {
        if ([timer.userInfo valueForKey:@"alert"]) {
            [self newGame];
        [((UIAlertView *)[timer.userInfo valueForKey:@"alert"]) dismissWithClickedButtonIndex:0 animated:YES];
        }
        
        [timer invalidate];
        
    } else {
        int t = [[timer.userInfo valueForKey:@"time"] intValue]-1;
        [timer.userInfo setValue:[NSNumber numberWithInt:t] forKey:@"time"];
        if ([timer.userInfo valueForKey:@"alert"]) {
        ((UIAlertView *)[timer.userInfo valueForKey:@"alert"]).message = [NSString stringWithFormat:@"New game through %is", [[timer.userInfo objectForKey:@"time"] intValue]];
        }
    }
}

 - (void)newGame
{
    _winner = XOPlayerNone;
    _player = _player*-1;
    //_player = _me;
    _me = _me*-1;
    matrix = [XOObjectiveMatrix matrixWithDimension:_gameColumns];
    matrix.parrent = self;
    if ([_delegate respondsToSelector:@selector(reload)]) {
        [_delegate reload];
    }
    if ([_victoryDelegate respondsToSelector:@selector(drawVector:atLine:)]) {
        [_victoryDelegate drawVector:NSNotFound  atLine:NSNotFound];
    }
    if (_gameMode == XOGameModeSingle) {
        XOAI *ai = [XOAI new];
        [ai moveWithTimer:1];
    }
    
    
}

#pragma mark - Custom Accsesors
- (void)setGameMode:(XOGameMode)gameMode
{
    _gameMode = gameMode;
    _winner = XOPlayerNone;
}
- (void) setOpponentNewGame:(NewGameMessage)opponentNewGame
{
    _opponentNewGame = opponentNewGame;
    if (_waitingForUser) {
        [_waitingForUser dismissWithClickedButtonIndex:0 animated:YES];
        _waitingForUser = nil;

    }
    switch (opponentNewGame) {
        case NewGameMessageYes:
            [self newGame];
            break;
        case NewGameMessageNo:
            if (_waitingForUser) {
                [_waitingForUser dismissWithClickedButtonIndex:0 animated:YES];
                _waitingForUser = nil;
            }
            if (_alertForNewGame) {
                [_alertForNewGame dismissWithClickedButtonIndex:0 animated:YES];
                _alertForNewGame = nil;
            }
            break;
            
        default:
            
            break;
    }
}
- (NewGameMessage)opponentNewGame
{
    return _opponentNewGame;
}
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
- (void)setWinner:(XOPlayer)winner
{
    _winner = winner;
    _opponentNewGame = NewGameMessageUnknown;
    switch (_gameMode) {
        case XOGameModeSingle:
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(newGame) userInfo:nil repeats:NO];
            
            break;
        case XOGameModeMultiplayer:
            break;
        case XOGameModeOnline:
            if (!_alertForNewGame) {
                _alertForNewGame = [[UIAlertView alloc] initWithTitle:_player==_me?@"You win!":@"You opponent win!" message:@"Continue game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
            }
            [_alertForNewGame show];
            break;
            
        default:
            break;
    }
    if ([_timerDelegate respondsToSelector:@selector(stopTimer)])
    {
        [_timerDelegate stopTimer];
    }
    [self victory];
    if ([_victoryDelegate respondsToSelector:@selector(drawVector:atLine:)]) {
        if (_winner){
            [_victoryDelegate drawVector:matrix.vectorType atLine:matrix.vectorType == XOVectorTypeVertical?(int)matrix.lastMove.row:(int)matrix.lastMove.section];
        }
        else{
            [_victoryDelegate drawVector:NSNotFound atLine:NSNotFound];
        }
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            //[[MPManager sharedInstance].lobbyDelegate multiPlayerGameWasCanceled:YES];
            [[MPManager sharedInstance] sendPlayerMyMessage:@"yes"];
            [self displayWaitOpponentView];
            break;
        case 2:
            [self newGame];
            //[[MPManager sharedInstance] sendPlayerMyMessage:@"yes"];
            break;
        default:
            [[MPManager sharedInstance].lobbyDelegate multiPlayerGameWasCanceled:YES];
            [[MPManager sharedInstance] sendPlayerMyMessage:@"no"];
            break;
    }
}
- (void)displayWaitOpponentView
{
    if (!_waitingForUser&&!_opponentNewGame) {
        _waitingForUser = [[UIAlertView alloc] initWithTitle:@"Waiting for parthner" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:[NSMutableDictionary dictionaryWithDictionary: @{@"waiting":@10}] repeats:YES];
    }
    [_waitingForUser show];
}
- (void)timerTick:(NSTimer *)timer
{
    int t = [[timer.userInfo valueForKey:@"waiting"] intValue];
    if (!t)
    {
        if (_waitingForUser) {
            [_waitingForUser dismissWithClickedButtonIndex:0 animated:YES];
            [[MPManager sharedInstance].lobbyDelegate multiPlayerGameWasCanceled:YES];
            _waitingForUser = nil;
        }
        [timer invalidate];
        timer = nil;
    } else if (t >=3)
    {
    }
    [timer.userInfo setValue:[NSNumber numberWithInt:t-1] forKey:@"waiting"];

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
                XOAI *ai = [XOAI new];
                [ai moveWithTimer:1];
            }
            
            
        }
        NSLog(@"Winner %i", _winner);
        NSLog(@"%@", matrix);
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
        if ((_playersTurnDelegate) && ([_playersTurnDelegate respondsToSelector:@selector(nowTurn:)])) {
                 [_playersTurnDelegate nowTurn:_player];
        }
       _player=_player*-1;        
        [[SoundManager sharedInstance] playXOSoundFor:value];
    }
}
- (void)willChangeValueforIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) victory
{
    NSLog(@"victory");
    [self changeProgress];
    [self.delegate playerWin:_winner];
    
    if (_gameMode==XOGameModeMultiplayer) {
        [self.victoryDelegate restartGame];
    }
    
    //[[GameManager sharedInstance].progress updateProgress:[GameManager sharedInstance].mode forPlayer:_winner];
    //[self clear];
    //_winner=XOPlayerNone;
}

- (void)changeProgress{
    if ([GameManager sharedInstance].mode==XOGameModeOnline){
        if (_winner==_me){
        [[GameManager sharedInstance].progress updateProgress:[GameManager sharedInstance].mode forMe:YES];
        }
        else {
            [[GameManager sharedInstance].progress updateProgress:[GameManager sharedInstance].mode forMe:NO];
        }
    }
    if ([GameManager sharedInstance].mode==XOGameModeSingle) {
        switch (_winner) {
            case XOPlayerFirst:{
                [[GameManager sharedInstance].progress updateProgress:[GameManager sharedInstance].mode forMe:YES];
            }
                break;
            case XOPlayerSecond:{
                [[GameManager sharedInstance].progress updateProgress:[GameManager sharedInstance].mode forMe:YES];
            }
                break;
            default:
                break;
        }
    }
    if ([GameManager sharedInstance].mode==XOGameModeMultiplayer) {
        switch (_winner) {
            case XOPlayerFirst:{
                [GameManager sharedInstance].firstPlayerVictory++;
            }
                break;
            case XOPlayerSecond:{
                [GameManager sharedInstance].secondPlayerVictory++;
            }
                break;
            default:
                break;
        }
    }
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
