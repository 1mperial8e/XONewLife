//
//  AIPlayer
//  AIPlayer
//
//  Created by Kirill Gorbushko on 28.10.15.
//  Copyright © 2015 thinkmobiles. All rights reserved.
//

typedef NS_ENUM(NSUInteger, AIDifficultLevel) {
    AIDifficultLevelEasy,
    AIDifficultLevelMedium,
    AIDifficultLevelHard
};

typedef struct {
    int stateMatrix[3][3];
} GameMatrix;

@interface AIPlayer : NSObject

- (instancetype)initWithAISign:(int)aiSign playerSign:(int)playerSign difficultLevel:(AIDifficultLevel)difficultLevel;
- (GameMatrix)makeAITurnWithMat:(GameMatrix)inputMat;

@end
