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

static CGFloat const PlayerImageAnimationTime = 0.30;

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

@property BOOL selected;

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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updatePlayersAvatars];
}

#pragma mark - IBAction

- (void)settingButtonPressed:(UIBarButtonItem *)sender
{
    [[SoundManager sharedInstance] playClickSound];
    SettingsViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SettingsViewController class])];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

#pragma mark - UI

- (void)configureNavigationItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:SettingButtonImageName]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(settingButtonPressed:)];
}

- (void)localizeUI
{
    self.title = NSLocalizedString(@"gameViewController.title", nil);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.selected) {
        [self secondPlayerStep];
    } else {
        [self firstPlayerStep];
    }
    self.selected = !self.selected;
}

#pragma mark - Players avatars

- (void)updatePlayersAvatars
{
    self.firstPlayerImageView.layer.cornerRadius = CGRectGetMidX(self.firstPlayerImageView.bounds);
    self.secondPlayerImageView.layer.cornerRadius = CGRectGetMidX(self.secondPlayerImageView.bounds);
    
    self.firstPlayerImageView.layer.masksToBounds = YES;
    self.secondPlayerImageView.layer.masksToBounds = YES;
    
    self.firstPlayerImageView.layer.borderWidth = 3.f;
    self.secondPlayerImageView.layer.borderWidth = 3.f;
    
    self.firstPlayerImageView.layer.borderColor = [UIColor appButtonTextColor].CGColor;
    self.secondPlayerImageView.layer.borderColor = [UIColor appButtonTextColor].CGColor;
}

- (void)firstPlayerStep
{
    CAAnimationGroup *firstPlayerAnim = [CAAnimationGroup animation];
    firstPlayerAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    firstPlayerAnim.duration = PlayerImageAnimationTime;
    firstPlayerAnim.animations = @[[self widthAnimFromValue:self.firstPlayerImageView.layer.borderWidth toValue:5.],
                                   [self colorAnimFromValue:self.firstPlayerImageView.layer.borderColor toValue:[UIColor greenColor].CGColor]];
    [self.firstPlayerImageView.layer addAnimation:firstPlayerAnim forKey:nil];
    self.firstPlayerImageView.layer.borderWidth = 5.;
    self.firstPlayerImageView.layer.borderColor = [UIColor greenColor].CGColor;
    
    CAAnimationGroup *secondPlayerAnim = [CAAnimationGroup animation];
    secondPlayerAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    secondPlayerAnim.duration = PlayerImageAnimationTime;
    secondPlayerAnim.animations = @[[self widthAnimFromValue:self.secondPlayerImageView.layer.borderWidth toValue:3.],
                                   [self colorAnimFromValue:self.secondPlayerImageView.layer.borderColor toValue:[UIColor appButtonTextColor].CGColor]];
    [self.secondPlayerImageView.layer addAnimation:secondPlayerAnim forKey:nil];
    self.secondPlayerImageView.layer.borderWidth = 3.;
    self.secondPlayerImageView.layer.borderColor = [UIColor appButtonTextColor].CGColor;
}

- (void)secondPlayerStep
{
    CAAnimationGroup *firstPlayerAnim = [CAAnimationGroup animation];
    firstPlayerAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    firstPlayerAnim.duration = PlayerImageAnimationTime;
    firstPlayerAnim.animations = @[[self widthAnimFromValue:self.firstPlayerImageView.layer.borderWidth toValue:3.],
                                   [self colorAnimFromValue:self.firstPlayerImageView.layer.borderColor toValue:[UIColor appButtonTextColor].CGColor]];
    [self.firstPlayerImageView.layer addAnimation:firstPlayerAnim forKey:nil];
    self.firstPlayerImageView.layer.borderWidth = 3.;
    self.firstPlayerImageView.layer.borderColor = [UIColor appButtonTextColor].CGColor;
    
    CAAnimationGroup *secondPlayerAnim = [CAAnimationGroup animation];
    secondPlayerAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    secondPlayerAnim.duration = PlayerImageAnimationTime;
    secondPlayerAnim.animations = @[[self widthAnimFromValue:self.secondPlayerImageView.layer.borderWidth toValue:5.],
                                    [self colorAnimFromValue:self.secondPlayerImageView.layer.borderColor toValue:[UIColor greenColor].CGColor]];
    [self.secondPlayerImageView.layer addAnimation:secondPlayerAnim forKey:nil];
    self.secondPlayerImageView.layer.borderWidth = 5.;
    self.secondPlayerImageView.layer.borderColor = [UIColor greenColor].CGColor;
}

- (CABasicAnimation *)widthAnimFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation *widthAnim = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    widthAnim.fromValue = @(fromValue);
    widthAnim.toValue = @(toValue);
    
    NSParameterAssert(widthAnim);
    return widthAnim;
}

- (CABasicAnimation *)colorAnimFromValue:(CGColorRef)fromValue toValue:(CGColorRef)toValue
{
    CABasicAnimation *colorAnim = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    colorAnim.fromValue = (__bridge id _Nullable)(fromValue);
    colorAnim.toValue =(__bridge id _Nullable)(toValue);
    
    NSParameterAssert(colorAnim);
    return colorAnim;
}

@end