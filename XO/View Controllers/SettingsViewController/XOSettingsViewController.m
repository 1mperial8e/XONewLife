//
//  TTSettengsViewController.m
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "XOSettingsViewController.h"
#import "XOStartViewController.h"
#import "XOGameViewController.h"
#import "GameManager.h"
#import "SoundManager.h"
#import "XOGameModel.h"
#import "XOGameFieldViewController.h"

@interface XOSettingsViewController () <SignedInDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signInOut;
@property (weak, nonatomic) IBOutlet UIButton *enableSound;
@property (weak, nonatomic) IBOutlet UIButton *enableMusic;
@property (weak, nonatomic) IBOutlet UIButton *enablePush;
@property (weak, nonatomic) IBOutlet UIButton *enableGoogleAnalitics;
@property (weak, nonatomic) IBOutlet UIImageView *soundCheck;
@property (weak, nonatomic) IBOutlet UIImageView *musicCheck;
@property (weak, nonatomic) IBOutlet UIImageView *pushCheck;
@property (weak, nonatomic) IBOutlet UIImageView *googleAnaliticsCheck;
@property (weak, nonatomic) IBOutlet UIButton *gameMode;
@property (weak, nonatomic) IBOutlet UIImageView *gameDifficulty;
@property (weak, nonatomic) IBOutlet UILabel *easyMode;
@property (weak, nonatomic) IBOutlet UILabel *hardMode;

- (IBAction)changeGameMode:(id)sender;
- (IBAction)signInOut:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)enableSound:(id)sender;
- (IBAction)enableMusic:(id)sender;
- (IBAction)enablePush:(id)sender;
- (IBAction)enableGoogleAnalitics:(id)sender;

@end

@implementation XOSettingsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setControlState];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    [self.easyMode setText:NSLocalizedString(@"Easy", nil)];
    [self.hardMode setText:NSLocalizedString(@"Hard", nil)];
    ((XOStartViewController*)[self.navigationController.viewControllers firstObject]).signedIndelegate=self;
}

- (void) viewWillAppear:(BOOL)animated{
    [[GameManager sharedInstance] trackScreenWithName:SETTINGS_SCREEN];
    if ([GameManager sharedInstance].mode==XOGameModeMultiplayer) {
        [self hideGameModeButton];
    }
    else{
        [self.gameMode setHidden:NO];
    }
    [[GameManager sharedInstance] testInternetConnection];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:SETTINGS_SCREEN value:@"Stopwatch"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - UIActions

- (IBAction)changeGameMode:(id)sender {
    [self changeSettings:@"mode"];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)signInOut:(id)sender {
    if ([GPPSignIn sharedInstance].userID.length){
        [self.signInOut setTitle:NSLocalizedString(@"Sign in", @"") forState:UIControlStateNormal];
        [[GPPSignIn sharedInstance] signOut];
    }
    else{
        [[GPPSignIn sharedInstance] authenticate];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[SoundManager sharedInstance] playClickSound];
}
- (IBAction)enableSound:(id)sender{
    [self changeSettings:@"sound"];
    [[SoundManager sharedInstance] playClickSound];
}
- (IBAction)enableMusic:(id)sender{
    [self changeSettings:@"music"];
    [[SoundManager sharedInstance] playClickSound];
}
- (IBAction)enablePush:(id)sender{
    [self changeSettings:@"push"];
    [[SoundManager sharedInstance] playClickSound];
}
- (IBAction)enableGoogleAnalitics:(id)sender{
    [self changeSettings:@"googleAnalitics"];
    [[SoundManager sharedInstance] playClickSound];
}

#pragma mark - Other methods

- (void) signedInGooglePlus{
    [self.signInOut setTitle:NSLocalizedString(@"Sign out", @"") forState:UIControlStateNormal];
}

- (void) hideGameModeButton{
    [self.gameMode setHidden:YES];
    [self.gameDifficulty setHidden:YES];
    [self.easyMode setHidden:YES];
    [self.hardMode setHidden:YES];
}

- (void)changeSettings:(NSString*)settings{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([settings isEqualToString:@"mode"]) {
        if ([userDefaults integerForKey:settings]==0){
            [userDefaults setInteger:2 forKey:settings];
        }
        else{
            [userDefaults setInteger:0 forKey:settings];
        }
        if ([GameManager sharedInstance].mode==XOGameModeSingle) {
            if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2 ] isKindOfClass:NSClassFromString(@"XOGameViewController")]){
                [[XOGameModel sharedInstance] clear];
                XOGameViewController *gameView=[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2 ];
                XOGameFieldViewController *gameFields=gameView.gameFieldViewController;
                [gameFields reload];
                if ([XOGameModel sharedInstance].aiGameMode == 2) {
                    [XOGameModel sharedInstance].aiGameMode = XOAIGameModeEasy;
                }
                else{
                    [XOGameModel sharedInstance].aiGameMode = XOAIGameModeHard;
                }
                [XOGameModel sharedInstance].player = XOPlayerFirst;
                [XOGameModel sharedInstance].me = XOPlayerFirst;
            }
        }
    }
    else{
        if ([userDefaults boolForKey:settings]==NO){
            [userDefaults setBool:YES forKey:settings];
        }else{
            [userDefaults setBool:NO forKey:settings];
        }
    }
    [userDefaults synchronize];
    [[GameManager sharedInstance] setSettings];
    [self setControlState];
}

- (void) setControlState{
    if ([[GPPSignIn sharedInstance] userID].length) {
        [self.signInOut setTitle:NSLocalizedString(@"Sign out", @"") forState:UIControlStateNormal];
    }
    else{
        [self.signInOut setTitle:NSLocalizedString(@"Sign in", @"") forState:UIControlStateNormal];
    }
    if ([GameManager sharedInstance].sound) {
        self.soundCheck.image=[UIImage imageNamed:@"checked"];
         }
    else{
        self.soundCheck.image=[UIImage imageNamed:@"unchecked"];
    }
    if ([GameManager sharedInstance].music) {
        self.musicCheck.image=[UIImage imageNamed:@"checked"];
    }
    else{
        self.musicCheck.image=[UIImage imageNamed:@"unchecked"];    }
    if ([GameManager sharedInstance].googleAnalitics) {
       self.googleAnaliticsCheck.image=[UIImage imageNamed:@"checked"];
    }
    else{
        self.googleAnaliticsCheck.image=[UIImage imageNamed:@"unchecked"];
    }
    if ([GameManager sharedInstance].push) {
        self.pushCheck.image=[UIImage imageNamed:@"checked"];
    }
    else{
        self.pushCheck.image=[UIImage imageNamed:@"unchecked"];
    }
    if ([XOGameModel sharedInstance].aiGameMode==0) {
        [self.easyMode setHidden:NO];
        [self.hardMode setHidden:YES];
        [self.gameDifficulty setImage:[UIImage imageNamed:@"easyMode"]];
        
    }
    else{
        [self.hardMode setHidden:NO];
        [self.easyMode setHidden:YES];
        [self.gameDifficulty setImage:[UIImage imageNamed:@"hardMode"]];
    }
}

@end
