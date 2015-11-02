//
//  GameModelSinglePlayer.h
//  XO
//
//  Created by Kirill Gorbushko on 30.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "BaseGameModel.h"

@interface GameModelSinglePlayer : BaseGameModel

- (instancetype)initWithPlayerOneSign:(Player)playerOne AISign:(Player)AISign difficultLevel:(AILevel)defficultLevel;

- (void)performTurnWithIndexPath:(NSIndexPath *)indexPath;
- (void)performAITurn;

@end
