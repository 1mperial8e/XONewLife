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

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet SoundButton *enableSoundButton;
@property (weak, nonatomic) IBOutlet SoundButton *enableMusicButton;
@property (weak, nonatomic) IBOutlet SoundButton *resetScoreButton;

@property (weak, nonatomic) IBOutlet UIImageView *soundCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *musicCheckImageView;

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
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    AlertViewController *alertVC = [[AlertViewController alloc] initWithTitle:NSLocalizedString(@"settingViewController.areYouSure", nil)
                                                                      message:nil
                                                            cancelButtonTitle:NSLocalizedString(@"settingViewController.notSure", nil)];
    [alertVC addButtonWithTitle:NSLocalizedString(@"settingViewController.yesSure", nil) completionHandler:^{
        [[GameManager sharedInstance] resetLocalScore];
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - SwitchControlViewDelegate

- (void)switchControlDidTappedButton:(SoundButton *)button
{
    __weak typeof(self) weakSelf = self;
    void (^ChangeAILevel)() = ^(){
        [[GameManager sharedInstance] aiLevelChanged:(AILevel)button.tag];
        [weakSelf updateControlState];
    };
    
    if (self.navigationController.viewControllers.count > 2) {
        AlertViewController *alertVC = [[AlertViewController alloc] initWithTitle:NSLocalizedString(@"settingViewController.aiLevelChangeNoticeTitle", nil)
                                                                          message:NSLocalizedString(@"settingViewController.currentGameWillBeLost", nil)
                                                                cancelButtonTitle:NSLocalizedString(@"settingViewController.notSure", nil)];
        [alertVC addButtonWithTitle:NSLocalizedString(@"settingViewController.yesSure", nil) completionHandler:^{
            ChangeAILevel();
            if (weakSelf.didChangeAIMode) {
                weakSelf.didChangeAIMode();
            }
        }];

        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        ChangeAILevel();
    }
    [self updateControlState];
}

#pragma mark - Private

- (void)prepareDifficultSwitch
{
    self.difficultSwitchView.elementsCount = 3;
    self.difficultSwitchView.delegate = self;
    self.difficultSwitchView.activeElementTintColor = [UIColor appButtonTextColor];
    self.difficultSwitchView.inActiveElementTintColor = [UIColor lightGrayColor];
    self.difficultSwitchView.activeBackgroundImages = @[
                                                        [UIImage imageNamed:@"left_button"],
                                                        [UIImage imageNamed:@"center_button"],
                                                        [UIImage imageNamed:@"right_button"]
                                                        ];
    self.difficultSwitchView.inActiveBackgroundImages = @[
                                                          [UIImage imageNamed:@"left_button_inactive"],
                                                          [UIImage imageNamed:@"center_button_inactive"],
                                                          [UIImage imageNamed:@"right_button_inactive"]
                                                          ];
}

- (void)localizeUI
{
    self.difficultSwitchView.elementsNames = @[NSLocalizedString(@"settingViewController.Easy", nil), NSLocalizedString(@"settingViewController.Medium", nil), NSLocalizedString(@"settingViewController.Hard", nil)];
    [self.enableMusicButton setTitle:NSLocalizedString(@"settingViewController.Music", nil) forState:UIControlStateNormal];
    [self.enableSoundButton setTitle:NSLocalizedString(@"settingViewController.Sound", nil) forState:UIControlStateNormal];
    [self.resetScoreButton setTitle:NSLocalizedString(@"settingViewController.resetScore", nil) forState:UIControlStateNormal];
    self.title = NSLocalizedString(@"settingViewController.Title", nil);
}

- (void)updateControlState
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.soundCheckImageView.alpha = [SoundManager sharedInstance].isSoundOn;
        weakSelf.musicCheckImageView.alpha = [SoundManager sharedInstance].isMusicOn;
    }];

    [self.difficultSwitchView selectElementWithTag:[GameManager sharedInstance].aiLevel];
}

@end