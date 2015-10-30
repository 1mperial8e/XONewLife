//
//  BaseGameModel.m
//  XO
//
//  Created by Kirill Gorbushko on 30.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "BaseGameModel.h"

@implementation BaseGameModel

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepareNewGame];
        self.victoryType = VectorTypeNone;
    }
    return self;
}

- (instancetype)initWithPlayerOneSign:(Player)playerOne playerTwoSign:(Player)playerTwo
{
    self = [super init];
    if (self) {
        self.victoryType = VectorTypeNone;
        self.activePlayer = PlayerFirst;
        
        self.playerOneSign = playerOne;
        self.playerTwoSign = playerTwo;
    }
    return self;
}

#pragma mark - Public

- (void)performTurnWithIndexPath:(NSIndexPath *)indexPath;
{
    int i = (int)indexPath.row / 3;
    int j = (int)indexPath.row % 3;
    
    if (self.activeGame.stateMatrix[i][j] == EmptySign) {
        int activeSign = [self activeSign];
        _activeGame.stateMatrix[i][j] = activeSign;

#ifdef DEBUG
        NSLog(@"User:");
        LogMat(self.activeGame.stateMatrix);
#endif
        BOOL isVictoryTurn = [self isGameFinished];
        BOOL isPatGame = !isVictoryTurn && ![self canPerfromTurn];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(gameModelDidConfirmGameTurnAtIndexPath:forPlayer:victoryTurn:)]) {
            [self.delegate gameModelDidConfirmGameTurnAtIndexPath:indexPath forPlayer:self.activePlayer victoryTurn:self.victoryType];
        }
        self.activePlayer = self.activePlayer == PlayerFirst ? PlayerSecond : PlayerFirst;
        
        if (isVictoryTurn) {
            [self resetGame];
        }
        if (isPatGame) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(gameModelDidFinishGameWithPatResult)]) {
                [self.delegate gameModelDidFinishGameWithPatResult];
                [self resetGame];
            }
        }
        
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gameModelDidFailMakeTurnAtIndexPath:forPlayer:)]) {
            [self.delegate gameModelDidFailMakeTurnAtIndexPath:indexPath forPlayer:self.activePlayer];
        }
    }
}

- (int)activeSign
{
    return self.activePlayer == PlayerFirst ? self.playerTwoSign : self.playerOneSign;
}

- (void)resetGame
{
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            _activeGame.stateMatrix[i][j] = EmptySign;
        }
    }
    self.victoryType = VectorTypeNone;
}

- (void)putSign:(int)sign atI:(int)i atJ:(int)j
{
    _activeGame.stateMatrix[i][j] = sign;
}

- (BOOL)isGameFinished
{
    BOOL isGameFinished = NO;
    int activeSign = self.activePlayer == PlayerFirst ? self.playerTwoSign : self.playerOneSign;
    
    for (int i = 0; i < 3; i++) {
        if (_activeGame.stateMatrix[i][0] == activeSign &&
            _activeGame.stateMatrix[i][1] == activeSign &&
            _activeGame.stateMatrix[i][2] == activeSign) {
            
            self.victoryType = i;

            isGameFinished = YES;
            break;
        }
        if (_activeGame.stateMatrix[0][i] == activeSign &&
            _activeGame.stateMatrix[1][i] == activeSign &&
            _activeGame.stateMatrix[2][i] == activeSign) {
            
            self.victoryType = i + 3;
            
            isGameFinished = YES;
            break;
        }
    }
    
    if (!isGameFinished) {
        if (_activeGame.stateMatrix[0][0] == activeSign &&
            _activeGame.stateMatrix[1][1] == activeSign &&
            _activeGame.stateMatrix[2][2] == activeSign) {
            self.victoryType = 6;
            isGameFinished = YES;
        } else if (_activeGame.stateMatrix[0][2] == activeSign &&
                   _activeGame.stateMatrix[1][1] == activeSign &&
                   _activeGame.stateMatrix[2][0] == activeSign) {
            self.victoryType = 7;
            isGameFinished = YES;
        }
    }
    
    return isGameFinished;
}

- (BOOL)canPerfromTurn
{
    for (int i = 0; i < 3; i++) {
        for (int j = 0 ; j < 3; j ++) {
            if (_activeGame.stateMatrix[i][j] == EmptySign) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - Preparation

- (void)prepareNewGame
{
    [self resetGame];
    
    self.activePlayer = PlayerFirst;
    self.playerOneSign = CrossSign;
    self.playerTwoSign = ZeroSign;
}

@end
