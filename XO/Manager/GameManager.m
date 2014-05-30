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
        [_instance loadFullScreenADV];
        _instance.tracker=[[GAI sharedInstance] trackerWithTrackingId:TRACK_ID];
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
    [self loadFullScreenADV];
}

- (void)tryToBeFirst{
    int roll=arc4random()%365;
    self.myRoll=roll;
    [[MPManager sharedInstance] sendPlayerMyMessage:[NSString stringWithFormat:@"%i",roll]];
    NSLog(@"ROLL SENT!");
}

- (void) trackScreenWithName:(NSString*)name{
    if (_googleAnalitics==YES) {
        [_tracker send:[[[GAIDictionaryBuilder createAppView] set:name
                                                          forKey:kGAIScreenName] build]];
    }
}

- (void) loadFullScreenADV{
    interstitial_=nil;
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = GOOGLE_AD_MOB_ID;
    [interstitial_ loadRequest:[GADRequest request]];
}

- (void) setInterstitialDelegate:(id)delegate{
    interstitial_.delegate=delegate;
}

- (void) showFullScreenADVOnViewController:(UIViewController *)viewController{
    if (interstitial_){
        [interstitial_ presentFromRootViewController:viewController];
    }
}

- (void)testInternetConnection
{
    internetReachableFoo = [MyReachability reachabilityWithHostname:@"www.google.com"];
        internetReachableFoo.reachableBlock = ^(MyReachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Internet!");
        });
    };
    internetReachableFoo.unreachableBlock = ^(MyReachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[GPGManager sharedInstance] isSignedIn]==YES) {
                [[GPGManager sharedInstance] signOut];
            }
        });
    };
    
    [internetReachableFoo startNotifier];
}

@end
