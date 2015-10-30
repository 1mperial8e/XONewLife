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

@property (assign, nonatomic) int initialAISign;
@property (assign, nonatomic) int initialPlayerSign;

@end

@implementation GameModelSinglePlayer

#pragma mark - LifeCycle

- (instancetype)initWithPlayerOneSign:(Player)playerOne AISign:(Player)AISign difficultLevel:(AILevel)defficultLevel
{
    self = [super initWithPlayerOneSign:playerOne playerTwoSign:AISign];
    self.AIPlayer = [[AIPlayer alloc] initWithAISign:AISign playerSign:playerOne difficultLevel:AILevelHard];
    return self;
}

- (void)performTurnWithIndexPath:(NSIndexPath *)indexPath
{
    [super performTurnWithIndexPath:indexPath];
    
    int delay = arc4random_uniform(2) + 1;

    if (self.delegate && [self.delegate respondsToSelector:@selector(gameModelWillStartAITurnAfterDelay:)]) {
        [self.delegate gameModelWillStartAITurnAfterDelay:delay];
    }
    
    [self performSelector:@selector(performAITurn) withObject:nil afterDelay:delay];
}

#pragma mark - Private

- (void)performAITurn
{
    GameMatrix previousMatrix = self.activeGame;
    self.activeGame = [self.AIPlayer makeAITurnWithMat:self.activeGame];
#ifdef DEBUG
    NSLog(@"AI:");
    LogMat(self.activeGame.stateMatrix);
#endif
    
    BOOL isVictoryTurn = [self isGameFinished];
    BOOL isPatGame = !isVictoryTurn && ![self canPerfromTurn];
    
    NSIndexPath *aiSelectedIndexPath = [self modifiedIndexInOriginalMatrix:previousMatrix modifiedMatrix:self.activeGame];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameModelDidConfirmGameTurnAtIndexPath:forPlayer:victoryTurn:)]) {
        [self.delegate gameModelDidConfirmGameTurnAtIndexPath:aiSelectedIndexPath forPlayer:self.activePlayer victoryTurn:self.victoryType];
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameModelDidEndAITurn)]) {
        [self.delegate gameModelDidEndAITurn];
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

@end