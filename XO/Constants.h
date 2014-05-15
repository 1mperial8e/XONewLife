//
//  Constants.h
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#ifndef XO_Constants_h
#define XO_Constants_h

#define EASY_MODE @"easy"
#define MEDIUM_MODE @"medium"
#define HARD_MODE @"hard"
#define EASY_VICTORY @"easyVictory"
#define MEDIUM_VICTORY @"mediumVictory"
#define HARD_VICTORY @"hardVictory"
#define EASY_LOOSES @"easyLooses"
#define MEDIUM_LOOSES @"mediumLooses"
#define HARD_LOOSES @"hardLooses"
#define MULTIPLAYER_GAMES @"multiplayerGames"
#define CLIENT_ID @"111039763950-dj91993gmav7o5dn26v65ga1lavlt0jg.apps.googleusercontent.com"
#define ACH_NEWBIE @"CgkI7qvx050DEAIQAg"
#define ACH_GOOD_PLAYER @"CgkI7qvx050DEAIQBA"
#define ACH_BEGINER @"CgkI7qvx050DEAIQBw"
#define ACH_GAMER @"CgkI7qvx050DEAIQCA"
#define ACH_FRIENDLY_GAMER @"CgkI7qvx050DEAIQCQ"
#define LEAD_LEADERBOARD @"CgkI7qvx050DEAIQBg"
#define TRACK_ID @"UA-51035720-1"
#define MULTIPLAYER_SCREEN @"multi"
#define SINGLE_SCREEN @"single"
#define ONLINE_SCREEN @"online"
#define LOBBY_SCREEN @"lobby"
#define SETTINGS_SCREEN @"settings"
#define GAME_MODE_SCREEN @"gameMode"
#define START_SCREEN @"start"
#define ABOUT_SCREEN @"about"
#endif

#pragma mark - Enums
typedef enum
{
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
