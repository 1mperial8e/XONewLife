//
//  TTViewController.m
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "XOStartViewController.h"
#import "XOGameViewController.h"
#import "XOOnlineLobbyViewController.h"
#import "XOSettingsViewController.h"
#import "GameManager.h"
#import "GTLPlusPerson.h"
#import "XOGameModel.h"
#import "SoundManager.h"

@interface XOStartViewController () <GPGAchievementControllerDelegate, GPGLeaderboardControllerDelegate, UIAlertViewDelegate>{
    BOOL showAchievement;
    BOOL showLeaderboard;
    BOOL goToLobby;
}
@property (nonatomic, weak) IBOutlet UIButton *single;
@property (nonatomic, weak) IBOutlet UIButton *multi;
@property (nonatomic, weak) IBOutlet UIButton *online;
@property (nonatomic, weak) IBOutlet UIButton *ach;
@property (nonatomic, weak) IBOutlet UIButton *leader;
@property (nonatomic, weak) IBOutlet UIButton *prefs;
@property (weak, nonatomic) IBOutlet UIButton *about;

- (IBAction)leaderboardButton:(id)sender;
- (IBAction)achievementsButton:(id)sender;
- (IBAction)singlePlayer:(id)sender;
- (IBAction)twoPlayers:(id)sender;
- (IBAction)playOnline:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)aboutButton:(id)sender;


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
    goToLobby=NO;
    
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[GameManager sharedInstance] trackScreenWithName:START_SCREEN];
}

#pragma mark - WebView methods


-(void)onReceivedAd
{
    NSLog(@"SADView  onReceivedAd");
    [[self.view viewWithTag:135] setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        
        [[self.view viewWithTag:135].superview layoutIfNeeded];
    }];

}

-(void)onShowedAd
{
    NSLog(@"SADView  onShowedAd");
}

/*-(void)onError:(SADVIEW_ERROR)error
{
    NSLog(@"SADView error: %d", error);
}*/

-(void)onAdClicked
{
    NSLog(@"SADView  onAdClicked");
}

-(void)noAdFound
{
    NSLog(@"SADView  noAdFound");
    [[self.view viewWithTag:135] setHidden:NO];
    [UIView animateWithDuration:7 animations:^{
        [[self.view viewWithTag:135].superview layoutIfNeeded];
    }];
}

#pragma mark - UIActions

- (IBAction)leaderboardButton:(id)sender{
    [[SoundManager sharedInstance] playClickSound];
    if (![[GPGManager sharedInstance] isSignedIn]) {
        showLeaderboard=YES;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NoConnection", nil) message:NSLocalizedString(@"forLeader", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"CancelLogin", nil) otherButtonTitles:NSLocalizedString(@"Sign in", nil) , nil];
        [alert show];
    }
    else{
        [self showLeaderboard];
    }
    [self resetBtnStatus];
}

- (IBAction)achievementsButton:(id)sender{
    [[SoundManager sharedInstance] playClickSound];
    if (![[GPGManager sharedInstance] isSignedIn]) {
        showAchievement=YES;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NoConnection", nil) message:NSLocalizedString(@"forAch", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"CancelLogin", nil) otherButtonTitles:NSLocalizedString(@"Sign in", nil) , nil];
        [alert show];
    }
    else{
        [self showAchievements];
    }
    [self resetBtnStatus];
}

- (IBAction)singlePlayer:(id)sender {
    [[GameManager sharedInstance].interstitial_ presentFromRootViewController:self];
    [GameManager sharedInstance].mode=XOGameModeSingle;
    [XOGameModel sharedInstance].gameMode = XOGameModeSingle;
    if ([XOGameModel sharedInstance].aiGameMode == 0) {
        [XOGameModel sharedInstance].aiGameMode = XOAIGameModeEasy;
    }
    else{
        [XOGameModel sharedInstance].aiGameMode = XOAIGameModeHard;    }
    [XOGameModel sharedInstance].player = XOPlayerFirst;
    [XOGameModel sharedInstance].me = XOPlayerFirst;
    [[SoundManager sharedInstance] playClickSound];
    [self resetBtnStatus];
}

