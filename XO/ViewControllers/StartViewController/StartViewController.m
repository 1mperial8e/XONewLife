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

// Models
#import "GameModel.h"

@interface StartViewController () <UIAlertViewDelegate>

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - Actions

- (IBAction)settings:(id)sender
{
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)aboutButton:(id)sender
{
    [[SoundManager sharedInstance] playClickSound];
}

@end
