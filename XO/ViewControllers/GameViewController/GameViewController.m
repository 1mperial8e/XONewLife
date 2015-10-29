//
//  TTGameViewController.m
//  XO
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

//Controllers
#import "GameViewController.h"
#import "SettingsViewController.h"

//Managers
#import "GameManager.h"
#import "SoundManager.h"

static NSString *const SettingButtonImageName = @"lightSettings";

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstplayerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerScoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstPlayerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondPlayerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gameScoreImageView;

@property (weak, nonatomic) IBOutlet UIView *gameFieldContainerView;

@end

@implementation GameViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNavigationItem];
    [self localizeUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - IBAction

- (void)settingButtonPressed:(UIBarButtonItem *)sender
{
    [[SoundManager sharedInstance] playClickSound];
    SettingsViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SettingsViewController class])];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

#pragma mark - Private

- (void)localizeUI
{
    self.title = NSLocalizedString(@"gameViewController.title", nil);
}

- (void)configureNavigationItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:SettingButtonImageName] style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonPressed:)];
}

@end