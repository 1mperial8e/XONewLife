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


@interface XOStartViewController () <GPGAchievementControllerDelegate, GPGLeaderboardControllerDelegate, UIAlertViewDelegate>{
    BOOL showAchievement;
    BOOL showLeaderboard;
}

- (IBAction)leaderboardButton:(id)sender;
- (IBAction)achievementsButton:(id)sender;
- (IBAction)singlePlayer:(id)sender;
- (IBAction)twoPlayers:(id)sender;
- (IBAction)playOnline:(id)sender;
- (IBAction)settings:(id)sender;


@end

@implementation XOStartViewController


- (void)viewDidLoad
{
    [super viewDidLoad];    
	GPPSignIn *signIn = [GPPSignIn sharedInstance];
    // You set kClientID in a previous step
    signIn.clientID = CLIENT_ID;
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
    showAchievement=NO;
    showLeaderboard=NO;
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - UIActions

- (IBAction)leaderboardButton:(id)sender{
    [[SoundManager sharedInstance] playClickSound];
    if (![[GPGManager sharedInstance] isSignedIn]) {
        showLeaderboard=YES;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"You are not signed in" message:@"Sign in via google+ to use leaderboard" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Sign in", nil];
        [alert show];
    }
    else{
        [self showLeaderboard];
    }

    
}

- (IBAction)achievementsButton:(id)sender{
    [[SoundManager sharedInstance] playClickSound];
    if (![[GPGManager sharedInstance] isSignedIn]) {
        showAchievement=YES;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"You are not signed in" message:@"Sign in via google+ to use achievements" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Sign in", nil];
        [alert show];
    }
    else{
        [self showAchievements];
    }
}

- (IBAction)singlePlayer:(id)sender {
    [GameManager sharedInstance].mode=XOGameModeSingle;
    [XOGameModel sharedInstance].gameMode = XOGameModeSingle;
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)twoPlayers:(id)sender {
    [GameManager sharedInstance].mode=XOGameModeMultiplayer;
    [XOGameModel sharedInstance].gameMode = XOGameModeMultiplayer;
    [XOGameModel sharedInstance].me = XOPlayerNone;
    [[XOGameModel sharedInstance] multiplayerNewGame];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)playOnline:(id)sender {
    [GameManager sharedInstance].mode=XOGameModeOnline;
    [XOGameModel sharedInstance].gameMode = XOGameModeOnline;
    [XOGameModel sharedInstance].player = XOPlayerNone;
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)settings:(id)sender {
    [[SoundManager sharedInstance] playClickSound];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            showLeaderboard=NO;
            showAchievement=NO;
        }
        break;
        case 1:{
            [self startGoogleGamesSignIn];
        }
        default:
        break;
    }
}


#pragma mark - GPGLeaderboardDelegate

- (void) leaderboardViewControllerDidFinish:(GPGLeaderboardController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[SoundManager sharedInstance] playClickSound];
    showLeaderboard=NO;
}

#pragma mark - GPPSignIn delegate

-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if (error == nil && auth) {
        NSLog(@"Success signing in to Google! Auth object is %@", auth);
        [[GameManager sharedInstance].progress canUnlockAchievement];
        [self startGoogleGamesSignIn];
        GTLPlusPerson *me=[GPPSignIn sharedInstance].googlePlusUser;
        [GameManager sharedInstance].googleUserName=me.displayName;
        [GameManager sharedInstance].googleUserImage=me.image.url;
        if (showAchievement==YES) {
            [self showAchievements];
        }
        else if (showLeaderboard==YES){
            [self showLeaderboard];
        }
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
    if ([userDefaults objectForKey:@"easyLooses"]==nil) {
        [userDefaults setBool:YES forKey:@"sound"];
        [userDefaults setBool:YES forKey:@"music"];
        [userDefaults setBool:YES forKey:@"googleAnalitics"];
        [userDefaults setBool:YES forKey:@"push"];
        [userDefaults setInteger:0 forKey:@"easyVictory"];
        [userDefaults setInteger:0 forKey:@"mediumVictory"];
        [userDefaults setInteger:0 forKey:@"hardVictory"];
        [userDefaults setInteger:0 forKey:@"easyLooses"];
        [userDefaults setInteger:0 forKey:@"mediumLooses"];
        [userDefaults setInteger:0 forKey:@"hardLooses"];
        [userDefaults synchronize];
    }
    [[GameManager sharedInstance] setSettings];
    [MPManager sharedInstance].myScore=[[GPGScore alloc] initWithLeaderboardId:LEAD_LEADERBOARD];
}

- (void)showAchievements{
    GPGAchievementController *achController = [[GPGAchievementController alloc] init];
    achController.achievementDelegate = self;
    [self presentViewController:achController animated:YES completion:nil];
}

- (void)showLeaderboard{
    GPGLeaderboardController *leadController=[[GPGLeaderboardController alloc] initWithLeaderboardId:LEAD_LEADERBOARD];
    leadController.leaderboardDelegate=self;
    leadController.timeScope=GPGLeaderboardTimeScopeThisWeek;
    [self presentViewController:leadController animated:YES completion:nil];
}

@end
