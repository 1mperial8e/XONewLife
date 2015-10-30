//
//  GameManager.m
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "GameManager.h"
#import "KeychainStorageService.h"

static NSString *const DefaultScore = @"0:0";

@implementation GameManager

#pragma mark - Singleton

+ (nonnull instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance loadLocalScore];
        [sharedInstance loadAISettings];
    });
    return sharedInstance;
}

#pragma mark - Score

- (void)resetLocalScore
{
    [KeychainStorageService saveScore:DefaultScore forAIMode:AIEasyDifficultyKey];
    [KeychainStorageService saveScore:DefaultScore forAIMode:AIMediumDifficultyKey];
    [KeychainStorageService saveScore:DefaultScore forAIMode:AIHardDifficultyKey];
    
    [self.easyModeScore updateWithScore:DefaultScore];
    [self.mediumModeScore updateWithScore:DefaultScore];
    [self.hardModeScore updateWithScore:DefaultScore];
}

- (void)updateScoreForMode:(AILevel)aiMode withVictory:(BOOL)aVictory
{
    switch (aiMode) {
        case AILevelEasy: {
            [self.easyModeScore updateWithNewVictory:aVictory];
            [KeychainStorageService saveScore:self.easyModeScore.scoreString forAIMode:AIEasyDifficultyKey];
            break;
        }
        case AILevelMedium: {
            [self.mediumModeScore updateWithNewVictory:aVictory];
            [KeychainStorageService saveScore:self.mediumModeScore.scoreString forAIMode:AIMediumDifficultyKey];
            break;
        }
        case AILevelHard: {
            [self.hardModeScore updateWithNewVictory:aVictory];
            [KeychainStorageService saveScore:self.hardModeScore.scoreString forAIMode:AIHardDifficultyKey];
            break;
        }
    }
}

- (void)loadLocalScore
{
    NSString *easyScore = [KeychainStorageService scoreForAIMode:AIEasyDifficultyKey];
    if (!easyScore.length) {
        // Store default values
        [self resetLocalScore];
    }
    
    easyScore = [KeychainStorageService scoreForAIMode:AIEasyDifficultyKey];
    NSString *mediumScore = [KeychainStorageService scoreForAIMode:AIMediumDifficultyKey];
    NSString *hardScore = [KeychainStorageService scoreForAIMode:AIHardDifficultyKey];
    
    _easyModeScore = [ScoreModel modelWithScore:easyScore];
    _mediumModeScore = [ScoreModel modelWithScore:mediumScore];
    _hardModeScore = [ScoreModel modelWithScore:hardScore];
}

#pragma mark - AI

- (void)aiLevelChanged:(AILevel)newAILevel
{
    _aiLevel = newAILevel;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(newAILevel) forKey:AIDifficultyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadAISettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:AIDifficultyKey]) {
        [userDefaults setObject:@(AILevelMedium) forKey:AIDifficultyKey];
        [userDefaults synchronize];
    }
    _aiLevel = [userDefaults integerForKey:AIDifficultyKey];
}

@end
