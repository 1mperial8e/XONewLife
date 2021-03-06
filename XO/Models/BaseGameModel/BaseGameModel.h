//
//  BaseGameModel.h
//  XO
//
//  Created by Kirill Gorbushko on 30.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIPlayer.h"

@protocol GameModelDelegate <NSObject>

@required
- (void)gameModelDidConfirmGameTurnAtIndexPath:(NSIndexPath *)indexPath forPlayer:(Player)playerID victoryTurn:(VictoryVectorType)vector;
- (void)gameModelDidFailMakeTurnAtIndexPath:(NSIndexPath *)indexPath forPlayer:(Player)playerID;

@end

@interface BaseGameModel : NSObject

@property (weak, nonatomic) id <GameModelDelegate> delegate;

@property (assign, nonatomic) GameMatrix activeGame;
@property (assign, nonatomic) Player activePlayer;

@property (assign, nonatomic) int playerOneSign;
@property (assign, nonatomic) int playerTwoSign; //or AI

@property (assign, nonatomic) VictoryVectorType victoryType;

- (instancetype)initWithPlayerOneSign:(Player)playerOne playerTwoSign:(Player)playerTwo;

- (BOOL)isGameFinished;
- (BOOL)canPerfromTurn;
- (int)activeSign;

- (void)putSign:(int)sign atI:(int)i atJ:(int)j;
- (void)resetGame;

- (VictoryVectorType)performTurnWithIndexPath:(NSIndexPath *)indexPath;

@end
