//
//  XOProgress.m
//  XO
//
//  Created by Stas Volskyi on 09.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOProgress.h"
#import "GameManager.h"
//#import "MPManager.h"
#import "XOGameModel.h"

@implementation XOProgress

- (id) init{
    _easyLooses=0;
    _easyVictory=0;
    _mediumLooses=0;
    _mediumVictory=0;
    _hardLooses=0;
    _hardVictory=0;
    _myVictory=0;
    _opponentVictory=0;
    _onlineGames=0;
    _multiplayerGames=0;
    return self;
}

- (void) updateProgress:(XOGameMode)mode forMe:(BOOL)player{
    NSString *key=[[NSString alloc] init];
    NSInteger value = 0;
    switch (mode) {
        case XOGameModeOnline:{
            self.onlineGames++;
            if (player==YES) {
                self.myVictory++;
                self.onlineVictory++;
//                [MPManager sharedInstance].myScore.value=(long long)self.onlineVictory;
//                [[MPManager sharedInstance].myScore submitScoreWithCompletionHandler:^(GPGScoreReport *report, NSError *error){
//                    if (error) {
//                        NSLog(@"%@",error);
//                    }                    
//                }];
                [self saveData:[NSString stringWithFormat:@"%i", self.onlineVictory]];
            }
            else {
                self.opponentVictory++;
            }
            return;
        }
            break;
        case XOGameModeMultiplayer:{
            [GameManager sharedInstance].progress.multiplayerGames++;
            value=self.multiplayerGames;
            key=MULTIPLAYER_GAMES;
        }
            break;
        case XOGameModeSingle:{
            if ([XOGameModel sharedInstance].aiGameMode == 0){
                if (player==YES){
                    self.easyVictory++;
                    value=self.easyVictory;
                    key=EASY_VICTORY;
                }
                else {
                    self.easyLooses++;
                    value=self.easyLooses;
                    key=EASY_LOOSES;
                }
            }
            if ([XOGameModel sharedInstance].aiGameMode == 1){
                if (player==YES){
                    
                }
                else {
                    
                }
            }
            if ([XOGameModel sharedInstance].aiGameMode == 2){
                if (player==YES){
                    self.hardVictory++;
                    value=self.hardVictory;
                    key=HARD_VICTORY;
                }
                else {
                    self.hardLooses++;
                    value=self.hardLooses;
                    key=HARD_LOOSES;
                }
            }
        }
    }
    [self saveProgress:key:value];
}

- (void)saveProgress:(NSString*)key :(NSInteger)value{
    NSUserDefaults *userDefaults=[[NSUserDefaults alloc] init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:(int)value forKey:key];
    [userDefaults synchronize];
}

- (void)canUnlockAchievement{
    if (self.easyVictory>=10) {
        [self tryToUnlockAchievement:ACH_NEWBIE];
    }
    if (self.hardVictory>=10) {
        [self tryToUnlockAchievement:ACH_GOOD_PLAYER];
    }
    if (self.onlineGames>=1) {
        [self tryToUnlockAchievement:ACH_BEGINER];
    }
    if (self.multiplayerGames>=10) {
        [self tryToUnlockAchievement:ACH_FRIENDLY_GAMER];
    }
    if (self.onlineVictory>=10) {
        [self tryToUnlockAchievement:ACH_GAMER];
    }
}

- (void) tryToUnlockAchievement:(NSString*)achievement{
//    GPGAchievement *unlockMe = [GPGAchievement achievementWithId:achievement];
//    [unlockMe unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//        } else if (!newlyUnlocked) {
//            // Achievement was already unlocked
//        } else {
//            NSLog(@"Hooray! Achievement unlocked!");
//        }
//    }];    
}

#pragma mark - CloudSaving

- (void)saveData:(NSString*)dataSTR{
//    GPGAppStateModel *model = [GPGManager sharedInstance].applicationModel.appState;
//    NSNumber *playerAvatarKey = [NSNumber numberWithInt:2];
//    NSData *data=[[NSData alloc] init];
//    data=[dataSTR dataUsingEncoding:NSUTF8StringEncoding];
//    [model setStateData:data forKey:playerAvatarKey];
//    [model updateForKey:playerAvatarKey completionHandler:^(GPGAppStateWriteStatus status, NSError *error) {
//        if (status == GPGAppStateWriteStatusSuccess) {
//            NSLog(@"Hooray! Cloud update is complete");
//            self.onlineVictory=[dataSTR integerValue];
//        }
//        else{
//            NSLog(@"error saving data! error %@",error);
//        }
//    } conflictHandler:^NSData *(NSNumber *key, NSData *localState, NSData *remoteState) {
//        // Uh oh. I need to resolve these two versions.
//        // localState = State you are attempting to upload
//        // remoteState = State currently saved in the cloud
//        NSData *resolvedState;
//        return resolvedState;
//    }];
}

- (void) loadData{
//    GPGAppStateModel *model = [GPGManager sharedInstance].applicationModel.appState;
//    NSNumber *playerAvatarKey = [NSNumber numberWithInt:2];
//    [model loadForKey:playerAvatarKey completionHandler:^(GPGAppStateLoadStatus status, NSError *error) {
//        if (status == GPGAppStateLoadStatusNotFound) {
//            self.onlineVictory=0;
//            [self saveData:[NSString stringWithFormat:@"%i", self.onlineVictory]];
//        } else if (status == GPGAppStateLoadStatusSuccess) {
//            NSString *data=[[NSString alloc] initWithData:[model stateDataForKey:playerAvatarKey] encoding:NSUTF8StringEncoding];
//            self.onlineVictory=[data integerValue];
//        } else if (status == GPGAppStateLoadStatusUnknownError) {
//            NSLog(@"error loading data! error %@",error);
//        }
//    } conflictHandler:^NSData *(NSNumber *key, NSData *localState, NSData *remoteState) {
//        // This call tells the application that the version in the cloud has
//        // changed since the last time it downloaded or saved state data.
//        // Typically, the correct resolution to this data conflict is to throw
//        // out the local state, and replace it with the state data from the cloud:
//        return remoteState;
//    }];
}

@end
