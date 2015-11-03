//  XO
//  Constants.h
//  
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#ifdef DEBUG
    #define DLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
    #define DLog(...)
#endif

// MARK: userdefaults
static NSString *const AIDifficultyKey = @"AIDifficultyKey";
static NSString *const MusicSettingsKey = @"MusicSettingsKey";
static NSString *const SoundSettingsKey = @"SoundSettingsKey";

// MARK: keychain
static NSString *const AIEasyDifficultyKey = @"AIEasyDifficultyKey";
static NSString *const AIMediumDifficultyKey = @"AIMediumDifficultyKey";
static NSString *const AIHardDifficultyKey = @"AIHardDifficultyKey";

// MARL: Enums
typedef NS_ENUM(NSInteger, GameMode){
    GameModeSingle,
    GameModeMultiplayer,
    GameModeOnline
};

typedef NS_ENUM(NSInteger, Player){
    PlayerNone = 0,
    PlayerFirst = 1,
    PlayerSecond = 2
};

typedef NS_ENUM(NSInteger, VictoryVectorType){
    VectorTypeNone = -1,
    VectorTypeHorisontalZero,
    VectorTypeHorisontalFirst,
    VectorTypeHorisontalSecond,
    VectorTypeVerticalZero,
    VectorTypeVerticalFirst,
    VectorTypeVerticalSecond,
    VectorTypeDiagonalLeft,
    VectorTypeDiagonalRight,
    VectorTypePat
};

typedef NS_ENUM(NSInteger, AILevel){
    AILevelEasy = 1,
    AILevelMedium,
    AILevelHard
};

typedef NS_ENUM(NSInteger, LobbyMessage){
    LobbyMessageUnknown,
    LobbyMessageYes,
    LobbyMessageNo
};
