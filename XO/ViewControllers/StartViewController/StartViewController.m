//
//  StartViewController.m
//  XO
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

// Controllers
#import "StartViewController.h"
#import "GameViewController.h"
#import "GameAchivements.h"

@interface StartViewController ()

@property (nonatomic, weak) IBOutlet UIButton *singlePlayerButton;
@property (nonatomic, weak) IBOutlet UIButton *multiPlayerButton;
@property (nonatomic, weak) IBOutlet UIButton *onlinePlayButton;
@property (nonatomic, weak) IBOutlet UIButton *aboutButton;

@property (nonatomic, weak) IBOutlet UIButton *achivementsButton;
@property (nonatomic, weak) IBOutlet UIButton *leaderboardButton;
@property (nonatomic, weak) IBOutlet UIButton *settingsButton;

@end

@implementation StartViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self localizeUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // Will clean BLE services when back from lobby
    [[GameManager sharedInstance] cleanBLEServices];
}

#pragma mark - Actions

- (IBAction)achivementsButtonTapped:(id)sender
{
    GameAchivements *gameAchivements = [[GameAchivements alloc] init];
    [gameAchivements showLeaderboardAndAchivements:NO presenterViewController:self];
}

- (IBAction)leaderBoardButtonTapped:(id)sender
{
    GameAchivements *gameAchivements = [[GameAchivements alloc] init];
    [gameAchivements showLeaderboardAndAchivements:YES presenterViewController:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"singlePlayer"]) {
        GameViewController *gameVC = (GameViewController *)segue.destinationViewController;
        gameVC.gameMode = GameModeSingle;
    } else if ([segue.identifier isEqualToString:@"multiplayer"]) {
        GameViewController *gameVC = (GameViewController *)segue.destinationViewController;
        gameVC.gameMode = GameModeMultiplayer;
    }
}

#pragma mark - Private

- (void)localizeUI
{
    [self.achivementsButton setTitle:NSLocalizedString(@"startViewController.buttonTitle.Achivements", nil) forState:UIControlStateNormal];
    [self.leaderboardButton setTitle:NSLocalizedString(@"startViewController.buttonTitle.Leaderboard", nil) forState:UIControlStateNormal];
    [self.settingsButton setTitle:NSLocalizedString(@"startViewController.buttonTitle.Setting", nil) forState:UIControlStateNormal];
    [self.aboutButton setTitle:NSLocalizedString(@"startViewController.buttonTitle.About", nil) forState:UIControlStateNormal];
    [self.onlinePlayButton setTitle:NSLocalizedString(@"startViewController.buttonTitle.PlayOnline", nil) forState:UIControlStateNormal];
    [self.singlePlayerButton setTitle:NSLocalizedString(@"startViewController.buttonTitle.1Player", nil) forState:UIControlStateNormal];
    [self.multiPlayerButton setTitle:NSLocalizedString(@"startViewController.buttonTitle.2Player", nil) forState:UIControlStateNormal];
}

@end