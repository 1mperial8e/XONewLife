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
    [self.timerDelegate startTimer];
    [MPManager sharedInstance].newGame=0;
    _player = _player*-1;
    //_player = _me;
    _me = _me*-1;
    matrix = [XOObjectiveMatrix matrixWithDimension:_gameColumns];
    matrix.parrent = self;
    if ([_delegate respondsToSelector:@selector(reload)]) {
        [_delegate reload];
    }
    if ([_victoryDelegate respondsToSelector:@selector(drawVector:atLine:)]) {
        [_victoryDelegate drawVector:NSNotFound atLine:NSNotFound];
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
    NSString *message;
    if (_winner == XOPlayerNone) {
       message = @"Draw";
    } else {
        message = _me==_winner?@"You win!":@"Player 2 win!";
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"time":@3}];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(newGame:) userInfo:dict repeats:YES];
    if (_gameMode == XOGameModeOnline) {
        [dict setValue:@30 forKey:@"time"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:@"New game through 3s" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"New Game", nil];
        [dict setValue:alertView forKey:@"alert"];
        [alertView show];
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
    if (buttonIndex == 0) {
        [[MPManager sharedInstance] sendPlayerMyMessage:@"no"];
        [[MPManager sharedInstance].lobbyDelegate multiPlayerGameWasCanceled:YES];
    } else if (buttonIndex == 1) {
        [[MPManager sharedInstance] sendPlayerMyMessage:@"yes"];
        [self waitOpponent];
    }
}

- (void)waitForNewGame:(NSTimer*)timer{
    if ([[[timer userInfo] valueForKey:@"time"] intValue] == 0) {
        [((UIAlertView *)[timer.userInfo valueForKey:@"alert"]) dismissWithClickedButtonIndex:0 animated:YES];
        [timer invalidate];        
    } else {
        if ([MPManager sharedInstance].newGame==1) {
            [((UIAlertView *)[timer.userInfo valueForKey:@"alert"]) dismissWithClickedButtonIndex:0 animated:YES];
            [timer invalidate];            
        }
        else if ([MPManager sharedInstance].newGame==2){
            [((UIAlertView *)[timer.userInfo valueForKey:@"alert"]) dismissWithClickedButtonIndex:0 animated:YES];
             [self newGame];
            [timer invalidate];            
        }
        else if ([MPManager sharedInstance].newGame==0){
        int t = [[timer.userInfo valueForKey:@"time"] intValue]-1;
        [timer.userInfo setValue:[NSNumber numberWithInt:t] forKey:@"time"];
        if ([timer.userInfo valueForKey:@"alert"]) {
            ((UIAlertView *)[timer.userInfo valueForKey:@"alert"]).message = [NSString stringWithFormat:@"New game through %is", [[timer.userInfo objectForKey:@"time"] intValue]];
        }
        }
    }
}

- (void)waitOpponent{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"time":@10}];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitForNewGame:) userInfo:dict repeats:YES];
        [dict setValue:@10 forKey:@"time"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connecting" message:@"Waiting for opponent 10s" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [dict setValue:alertView forKey:@"alert"];
        [alertView show];
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
