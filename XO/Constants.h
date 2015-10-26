//
//  Constants.h
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#ifndef XO_Constants_h
#define XO_Constants_h

//UserDefaults keys
#define GAME_MODE @"mode"
#define EASY_VICTORY @"easyVictory"
#define MEDIUM_VICTORY @"mediumVictory"
#define HARD_VICTORY @"hardVictory"
#define EASY_LOOSES @"easyLooses"
#define MEDIUM_LOOSES @"mediumLooses"
#define HARD_LOOSES @"hardLooses"
#define MULTIPLAYER_GAMES @"multiplayerGames"


//Ad Mob ID
#define START_AD_MOB_ID @"5374b9b8fcb9071100000000"
#define GOOGLE_AD_MOB_ID @"ca-app-pub-8370463222730338/6953510008"

//Google Analytics constants
#define TRACK_ID @"UA-51080238-1"


#endif


#pragma mark - Enums
typedef enum{
    XOGameModeSingle,
    XOGameModeMultiplayer,
    XOGameModeOnline
} XOGameMode;

typedef enum {
    XOPlayerFirst = 1,
    XOPlayerSecond = -1,
    XOPlayerNone = 0
} XOPlayer;

typedef enum {
    XOVectorTypeHorisontal,
    XOVectorTypeVertical,
    XOVectorTypeDiagonalLeft,
    XOVectorTypeDiagonalRight
} XOVectorType;

typedef enum {
    XOAIGameModeEasy,
    XOAIGameModeMedium,
    XOAIGameModeHard
}XOAIGameMode;

typedef enum{
    NewGameMessageUnknown,
    NewGameMessageYes,
    NewGameMessageNo
}NewGameMessage;
