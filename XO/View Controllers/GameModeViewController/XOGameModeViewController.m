//
//  XOGameModeViewController.m
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOGameModeViewController.h"
#import "GameManager.h"
#import "SoundManager.h"
#import "XOGameModel.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@interface XOGameModeViewController ()

@property (strong, nonatomic) IBOutlet UIButton *easy;
@property (strong, nonatomic) IBOutlet UIButton *medium;
@property (strong, nonatomic) IBOutlet UIButton *hard;
@property (weak, nonatomic) IBOutlet UIButton *back;

- (IBAction)back:(id)sender;
- (IBAction)easyMode:(id)sender;
- (IBAction)mediumMode:(id)sender;
- (IBAction)hardMode:(id)sender;

@end

@implementation XOGameModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:GAME_MODE_SCREEN value:@"Stopwatch"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (IBAction)easyMode:(id)sender{
    [GameManager sharedInstance].difficulty=EASY_MODE;
    [XOGameModel sharedInstance].aiGameMode = XOAIGameModeEasy;
    [XOGameModel sharedInstance].player = XOPlayerFirst;
    [XOGameModel sharedInstance].me = XOPlayerFirst;
    [[SoundManager sharedInstance] playClickSound];
    [self resetBtnStatus];
}

- (IBAction)mediumMode:(id)sender{
    [GameManager sharedInstance].difficulty=MEDIUM_MODE;
    [XOGameModel sharedInstance].aiGameMode = XOAIGameModeMedium;
    [XOGameModel sharedInstance].player = XOPlayerFirst;
    [XOGameModel sharedInstance].me = XOPlayerFirst;
    [[SoundManager sharedInstance] playClickSound];
    [self resetBtnStatus];
}

- (IBAction)hardMode:(id)sender{
    [GameManager sharedInstance].difficulty=HARD_MODE;
    [XOGameModel sharedInstance].aiGameMode = XOAIGameModeHard;
    [XOGameModel sharedInstance].player = XOPlayerFirst;
    [XOGameModel sharedInstance].me = XOPlayerFirst;
    [[SoundManager sharedInstance] playClickSound];
    [self resetBtnStatus];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction) pressed: (id) sender
{
    if (sender == self.easy)
    {
    	self.medium.enabled = false;
    	self.hard.enabled = false;
        self.back.enabled = false;
    }
    else if (sender == self.medium)
    {
    	self.easy.enabled = false;
    	self.hard.enabled = false;
        self.back.enabled = false;
    }
    else if (sender == self.back)
    {
    	self.easy.enabled = false;
        self.medium.enabled = false;
    	self.hard.enabled = false;
    }
    else
    {
    	self.easy.enabled = false;
    	self.medium.enabled = false;
        self.back.enabled = false;
    }
}

- (IBAction)touchUpOutside:(id)sender{
    [self resetBtnStatus];
}

- (void) resetBtnStatus{
    self.easy.enabled = true;
    self.medium.enabled = true;
    self.hard.enabled = true;
    self.back.enabled = true;
}

@end
