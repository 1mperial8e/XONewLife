//
//  Constants.h
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
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

//Google Play Game Service constants
#define CLIENT_ID @"111039763950-33mglh0vn072ji3u4hqj17kbtg2ttdr9.apps.googleusercontent.com"
#define ACH_NEWBIE @"CgkI7qvx050DEAIQAg"
#define ACH_GOOD_PLAYER @"CgkI7qvx050DEAIQBA"
#define ACH_BEGINER @"CgkI7qvx050DEAIQBw"
#define ACH_GAMER @"CgkI7qvx050DEAIQCA"
#define ACH_FRIENDLY_GAMER @"CgkI7qvx050DEAIQCQ"
#define LEAD_LEADERBOARD @"CgkI7qvx050DEAIQBg"


//Ad Mob ID
#define START_AD_MOB_ID @"5374b9b8fcb9071100000000"
#define GOOGLE_AD_MOB_ID @"ca-app-pub-8370463222730338/6953510008"

//Google Analytics constants
#define TRACK_ID @"UA-51080238-1"
#define MULTIPLAYER_SCREEN @"Two Players"
#define SINGLE_SCREEN @"Single Player"
#define ONLINE_SCREEN @"Game Online Screen"
#define LOBBY_SCREEN @"Choose Online Game"
#define SETTINGS_SCREEN @"Settings Screen"
#define START_SCREEN @"Main Screen"
#define ABOUT_SCREEN @"About Screen"
#define LEADERBOARD_SCREEN @"Leader Board"
#define ACHIEVEMENTS_SCREEN @"Achievements"
#define QUICK_GAME_SCREEN @"Quick Game"
#define INVITE_FRIEND_SCREEN @"Invite Friend"
#define SHOW_INVITES_SCREEN @"Show Invites"

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
