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
#define CLIENT_ID @"111039763950-dj91993gmav7o5dn26v65ga1lavlt0jg.apps.googleusercontent.com"
#define ACH_NEWBIE @"CgkI7qvx050DEAIQAg"
#define ACH_STUDENT @"CgkI7qvx050DEAIQAw"
#define ACH_EXPERT @"CgkI7qvx050DEAIQBA"
#define LEAD_LEADERBOARD @"CgkI7qvx050DEAIQBg"
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
