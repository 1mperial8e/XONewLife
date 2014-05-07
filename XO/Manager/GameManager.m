//
//  GameManager.m
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "GameManager.h"
#import "MPManager.h"

@implementation GameManager

static GameManager* _instance=nil;

+ (GameManager*)sharedInstance{
    @synchronized(self) {
    if (_instance==nil) {
        _instance=[[self alloc] init];
    }
    return _instance;
    }
}

- (void) setSettings{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [GameManager sharedInstance].sound=[userDefaults boolForKey:@"sound"];
    [GameManager sharedInstance].music=[userDefaults boolForKey:@"music"];
    [GameManager sharedInstance].googleAnalitics=[userDefaults boolForKey:@"googleAnalitics"];
    [GameManager sharedInstance].push=[userDefaults boolForKey:@"push"];
    [GameManager sharedInstance].easyVictory=[userDefaults integerForKey:@"easyVictory"];
    [GameManager sharedInstance].mediumVictory=[userDefaults integerForKey:@"mediumVictory"];
    [GameManager sharedInstance].hardVictory=[userDefaults integerForKey:@"hardVictory"];
}

- (void) updateProgress{
    NSString *key=[[NSString alloc] init];
    NSInteger value = 0;
    if ([self.mode isEqualToString:ONLINE_PLAYERS]) {
        self.onlineVictory++;
        [self saveData:[NSString stringWithFormat:@"%i", self.onlineVictory]];
        return;
    }
    else if ([self.mode isEqualToString:SINGLE_PLAYER]) {
        if ([self.difficulty isEqualToString:EASY_MODE]){
            self.easyVictory++;
            value=self->_easyVictory;
             key=EASY_VICTORY;
        }
        if ([self.difficulty isEqualToString:MEDIUM_MODE]){
            self.mediumVictory++;
            value=self->_mediumVictory;
             key=MEDIUM_VICTORY;
        }
        if ([self.difficulty isEqualToString:HARD_MODE]){
            self.hardVictory++;
            value=self->_hardVictory;
             key=HARD_VICTORY;
        }
    }
    if ([self.mode isEqualToString:TWO_PLAYERS]){
        return;
    }

    [self saveProgress:key:value];
}

- (void)saveProgress:(NSString*)key :(NSInteger)value{
    NSUserDefaults *userDefaults=[[NSUserDefaults alloc] init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:(int)value forKey:key];
    [userDefaults synchronize];
}

- (void)tryToBeFirst{
    int roll=arc4random()%365;
    self.myRoll=roll;
    [[MPManager sharedInstance] sendPlayerMyMessage:[NSString stringWithFormat:@"%i",roll]];
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
