//
//  GameManager.m
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "GameManager.h"
#import "MPManager.h"
#import "SoundManager.h"
#import "GAITrackedViewController.h"
#import "XOGameModel.h"

@implementation GameManager

static GameManager* _instance=nil;

+ (GameManager*)sharedInstance{
    @synchronized(self) {
    if (_instance==nil) {
        _instance=[[self alloc] init];
        _instance.interstitial_ = [[GADInterstitial alloc] init];
        _instance.interstitial_.adUnitID = GOOGLE_AD_MOB_ID;
        _instance.tracker=[[GAI sharedInstance] trackerWithTrackingId:TRACK_ID];
        [_instance.interstitial_ loadRequest:[GADRequest request]];
    }    
    return _instance;
    }
}

- (void) setSettings{
    XOProgress *progress=[XOProgress new];
    [GameManager sharedInstance].progress=progress;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [XOGameModel sharedInstance].aiGameMode=[userDefaults integerForKey:GAME_MODE];
    [GameManager sharedInstance].sound=[userDefaults boolForKey:@"sound"];
    [GameManager sharedInstance].music=[userDefaults boolForKey:@"music"];
    [GameManager sharedInstance].googleAnalitics=[userDefaults boolForKey:@"googleAnalitics"];
    [GameManager sharedInstance].push=[userDefaults boolForKey:@"push"];
    [GameManager sharedInstance].progress.easyVictory=[userDefaults integerForKey:EASY_VICTORY];
    [GameManager sharedInstance].progress.mediumVictory=[userDefaults integerForKey:@"mediumVictory"];
    [GameManager sharedInstance].progress.hardVictory=[userDefaults integerForKey:HARD_VICTORY];
    [GameManager sharedInstance].progress.easyLooses=[userDefaults integerForKey:EASY_LOOSES];
    [GameManager sharedInstance].progress.mediumLooses=[userDefaults integerForKey:@"mediumLooses"];
    [GameManager sharedInstance].progress.hardLooses=[userDefaults integerForKey:HARD_LOOSES];
    [GameManager sharedInstance].progress.multiplayerGames=[userDefaults integerForKey:MULTIPLAYER_GAMES];    
    [GameManager sharedInstance].progress.myVictory=0;
    [GameManager sharedInstance].progress.opponentVictory=0;
    if ([GameManager sharedInstance].music==YES) {
        [[SoundManager sharedInstance].player play];
    }
    else{
        [[SoundManager sharedInstance].player stop];
    }
//    if ([GameManager sharedInstance].push==YES){
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
//    }
//    else{
//        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
//    }
}

- (void)tryToBeFirst{
    int roll=arc4random()%365;
    self.myRoll=roll;
    [[MPManager sharedInstance] sendPlayerMyMessage:[NSString stringWithFormat:@"%i",roll]];
}

- (void) trackScreenWithName:(NSString*)name{
    if (_googleAnalitics==YES) {
        [_tracker send:[[[GAIDictionaryBuilder createAppView] set:name
                                                          forKey:kGAIScreenName] build]];
    }
}

@end
