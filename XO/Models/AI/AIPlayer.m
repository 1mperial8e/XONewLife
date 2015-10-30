//
//  AIPlayer.m
//  XO
//
//  Created by Kirill Gorbushko on 28.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#define LogMat(MAT) NSLog(@"%s:\n %i %i %i\n %i %i %i\n %i %i %i\n", #MAT, MAT[0][0], MAT[0][1], MAT[0][2], MAT[1][0], MAT[1][1], MAT[1][2], MAT[2][0], MAT[2][1], MAT[2][2])

static int const EmptySign = 0;

#import "AIPlayer.h"

typedef NS_ENUM(NSUInteger, AIStrategy) {
    AIStrategyUndefined,
    AIStrategyCorner,
    AIStrategyCenter
};

@interface AIPlayer()

@property (assign, nonatomic) AILevel difLevel;
@property (assign, nonatomic) AIStrategy strategy;
@property (assign, nonatomic) GameMatrix gameMatrix;

@property (assign, nonatomic) int AISign;
@property (assign, nonatomic) int playerSign;
@property (assign, nonatomic) BOOL AIFirstTurn;

@end

@implementation AIPlayer

#pragma mark - LifeCycle

- (instancetype)initWithAISign:(int)aiSign playerSign:(int)playerSign difficultLevel:(AILevel)difficultLevel
{
    self = [self init];
    if (self) {
        self.AISign = aiSign;
        self.playerSign = playerSign;
        self.difLevel = difficultLevel;
    }
    return self;
}

#pragma mark - Custom Accessors

