//
//  GameModelSinglePlayer.m
//  XO
//
//  Created by Kirill Gorbushko on 30.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "GameModelSinglePlayer.h"

@interface GameModelSinglePlayer()

@property (strong, nonatomic) AIPlayer *AIPlayer;

@end

@implementation GameModelSinglePlayer

#pragma mark - LifeCycle

- (instancetype)initWithPlayerOneSign:(Player)playerOne AISign:(Player)AISign difficultLevel:(AILevel)defficultLevel
{
    self = [super initWithPlayerOneSign:playerOne playerTwoSign:AISign];
    if (self) {
        self.AIPlayer = [[AIPlayer alloc] initWithAISign:AISign playerSign:playerOne difficultLevel:defficultLevel];
    }
    return self;
}

- (VictoryVectorType)performTurnWithIndexPath:(NSIndexPath *)indexPath
{
    int i = (int)indexPath.row / 3;
    int j = (int)indexPath.row % 3;
    
    VictoryVectorType victoryVector = VectorTypeNone;
    if (self.activeGame.stateMatrix[i][j] == EmptySign) {
        victoryVector = [super performTurnWithIndexPath:indexPath];
        
        if (victoryVector != VectorTypeNone) {
            [self updateSignsForPlayers];
        } else {
            [self performSelector:@selector(performAITurn) withObject:nil afterDelay:1];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gameModelDidFailMakeTurnAtIndexPath:forPlayer:)]) {
            [self.delegate gameModelDidFailMakeTurnAtIndexPath:indexPath forPlayer:self.activePlayer];
        }
    }
    return victoryVector;
}

#pragma mark - Private

- (void)performAITurn
{
    GameMatrix previousMatrix = self.activeGame;
    self.activeGame = [self.AIPlayer makeAITurnWithMat:self.activeGame];
    DLog(@"AI:");
    LogMat(self.activeGame.stateMatrix);
    
    BOOL isVictoryTurn = [self isGameFinished];
    BOOL isPatGame = !isVictoryTurn && ![self canPerfromTurn];
    
    NSIndexPath *aiSelectedIndexPath = [self modifiedIndexInOriginalMatrix:previousMatrix modifiedMatrix:self.activeGame];
    if (isPatGame) {
        self.victoryType = VectorTypePat;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameModelDidConfirmGameTurnAtIndexPath:forPlayer:victoryTurn:)]) {
        [self.delegate gameModelDidConfirmGameTurnAtIndexPath:aiSelectedIndexPath forPlayer:self.activePlayer victoryTurn:self.victoryType];
    }

    self.activePlayer = (self.activePlayer == PlayerFirst) ? PlayerSecond : PlayerFirst;
    
    if (isVictoryTurn || isPatGame) {
        [self resetGame];
        [self updateSignsForPlayers];
    }
}

- (NSIndexPath *)modifiedIndexInOriginalMatrix:(GameMatrix)original modifiedMatrix:(GameMatrix)modified
{
    NSIndexPath *aiSelectedIndexPath;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (original.stateMatrix[i][j] != modified.stateMatrix[i][j]) {
                return aiSelectedIndexPath = [NSIndexPath indexPathForItem:i * 3 + j inSection:0];
            }
        }
    }
    return aiSelectedIndexPath;
}

- (void)updateSignsForPlayers
{
    self.playerOneSign += self.playerTwoSign;
    self.playerTwoSign = self.playerOneSign - self.playerTwoSign;
    self.playerOneSign -= self.playerTwoSign;

    [self.AIPlayer updateAiSingTo:self.playerTwoSign player:self.playerOneSign];
}

@end