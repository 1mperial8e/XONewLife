//
//  GameManager.h
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "ScoreModel.h"

@class  BLEService;

@interface GameManager : NSObject

// MARK: Score
@property (strong, nonatomic, nonnull) ScoreModel *easyModeScore;
@property (strong, nonatomic, nonnull) ScoreModel *mediumModeScore;
@property (strong, nonatomic, nonnull) ScoreModel *hardModeScore;

- (void)resetLocalScore;
- (void)updateScoreForMode:(AILevel)aiMode withVictory:(BOOL)aVictory;
- (nonnull ScoreModel *)currentScoreModel;

// MARK: BLE
@property (strong, nonatomic, nullable) BLEService *managerService;
@property (strong, nonatomic, nullable) BLEService *peripheralService;
- (void)cleanBLEServices;

// MARK: Singleton
+ (nonnull instancetype)sharedInstance;

// MARK: AI
@property (assign, nonatomic, readonly) AILevel aiLevel;
- (void)aiLevelChanged:(AILevel)newAILevel;

@end