- (BOOL)AIFirstTurn
{
    for (int i = 0; i < 3; i++) {
        for (int j =0 ; j < 3; j ++) {
            if (_gameMatrix.stateMatrix[i][j] != EmptySign) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - Public

- (GameMatrix)makeAITurnWithMat:(GameMatrix)inputMat
{
    memcpy(&_gameMatrix.stateMatrix, &inputMat.stateMatrix, sizeof(_gameMatrix.stateMatrix));
        
    switch (self.difLevel) {
        case AILevelEasy: {
            if (self.AIFirstTurn) {
                [self performAIRandomFirstTurn];
            } else if (![self makeWinOrBlockTurn:YES]) {
                [self performAIRandomTurn];
            }
            break;
        }
        case AILevelMedium: {
            if (self.AIFirstTurn) {
                [self performAIRandomFirstTurn];
            } else {
                BOOL AIMakeTurn = NO;
                AIMakeTurn = [self makeWinOrBlockTurn:NO];
                if (!AIMakeTurn) {
                    AIMakeTurn = [self makeWinOrBlockTurn:YES];
                }
                if (!AIMakeTurn) {
                    [self performAIRandomTurn];
                }
            }
            break;
        }
        case AILevelHard: {
            if (self.AIFirstTurn) {
                [self makeAICleverFirstTurn];
            } else {
                BOOL AIMakeTurn = NO;
                AIMakeTurn = [self makeWinOrBlockTurn:NO];
                if (!AIMakeTurn) {
                    AIMakeTurn = [self makeWinOrBlockTurn:YES];
                }
                if (!AIMakeTurn) {
                    [self makeAICleverTurn];
                }
            }
            break;
        }
    }

    return _gameMatrix;
}

#pragma mark - Private

- (BOOL)canPerfromTurn
{
    for (int i = 0; i < 3; i++) {
        for (int j = 0 ; j < 3; j ++) {
            if (_gameMatrix.stateMatrix[i][j] == EmptySign) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - CleverModeLogic

- (void)makeAICleverTurn
{
    if (self.strategy == AIStrategyCenter) {
        [self makeCleverCenterStrategeTurn];
    } else if (self.strategy == AIStrategyCorner) {
        [self makeCleverCornerStrategeTurn];
    } else {
        [self makeCleverSecondTurnAfterPlayer];
    }
}

- (void)makeCleverCenterStrategeTurn
{
    if (_gameMatrix.stateMatrix[0][0] == EmptySign && _gameMatrix.stateMatrix[2][2] == EmptySign) {
        _gameMatrix.stateMatrix[0][0] = self.AISign;
        return;
    }
    if (_gameMatrix.stateMatrix[0][2] == EmptySign && _gameMatrix.stateMatrix[2][0] == EmptySign) {
        _gameMatrix.stateMatrix[0][2] = self.AISign;
        return;
    }
    if (_gameMatrix.stateMatrix[0][1] == EmptySign && _gameMatrix.stateMatrix[2][1] == EmptySign) {
        _gameMatrix.stateMatrix[0][1] = self.AISign;
        return;
    }
    if (_gameMatrix.stateMatrix[1][0] == EmptySign && _gameMatrix.stateMatrix[1][2] == EmptySign) {
        _gameMatrix.stateMatrix[0][1] = self.AISign;
        return;
    }
    [self performAIRandomTurn];
}

- (void)makeCleverCornerStrategeTurn
{
    if (_gameMatrix.stateMatrix[0][0] == self.AISign) {
        if (_gameMatrix.stateMatrix[0][1] == EmptySign && _gameMatrix.stateMatrix[0][2] == EmptySign) {
            _gameMatrix.stateMatrix[0][2] = self.AISign;
            return;
        } else if (_gameMatrix.stateMatrix[1][0] == EmptySign && _gameMatrix.stateMatrix[2][0] == EmptySign) {
            _gameMatrix.stateMatrix[2][0] = self.AISign;
            return;
        }
    }
    if (_gameMatrix.stateMatrix[2][2] == self.AISign) {
        if (_gameMatrix.stateMatrix[2][1] == EmptySign && _gameMatrix.stateMatrix[2][0] == EmptySign) {
            _gameMatrix.stateMatrix[2][0] = self.AISign;
            return;
        } else if (_gameMatrix.stateMatrix[1][2] == EmptySign && _gameMatrix.stateMatrix[0][2] == EmptySign) {
            _gameMatrix.stateMatrix[0][2] = self.AISign;
            return;
        }
    }
    if (_gameMatrix.stateMatrix[2][0] == self.AISign) {
        if (_gameMatrix.stateMatrix[2][1] == EmptySign && _gameMatrix.stateMatrix[2][2] == EmptySign) {
            _gameMatrix.stateMatrix[2][2] = self.AISign;
            return;
        } else if (_gameMatrix.stateMatrix[0][0] == EmptySign && _gameMatrix.stateMatrix[1][0] == EmptySign) {
            _gameMatrix.stateMatrix[0][0] = self.AISign;
            return;
        }
    }
    if (_gameMatrix.stateMatrix[0][2] == self.AISign) {
        if (_gameMatrix.stateMatrix[0][1] == EmptySign && _gameMatrix.stateMatrix[0][0] == EmptySign) {
            _gameMatrix.stateMatrix[0][0] = self.AISign;
            return;
        } else if (_gameMatrix.stateMatrix[2][2] == EmptySign && _gameMatrix.stateMatrix[1][2] == EmptySign) {
            _gameMatrix.stateMatrix[2][2] = self.AISign;
            return;
        }
    }
    [self performAIRandomTurn];
}

- (void)makeCleverSecondTurnAfterPlayer
{
    if (_gameMatrix.stateMatrix[1][1] != self.playerSign) {
        _gameMatrix.stateMatrix[1][1] = self.AISign;
        self.strategy = AIStrategyCenter;
    } else {
        int iIndex = arc4random_uniform(HUGE) % 2 ? 0 : 2;
        int jIndex = arc4random_uniform(HUGE) % 2 ? 0 : 2;
        
        if (_gameMatrix.stateMatrix[iIndex][jIndex] != self.playerSign) {
            _gameMatrix.stateMatrix[iIndex][jIndex] = self.AISign;
            self.strategy = AIStrategyCorner;
        } else {
            [self makeAICleverTurn];
        }
    }
}

- (void)makeAICleverFirstTurn
{
    //    x----01----x
    //    |     |    |
    //    10----x----12
    //    |     |    |
    //    x----21----x
    //x - posible positions
    
    int iIndex = arc4random_uniform(3);
    int jIndex = 0;
    switch (iIndex) {
        case 2:
        case 0: {
            jIndex = arc4random_uniform(HUGE) % 2 ? 0 : 2;
            self.strategy = AIStrategyCorner;
            break;
        }
        case 1: {
            jIndex = iIndex;
            self.strategy = AIStrategyCenter;
            break;
        }
    }
    _gameMatrix.stateMatrix[iIndex][jIndex] = self.AISign;
}

#pragma mark - RandomTurnsLogic

- (void)performAIRandomFirstTurn
{
    if (_gameMatrix.stateMatrix[1][1] == EmptySign) {
        _gameMatrix.stateMatrix[1][1] = self.AISign;
        return;
    } else {
        [self performAIRandomTurn];
    }
}

- (void)performAIRandomTurn
{
    int randi = arc4random_uniform(3);
    int randj = arc4random_uniform(3);
    
    if (_gameMatrix.stateMatrix[randi][randj] == EmptySign) {
        _gameMatrix.stateMatrix[randi][randj] = self.AISign;
    } else {
        [self performAIRandomTurn];
    }
}

- (BOOL)makeWinOrBlockTurn:(BOOL)isBlockTurn
{
    int blockinMark = isBlockTurn ? self.playerSign : self.AISign;
    //    00----01----02
    //    |     |      |
    //    10----11----12
    //    |     |      |
    //    20----21----22
    
    //vertical
    for (int i = 0; i < 3; i ++) {
        for (int j = 0 ; j < 3; j ++) {
            if (j == 2) {
                if (_gameMatrix.stateMatrix[j][i] == blockinMark && _gameMatrix.stateMatrix[0][i] == blockinMark) {
                    if (_gameMatrix.stateMatrix[1][i] == EmptySign) {
                        _gameMatrix.stateMatrix[1][i] = self.AISign;
                        return YES;
                    }
                }
            } else {
                if (_gameMatrix.stateMatrix[j][i] == blockinMark && _gameMatrix.stateMatrix[j+1][i] == blockinMark) {
                    if (_gameMatrix.stateMatrix[j ? 0 : 2][i] == EmptySign) {
                        _gameMatrix.stateMatrix[j ? 0 : 2][i] = self.AISign;
                        return YES;
                    }
                }
            }
        }
    }
    
    //horizontal
    for (int i = 0; i < 3; i ++) {
        for (int j = 0 ; j < 3; j ++) {
            if (j == 2) {
                if (_gameMatrix.stateMatrix[i][j] == blockinMark && _gameMatrix.stateMatrix[i][0] == blockinMark) {
                    if (_gameMatrix.stateMatrix[i][1] == EmptySign) {
                        _gameMatrix.stateMatrix[i][1] = self.AISign;
                        return YES;
                    }
                }
            } else {
                if (_gameMatrix.stateMatrix[i][j] == blockinMark && _gameMatrix.stateMatrix[i][j+1] == blockinMark) {
                    if (_gameMatrix.stateMatrix[i][j ? 0 : 2] == EmptySign) {
                        _gameMatrix.stateMatrix[i][j ? 0 : 2] = self.AISign;
                        return YES;
                    }
                }
            }
        }
    }
    
    //diagonal bottom left - top right
    //                  /
    //    00----01----02
    //    |     |      |
    //    10----11----12
    //    |     |      |
    //    20----21----22
    //   /
    
    if (_gameMatrix.stateMatrix[2][0] == blockinMark && _gameMatrix.stateMatrix[1][1] == blockinMark) {
        if (_gameMatrix.stateMatrix[0][2] == EmptySign) {
            _gameMatrix.stateMatrix[0][2] = self.AISign;
            return YES;
        }
    } else if (_gameMatrix.stateMatrix[2][0] == blockinMark && _gameMatrix.stateMatrix[0][2] == blockinMark) {
        if (_gameMatrix.stateMatrix[1][1] == EmptySign) {
            _gameMatrix.stateMatrix[1][1] = self.AISign;
            return YES;
        }
    } else if (_gameMatrix.stateMatrix[1][1] == blockinMark && _gameMatrix.stateMatrix[0][2] == blockinMark) {
        if (_gameMatrix.stateMatrix[2][0] == EmptySign) {
            _gameMatrix.stateMatrix[2][0] = self.AISign;
            return YES;
        }
    }
    
    //diagonal bottom right - top left
    //   \
    //    00----01----02
    //    |     |      |
    //    10----11----12
    //    |     |      |
    //    20----21----22
    //                  \
    
    if (_gameMatrix.stateMatrix[2][2] == blockinMark && _gameMatrix.stateMatrix[1][1] == blockinMark) {
        if (_gameMatrix.stateMatrix[0][0] == EmptySign) {
            _gameMatrix.stateMatrix[0][0] = self.AISign;
            return YES;
        }
    } else if (_gameMatrix.stateMatrix[2][2] == blockinMark && _gameMatrix.stateMatrix[0][0] == blockinMark) {
        if (_gameMatrix.stateMatrix[1][1] == EmptySign) {
            _gameMatrix.stateMatrix[1][1] = self.AISign;
            return YES;
        }
    } else if (_gameMatrix.stateMatrix[0][0] == blockinMark && _gameMatrix.stateMatrix[1][1] == blockinMark) {
        if (_gameMatrix.stateMatrix[2][2] == EmptySign) {
            _gameMatrix.stateMatrix[2][2] = self.AISign;
            return YES;
        }
    }
    return NO;
}

@end