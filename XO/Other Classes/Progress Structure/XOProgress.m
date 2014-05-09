//
//  XOProgress.m
//  XO
//
//  Created by Stas Volskyi on 09.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOProgress.h"
#import "GameManager.h"

@implementation XOProgress

- (void)resetMultiplayerScore{
    self.firstPlayerVictory=0;
    self.secondPlayerVictory=0;
}

- (void)updatePlayer:(XOPlayer)player{
    switch (player) {
        case XOPlayerFirst:
            _firstPlayerVictory++;
            break;
        case XOPlayerSecond:{
            _secondPlayerVictory++;
        }            
        default:
            break;
    }
}

- (void) updateProgress:(XOGameMode)mode forPlayer:(XOPlayer)player{
    NSString *key=[[NSString alloc] init];
    NSInteger value = 0;
    switch (mode) {
        case XOGameModeOnline:{
            if (player==XOPlayerSecond) {
                return;
            }
            self.onlineVictory++;
            [self saveData:[NSString stringWithFormat:@"%i", self.onlineVictory]];
            return;
        }
            break;
        case XOGameModeMultiplayer:{
            [self updatePlayer:player];
        }
            break;
        case XOGameModeSingle:{
            if (player==XOPlayerSecond) {
                return;
            }
            if ([[GameManager sharedInstance].difficulty isEqualToString:EASY_MODE]){
                self.easyVictory++;
                value=self.easyVictory;
                key=EASY_VICTORY;
            }
            if ([[GameManager sharedInstance].difficulty isEqualToString:MEDIUM_MODE]){
                self.mediumVictory++;
                value=self.mediumVictory;
                key=MEDIUM_VICTORY;
            }
            if ([[GameManager sharedInstance].difficulty isEqualToString:HARD_MODE]){
                self.hardVictory++;
                value=self.hardVictory;
                key=HARD_VICTORY;
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

#pragma mark - CloudSaving

- (void)saveData:(NSString*)dataSTR{
    GPGAppStateModel *model = [GPGManager sharedInstance].applicationModel.appState;
    NSNumber *playerAvatarKey = [NSNumber numberWithInt:2];
    NSData *data=[[NSData alloc] init];
    data=[dataSTR dataUsingEncoding:NSUTF8StringEncoding];
    [model setStateData:data forKey:playerAvatarKey];
    [model updateForKey:playerAvatarKey completionHandler:^(GPGAppStateWriteStatus status, NSError *error) {
        if (status == GPGAppStateWriteStatusSuccess) {
            NSLog(@"Hooray! Cloud update is complete");
            self.onlineVictory=[dataSTR integerValue];
        }
        else{
            NSLog(@"error saving data! error %@",error);
        }
    } conflictHandler:^NSData *(NSNumber *key, NSData *localState, NSData *remoteState) {
        // Uh oh. I need to resolve these two versions.
        // localState = State you are attempting to upload
        // remoteState = State currently saved in the cloud
        NSData *resolvedState;
        return resolvedState;
    }];
}

- (void) loadData{
    GPGAppStateModel *model = [GPGManager sharedInstance].applicationModel.appState;
    NSNumber *playerAvatarKey = [NSNumber numberWithInt:2];
    [model loadForKey:playerAvatarKey completionHandler:^(GPGAppStateLoadStatus status, NSError *error) {
        if (status == GPGAppStateLoadStatusNotFound) {
            self.onlineVictory=0;
            [self saveData:[NSString stringWithFormat:@"%i", self.onlineVictory]];
        } else if (status == GPGAppStateLoadStatusSuccess) {
            NSString *data=[[NSString alloc] initWithData:[model stateDataForKey:playerAvatarKey] encoding:NSUTF8StringEncoding];
            self.onlineVictory=[data integerValue];
        } else if (status == GPGAppStateLoadStatusUnknownError) {
            NSLog(@"error loading data! error %@",error);
        }
    } conflictHandler:^NSData *(NSNumber *key, NSData *localState, NSData *remoteState) {
        // This call tells the application that the version in the cloud has
        // changed since the last time it downloaded or saved state data.
        // Typically, the correct resolution to this data conflict is to throw
        // out the local state, and replace it with the state data from the cloud:
        return remoteState;
    }];
}

@end
