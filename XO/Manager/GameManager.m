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
    XOProgress *progress=[XOProgress new];
    [GameManager sharedInstance].progress=progress;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [GameManager sharedInstance].sound=[userDefaults boolForKey:@"sound"];
    [GameManager sharedInstance].music=[userDefaults boolForKey:@"music"];
    [GameManager sharedInstance].googleAnalitics=[userDefaults boolForKey:@"googleAnalitics"];
    [GameManager sharedInstance].push=[userDefaults boolForKey:@"push"];
    [GameManager sharedInstance].progress.easyVictory=[userDefaults integerForKey:@"easyVictory"];
    [GameManager sharedInstance].progress.mediumVictory=[userDefaults integerForKey:@"mediumVictory"];
    [GameManager sharedInstance].progress.hardVictory=[userDefaults integerForKey:@"hardVictory"];
    [GameManager sharedInstance].progress.easyLooses=[userDefaults integerForKey:@"easyLooses"];
    [GameManager sharedInstance].progress.mediumLooses=[userDefaults integerForKey:@"mediumLooses"];
    [GameManager sharedInstance].progress.hardLooses=[userDefaults integerForKey:@"hardLooses"];
    [GameManager sharedInstance].firstPlayerVictory=0;
    [GameManager sharedInstance].secondPlayerVictory=0;
    [GameManager sharedInstance].progress.myVictory=0;
    [GameManager sharedInstance].progress.opponentVictory=0;
    if ([GameManager sharedInstance].music==YES) {
        [[SoundManager sharedInstance].player play];
    }
    else{
        [[SoundManager sharedInstance].player stop];
    }
    if ([GameManager sharedInstance].push==YES){
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    }
    else{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types == UIRemoteNotificationTypeNone){
        NSLog(@"YES");
    }
    else{
       NSLog(@"NO"); 
    }
}

- (void)tryToBeFirst{
    int roll=arc4random()%365;
    self.myRoll=roll;
    [[MPManager sharedInstance] sendPlayerMyMessage:[NSString stringWithFormat:@"%i",roll]];
}


@end