- (IBAction)twoPlayers:(id)sender {
    [[GameManager sharedInstance].interstitial_ presentFromRootViewController:self];
    [GameManager sharedInstance].mode=XOGameModeMultiplayer;
    [XOGameModel sharedInstance].gameMode = XOGameModeMultiplayer;
    [XOGameModel sharedInstance].me = XOPlayerNone;
    [[XOGameModel sharedInstance] multiplayerNewGame];
    [GameManager sharedInstance].firstPlayerVictory=0;
    [GameManager sharedInstance].secondPlayerVictory=0;
    [[SoundManager sharedInstance] playClickSound];
    XOGameViewController *gameView=[[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"game"];
    [self.navigationController pushViewController:gameView animated:YES];
    [self resetBtnStatus];
}

- (IBAction)playOnline:(id)sender {
    [[GameManager sharedInstance].interstitial_ presentFromRootViewController:self];
    if (![[GPGManager sharedInstance] isSignedIn])
    {
        goToLobby=YES;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NoConnection", nil) message:NSLocalizedString(@"forPlaying", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"CancelLogin", nil) otherButtonTitles:NSLocalizedString(@"Sign in", nil) , nil];
        [alert show];
    }
    else{
        [self goToLobbyScreen];
    }
    [self resetBtnStatus];
}

- (IBAction)settings:(id)sender {
    [[SoundManager sharedInstance] playClickSound];
    [self resetBtnStatus];
}

- (IBAction)aboutButton:(id)sender {
    [self resetBtnStatus];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction) pressed: (id) sender
{
    if (sender == self.single)
    {
    	self.multi.enabled = false;
    	self.online.enabled = false;
        self.about.enabled = false;
        self.leader.enabled = false;
        self.ach.enabled = false;
        self.prefs.enabled = false;
    }
    else if (sender == self.multi)
    {
    	self.single.enabled = false;
    	self.online.enabled = false;
        self.about.enabled = false;
        self.leader.enabled = false;
        self.ach.enabled = false;
        self.prefs.enabled = false;
    }
    else if (sender == self.online)
    {
    	self.multi.enabled = false;
    	self.single.enabled = false;
        self.about.enabled = false;
        self.leader.enabled = false;
        self.ach.enabled = false;
        self.prefs.enabled = false;
    }
    else if (sender == self.about)
    {
        self.multi.enabled = false;
    	self.online.enabled = false;
        self.single.enabled = false;
        self.leader.enabled = false;
        self.ach.enabled = false;
        self.prefs.enabled = false;
    }
    else if (sender == self.leader)
    {
        self.multi.enabled = false;
    	self.online.enabled = false;
        self.single.enabled = false;
        self.about.enabled = false;
        self.ach.enabled = false;
        self.prefs.enabled = false;
    }
    else if (sender == self.ach)
    {
        self.multi.enabled = false;
    	self.online.enabled = false;
        self.single.enabled = false;
        self.about.enabled = false;
        self.leader.enabled = false;
        self.prefs.enabled = false;
    }
    else if (sender == self.prefs)
    {
        self.multi.enabled = false;
    	self.online.enabled = false;
        self.single.enabled = false;
        self.about.enabled = false;
        self.leader.enabled = false;
        self.ach.enabled = false;
    }
}

- (IBAction)touchUpOutside:(id)sender{
    [self resetBtnStatus];
}

- (void) resetBtnStatus{
    self.multi.enabled = true;
    self.online.enabled = true;
    self.single.enabled = true;
    self.about.enabled = true;
    self.leader.enabled = true;
    self.ach.enabled = true;
    self.prefs.enabled=true;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            showLeaderboard=NO;
            showAchievement=NO;
            goToLobby=NO;
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
        else if (goToLobby==YES){
            [self goToLobbyScreen];
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

#pragma mark - GADInterstitialDelegate

- (void) interstitialDidReceiveAd:(GADInterstitial *)ad{
    NSLog(@"recieve ad");
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"%@",error);
}

#pragma mark - AchievmentDelegate

- (void)achievementViewControllerDidFinish: (GPGAchievementController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[SoundManager sharedInstance] playClickSound];
}

#pragma mark - Other Methods

- (void) goToLobbyScreen{
    goToLobby=NO;
    [GameManager sharedInstance].mode=XOGameModeOnline;
    [XOGameModel sharedInstance].gameMode = XOGameModeOnline;
    [XOGameModel sharedInstance].player = XOPlayerNone;
    [[SoundManager sharedInstance] playClickSound];
    XOOnlineLobbyViewController *lobby=[[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"lobby"];
    [self.navigationController pushViewController:lobby animated:YES];
}

- (void) getDefaultSettings{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:GAME_MODE]==nil) {
        [userDefaults setBool:YES forKey:@"sound"];
        [userDefaults setBool:YES forKey:@"music"];
        [userDefaults setBool:YES forKey:@"googleAnalitics"];
        [userDefaults setBool:YES forKey:@"push"];
        [userDefaults setInteger:0 forKey:GAME_MODE];
        [userDefaults setInteger:0 forKey:EASY_VICTORY];
        [userDefaults setInteger:0 forKey:@"mediumVictory"];
        [userDefaults setInteger:0 forKey:HARD_VICTORY];
        [userDefaults setInteger:0 forKey:EASY_LOOSES];
        [userDefaults setInteger:0 forKey:@"mediumLooses"];
        [userDefaults setInteger:0 forKey:HARD_LOOSES];
        [userDefaults setInteger:0 forKey:MULTIPLAYER_GAMES];
        [userDefaults synchronize];
    }
    [[GameManager sharedInstance] setSettings];
    [MPManager sharedInstance].myScore=[[GPGScore alloc] initWithLeaderboardId:LEAD_LEADERBOARD];
}

- (void)showAchievements{
    [[GameManager sharedInstance] trackScreenWithName:ACHIEVEMENTS_SCREEN];
    GPGAchievementController *achController = [[GPGAchievementController alloc] init];
    achController.achievementDelegate = self;
    [self presentViewController:achController animated:YES completion:nil];
}

- (void)showLeaderboard{
    [[GameManager sharedInstance] trackScreenWithName:LEADERBOARD_SCREEN];
    GPGLeaderboardController *leadController=[[GPGLeaderboardController alloc] initWithLeaderboardId:LEAD_LEADERBOARD];
    leadController.leaderboardDelegate=self;
    leadController.timeScope=GPGLeaderboardTimeScopeThisWeek;
    [self presentViewController:leadController animated:YES completion:nil];
}

@end
