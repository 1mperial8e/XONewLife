//
//  AIPlayer.h
//  XO
//
//  Created by Kirill Gorbushko on 28.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#define LogMat(MAT) DLog(@"%s:\n %i %i %i\n %i %i %i\n %i %i %i\n", #MAT, MAT[0][0], MAT[0][1], MAT[0][2], MAT[1][0], MAT[1][1], MAT[1][2], MAT[2][0], MAT[2][1], MAT[2][2])

static int const EmptySign = 0;
static int const CrossSign = 1;
static int const ZeroSign = 2;

typedef struct {
    int stateMatrix[3][3];
} GameMatrix;

@interface AIPlayer : NSObject

- (instancetype)initWithAISign:(int)aiSign playerSign:(int)playerSign difficultLevel:(AILevel)difficultLevel;
- (GameMatrix)makeAITurnWithMat:(GameMatrix)inputMat;

- (void)updateAiSingTo:(int)ai player:(int)player;

@end
