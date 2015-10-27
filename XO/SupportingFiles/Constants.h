//  XO
//  Constants.h
//  
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

static NSString *const AIDifficultyKey = @"AIDifficultyKey";
static NSString *const MusicSettingsKey = @"MusicSettingsKey";
static NSString *const SoundSettingsKey = @"SoundSettingsKey";

#pragma mark - Enums

typedef NS_ENUM(NSInteger, GameMode){
    GameModeSingle,
    GameModeMultiplayer,
    GameModeOnline
};

typedef NS_ENUM(NSInteger, Player){
    PlayerNone,
    PlayerFirst,
    PlayerSecond
};

typedef NS_ENUM(NSInteger, VectorType){
    VectorTypeHorisontal,
    VectorTypeVertical,
    VectorTypeDiagonalLeft,
    VectorTypeDiagonalRight
};

typedef NS_ENUM(NSInteger, AILevel){
    AILevelEasy,
    AILevelMedium,
    AILevelHard
};

typedef NS_ENUM(NSInteger, LobbyMessage){
    LobbyMessageUnknown,
    LobbyMessageYes,
    LobbyMessageNo
};
