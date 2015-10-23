//
//  XOProgress.h
//  XO
//
//  Created by Stas Volskyi on 09.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

@interface XOProgress : NSObject

@property (nonatomic) int easyVictory;
@property (nonatomic) int mediumVictory;
@property (nonatomic) int hardVictory;
@property (nonatomic) int easyLooses;
@property (nonatomic) int mediumLooses;
@property (nonatomic) int hardLooses;
@property (nonatomic) int onlineVictory;
@property (nonatomic) int myVictory;
@property (nonatomic) int opponentVictory;
@property (nonatomic) int onlineGames;
@property (nonatomic) int multiplayerGames;

- (void) updateProgress:(XOGameMode)mode forMe:(BOOL)player;
- (void) saveData:(NSString*)dataSTR;
- (void) loadData;
- (void) canUnlockAchievement;

@end
