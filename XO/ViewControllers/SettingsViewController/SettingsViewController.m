//
//  TTSettengsViewController.m
//  XO
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "SettingsViewController.h"

//Views
#import "SoundButton.h"

static NSString *const CheckedImageName = @"checked";
static NSString *const UnCheckedImageName = @"unchecked";

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet SoundButton *enableSoundButton;
@property (weak, nonatomic) IBOutlet SoundButton *enableMusicButton;
@property (weak, nonatomic) IBOutlet SoundButton *resetScoreButton;

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

#pragma mark - UIActions

- (IBAction)enableSoundAction:(id)sender
{
    [[SoundManager sharedInstance] turnSoundOn:![SoundManager sharedInstance].isSoundOn];
    [self updateControlState];
}

- (IBAction)enableMusicAction:(id)sender
{
    [[SoundManager sharedInstance] turnMusicOn:![SoundManager sharedInstance].isMusicOn];
    [self updateControlState];
}

- (IBAction)resetScoreAction:(id)sender
{
    AlertViewController *alertVC = [[AlertViewController alloc] initWithTitle:@"This is title"
                                                                      message:@"Here is some message that must be written in 2 lines"
                                                            cancelButtonTitle:@"Cancel"];
    [alertVC addButtonWithTitle:@"Ok" completionHandler:^{
        NSLog(@"Ok tapped");
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
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
    self.difficultSwitchView.activeElementTintColor = [UIColor appButtonTextColor];
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
    [self.enableMusicButton setTitle:NSLocalizedString(@"settingViewController.Music", nil) forState:UIControlStateNormal];
    [self.enableSoundButton setTitle:NSLocalizedString(@"settingViewController.Sound", nil) forState:UIControlStateNormal];
    [self.resetScoreButton setTitle:NSLocalizedString(@"settingViewController.resetScore", nil) forState:UIControlStateNormal];
    self.title = NSLocalizedString(@"settingViewController.Title", nil);
}

- (void)updateControlState
{
    UIImage *checkedImage = [UIImage imageNamed:CheckedImageName];
    UIImage *unCheckedImage = [UIImage imageNamed:UnCheckedImageName];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    self.soundCheck.image = [SoundManager sharedInstance].isSoundOn ? checkedImage : unCheckedImage;
    self.musicCheck.image = [SoundManager sharedInstance].isMusicOn ? checkedImage : unCheckedImage;

    [self.difficultSwitchView selectElementWithTag:([userDefaults integerForKey:AIDifficultyKey] + 1)];
}

@end