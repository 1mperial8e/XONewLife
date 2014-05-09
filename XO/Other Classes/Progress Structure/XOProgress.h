//
//  XOProgress.h
//  XO
//
//  Created by Stas Volskyi on 09.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XOProgress : NSObject

@property (nonatomic) int easyVictory;
@property (nonatomic) int mediumVictory;
@property (nonatomic) int hardVictory;
@property (nonatomic) int onlineVictory;
@property (nonatomic) int firstPlayerVictory;
@property (nonatomic) int secondPlayerVictory;

- (void) resetMultiplayerScore;
- (void) updateProgress:(XOGameMode)mode forPlayer:(XOPlayer)player;
- (void) saveData:(NSString*)dataSTR;
- (void) loadData;

@end
