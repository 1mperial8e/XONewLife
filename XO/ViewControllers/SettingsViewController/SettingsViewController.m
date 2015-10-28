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
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - UIActions

- (IBAction)enableSound:(id)sender
{
    [[SoundManager sharedInstance] turnSoundOn:![SoundManager sharedInstance].isSoundOn];
    [self updateControlState];
}

- (IBAction)enableMusic:(id)sender
{
    [[SoundManager sharedInstance] turnMusicOn:![SoundManager sharedInstance].isMusicOn];
    [self updateControlState];
}

#pragma mark - SwitchControlViewDelegate

- (void)switchControlDidTappedButton:(SoundButton *)button
{
    [[NSUserDefaults standardUserDefaults] setBool:![[NSUserDefaults standardUserDefaults] boolForKey:AIDifficultyKey] forKey:AIDifficultyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateControlState];
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

- (void)updateControlState
{
    UIImage *checkedImage = [UIImage imageNamed:CheckedImageName];
    UIImage *unCheckedImage = [UIImage imageNamed:UnCheckedImageName];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    self.soundCheck.image = [userDefaults integerForKey:SoundSettingsKey] ? checkedImage : unCheckedImage;
    self.musicCheck.image = [userDefaults integerForKey:MusicSettingsKey] ? checkedImage : unCheckedImage;

    [self.difficultSwitchView selectElementWithTag:([userDefaults integerForKey:AIDifficultyKey] + 1)];
}

@end