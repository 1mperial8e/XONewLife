//
//  TTViewController.m
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "XOStartViewController.h"
#import "XOGameViewController.h"
#import "XOSettingsViewController.h"
#import "GameManager.h"
#import "GTLPlusPerson.h"
#import "XOGameModel.h"
#import "SoundManager.h"


@interface XOStartViewController () <GPGAchievementControllerDelegate, GPGLeaderboardControllerDelegate>

- (IBAction)leaderboardButton:(id)sender;
- (IBAction)achievementsButton:(id)sender;
- (IBAction)singlePlayer:(id)sender;
- (IBAction)twoPlayers:(id)sender;
- (IBAction)playOnline:(id)sender;
- (IBAction)settings:(id)sender;


@end

@implementation XOStartViewController

static NSString * const kClientID = @"111039763950-dj91993gmav7o5dn26v65ga1lavlt0jg.apps.googleusercontent.com";

- (void)viewDidLoad
{
    [super viewDidLoad];    
	GPPSignIn *signIn = [GPPSignIn sharedInstance];
    // You set kClientID in a previous step
    signIn.clientID = kClientID;
    signIn.scopes = [NSArray arrayWithObjects:
                     @"https://www.googleapis.com/auth/games",
                     @"https://www.googleapis.com/auth/appstate",
                     nil];
    signIn.language = [[NSLocale preferredLanguages] objectAtIndex:0];
    signIn.shouldFetchGooglePlusUser=YES;
    signIn.delegate = self;
    signIn.shouldFetchGoogleUserID =YES;
    [signIn trySilentAuthentication];
    [self getDefaultSettings];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - UIActions

- (IBAction)leaderboardButton:(id)sender{
    GPGLeaderboardController *leadController=[[GPGLeaderboardController alloc] initWithLeaderboardId:@"CgkI7qvx050DEAIQBQ"];
    leadController.leaderboardDelegate=self;
    leadController.timeScope=GPGLeaderboardTimeScopeThisWeek;
    [self presentViewController:leadController animated:YES completion:nil];
    [[SoundManager sharedInstance] playClickSound];
}
- (IBAction)achievementsButton:(id)sender{
    GPGAchievementController *achController = [[GPGAchievementController alloc] init];
    achController.achievementDelegate = self;
    [self presentViewController:achController animated:YES completion:nil];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)singlePlayer:(id)sender {
    [GameManager sharedInstance].mode=SINGLE_PLAYER;
    [XOGameModel sharedInstance].gameMode = XOGameModeSingle;
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)twoPlayers:(id)sender {
    [GameManager sharedInstance].mode=TWO_PLAYERS;
    [XOGameModel sharedInstance].gameMode = XOGameModeMultiplayer;
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)playOnline:(id)sender {
    [GameManager sharedInstance].mode=ONLINE_PLAYERS;
    [XOGameModel sharedInstance].gameMode = XOGameModeOnline;
    [XOGameModel sharedInstance].player = XOPlayerNone;
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)settings:(id)sender {
    [[SoundManager sharedInstance] playClickSound];
}
#pragma mark - GPGLeaderboardDelegate

- (void) leaderboardViewControllerDidFinish:(GPGLeaderboardController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[SoundManager sharedInstance] playClickSound];
}

#pragma mark - GPPSignIn delegate

-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if (error == nil && auth) {
        NSLog(@"Success signing in to Google! Auth object is %@", auth);
        [self startGoogleGamesSignIn];
        GTLPlusPerson *me=[GPPSignIn sharedInstance].googlePlusUser;
        [GameManager sharedInstance].googleUserName=me.displayName;
        [GameManager sharedInstance].googleUserImage=me.image.url;
    } else {
        NSLog(@"Failed to log into Google!\n\tError=%@\n\tAuthObj=%@",error,auth);
    }
}

-(void)startGoogleGamesSignIn
{
    [[GPGManager sharedInstance] signIn:[GPPSignIn sharedInstance] reauthorizeHandler:^(BOOL requiresKeychainWipe, NSError *error) {
        if (requiresKeychainWipe) {
            [[GPPSignIn sharedInstance] signOut];
        }
        [[GPPSignIn sharedInstance] authenticate];
    }];
}

#pragma mark - AchievmentDelegate

- (void)achievementViewControllerDidFinish: (GPGAchievementController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[SoundManager sharedInstance] playClickSound];
}

#pragma mark - Other Methods

- (void) getDefaultSettings{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"easyVictory"]==nil) {
        [userDefaults setBool:YES forKey:@"sound"];
        [userDefaults setBool:YES forKey:@"music"];
        [userDefaults setBool:YES forKey:@"googleAnalitics"];
        [userDefaults setBool:YES forKey:@"push"];
        [userDefaults setInteger:0 forKey:@"easyVictory"];
        [userDefaults setInteger:0 forKey:@"mediumVictory"];
        [userDefaults setInteger:0 forKey:@"hardVictory"];
        [userDefaults synchronize];
    }
    [[GameManager sharedInstance] setSettings];
}

@end
