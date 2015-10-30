//
//  GameManager.h
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "ScoreModel.h"

@interface GameManager : NSObject

@property (strong, nonatomic, nonnull) ScoreModel *easyModeScore;
@property (strong, nonatomic, nonnull) ScoreModel *mediumModeScore;
@property (strong, nonatomic, nonnull) ScoreModel *hardModeScore;

@property (assign, nonatomic, readonly) AILevel aiLevel;

+ (nonnull instancetype)sharedInstance;

- (void)resetLocalScore;
- (void)updateScoreForMode:(AILevel)aiMode withVictory:(BOOL)aVictory;
- (void)aiLevelChanged:(AILevel)newAILevel;

@end
