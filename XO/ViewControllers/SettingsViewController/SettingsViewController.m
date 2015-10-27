//
//  TTSettengsViewController.m
//  XO
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "SettingsViewController.h"
#import "GameManager.h"

//Views
#import "SoundButton.h"

static NSString *const CheckedImageName = @"checked";
static NSString *const UnCheckedImageName = @"unchecked";

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet SoundButton *enableSound;
@property (weak, nonatomic) IBOutlet SoundButton *enableMusic;

@property (weak, nonatomic) IBOutlet UIImageView *soundCheck;
@property (weak, nonatomic) IBOutlet UIImageView *musicCheck;

@property (weak, nonatomic) IBOutlet SwitchControlView *difficultSwitchView;

@end

@implementation SettingsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateControlState];
    [self prepareDifficultSwitch];
    [self localizeUI];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - UIActions

- (void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)enableSound:(id)sender
{
    [self changeSettings:GAME_SOUND_SETTING_KEY];
}

- (IBAction)enableMusic:(id)sender
{
    [self changeSettings:GAME_MUSIC_SETTING_KEY];
}

#pragma mark - SwitchControlViewDelegate

- (void)switchControlDidTappedButton:(SoundButton *)button
{
    [self changeSettings:GAME_MODE_SETTING_KEY];
}

#pragma mark - Private

- (void)prepareDifficultSwitch
{
    self.difficultSwitchView.elementsCount = 2;
    self.difficultSwitchView.delegate = self;
    self.difficultSwitchView.activeElementTintColor = [UIColor blackColor];
    self.difficultSwitchView.inActiveElementTintColor = [UIColor lightGrayColor];
    self.difficultSwitchView.activeBackgroundImages = @[
                                                        [UIImage imageNamed:@"left_Active"],
                                                        [UIImage imageNamed:@"right_Active"]
                                                        ];
    self.difficultSwitchView.inActiveBackgroundImages = @[
                                                          [UIImage imageNamed:@"left_inActive"],
                                                          [UIImage imageNamed:@"right_inActive"]
                                                          ];
}

- (void)localizeUI
{
    self.difficultSwitchView.elementsNames = @[NSLocalizedString(@"settingViewController.Easy", nil), NSLocalizedString(@"settingViewController.Hard", nil)];
    [self.enableMusic setTitle:NSLocalizedString(@"settingViewController.Music", nil) forState:UIControlStateNormal];
    [self.enableSound setTitle:NSLocalizedString(@"settingViewController.Sound", nil) forState:UIControlStateNormal];
    self.title = NSLocalizedString(@"settingViewController.Title", nil);
}

- (void)changeSettings:(NSString*)settings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults integerForKey:settings] ? [userDefaults setInteger:0 forKey:settings] : [userDefaults setInteger:1 forKey:settings];
    [userDefaults synchronize];
    [self updateControlState];
}

- (void)updateControlState
{
    UIImage *checkedImage = [UIImage imageNamed:CheckedImageName];
    UIImage *unCheckedImage = [UIImage imageNamed:UnCheckedImageName];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    self.soundCheck.image = [userDefaults integerForKey:GAME_SOUND_SETTING_KEY] ? checkedImage : unCheckedImage;
    self.musicCheck.image = [userDefaults integerForKey:GAME_MUSIC_SETTING_KEY] ? checkedImage : unCheckedImage;

    [self.difficultSwitchView selectElementWithTag:([userDefaults integerForKey:GAME_MODE_SETTING_KEY] + 1)];
}

@end