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

// Views
#import "GameCollectionViewCell.h"

//Models
#import "BaseGameModel.h"
#import "GameModelSinglePlayer.h"

static NSString *const SettingButtonImageName = @"lightSettings";

static NSString *const VictoryImageNameLeft = @"left";
static NSString *const VictoryImageNameRight = @"right";
static NSString *const VictoryImageNameHorizontal = @"horizontal";
static NSString *const VictoryImageNameVertical = @"vertical";

static CGFloat const PlayerImageAnimationTime = 0.30;

@interface GameViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GameModelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstplayerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerScoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstPlayerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondPlayerImageView;

@property (weak, nonatomic) IBOutlet UIImageView *timerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gameScoreImageView;

@property (weak, nonatomic) IBOutlet UIView *gameScoreView;
@property (weak, nonatomic) IBOutlet UIView *gameFieldContainerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) BaseGameModel *multiplayer;
@property (strong, nonatomic) GameModelSinglePlayer *singlePlayer;

@property (strong, nonatomic) CAShapeLayer *victoryLineLayer;

@property (assign, nonatomic) BOOL multiplayerChangedPlace;

@end

@implementation GameViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNavigationItem];
    [self localizeUI];
    [self setupPlayersAvatars];

    if (self.gameMode == GameModeMultiplayer) {
        self.multiplayer = [[BaseGameModel alloc] init];
        self.multiplayer.delegate = self;
        self.multiplayerChangedPlace = NO;
        [self updateMultiplayerAvatars];
    } else if (self.gameMode == GameModeSingle) {
        self.singlePlayer = [[GameModelSinglePlayer alloc] initWithPlayerOneSign:PlayerFirst AISign:PlayerSecond difficultLevel:[GameManager sharedInstance].aiLevel];
        self.singlePlayer.delegate = self;
        self.singlePlayer.activePlayer = PlayerSecond;
    }
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
    if (self.gameMode != GameModeOnline) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:SettingButtonImageName]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(settingButtonPressed:)];
    }
}

- (void)localizeUI
{
    self.title = NSLocalizedString(@"gameViewController.title", nil);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9; // 3x3 field
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GameCollectionViewCell.ID forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.gameMode == GameModeMultiplayer) {
        [self.multiplayer performTurnWithIndexPath:indexPath];
    } else if (self.gameMode == GameModeSingle) {
        [self.singlePlayer performTurnWithIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = CGRectGetWidth(self.gameFieldContainerView.bounds) / 3 - 1;
    return CGSizeMake(itemWidth, itemWidth * 0.8);
}

#pragma mark - GameModelDelegate

- (void)gameModelDidConfirmGameTurnAtIndexPath:(NSIndexPath *)indexPath forPlayer:(Player)playerID victoryTurn:(VictoryVectorType)vector
{
    GameCollectionViewCell *selectedCell = (GameCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (self.multiplayer) {
        BOOL fillWithCross = (playerID == PlayerFirst);
        fillWithCross = self.multiplayerChangedPlace ? !fillWithCross : fillWithCross;
        [selectedCell fillWithCross:fillWithCross];
        
        if (vector == VectorTypeNone) {
            if (playerID == PlayerSecond) {
                [self firstPlayerStep];
            } else {
                [self secondPlayerStep];
            }
        }
    }

    if (vector != VectorTypeNone) {
        NSLog(@"Win player %i", (int)playerID);
        self.collectionView.userInteractionEnabled = NO;
        [self animateWinWithVictoryVector:vector];
    }
}

- (void)gameModelDidFailMakeTurnAtIndexPath:(NSIndexPath *)indexPath forPlayer:(Player)playerID
{
    GameCollectionViewCell *selectedCell = (GameCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell.layer addAnimation:[self burstAnimWithStartPosition:selectedCell.layer.position] forKey:nil];
}

- (void)gameModelDidFinishGameWithPatResult
{
    NSLog(@"Pat");
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (void)gameModelWillStartAITurnAfterDelay:(int)delay
{
    self.collectionView.userInteractionEnabled = NO;
}

- (void)gameModelDidEndAITurn
{
    self.collectionView.userInteractionEnabled = YES;
}

#pragma mark - Animatins

- (void)animateWinWithVictoryVector:(VictoryVectorType)victoryVector
{
    NSString *imageName;
    if (victoryVector == VectorTypeDiagonalRight) {
        imageName = VictoryImageNameRight;
    } else if (victoryVector == VectorTypeDiagonalLeft) {
        imageName = VictoryImageNameLeft;
    } else if (victoryVector < 3) {
        imageName = VictoryImageNameHorizontal;
    } else {
        imageName = VictoryImageNameVertical;
    };

    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(self.collectionView.bounds.origin.x, self.collectionView.bounds.origin.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    imageLayer.backgroundColor = [UIColor clearColor].CGColor;
    UIImage *content = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageLayer.contents = (__bridge id __nullable)(content).CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    
    self.victoryLineLayer = [CAShapeLayer layer];
    self.victoryLineLayer.frame = imageLayer.frame;
    self.victoryLineLayer.backgroundColor = [UIColor redColor].CGColor;
    self.victoryLineLayer.mask = imageLayer;
    self.victoryLineLayer.position = self.collectionView.center;
    
    [self.collectionView.layer addSublayer:self.victoryLineLayer];
    [self performSelector:@selector(cleanUpCollectionView) withObject:nil afterDelay:2.f];
}

- (void)cleanUpCollectionView
{
    self.collectionView.userInteractionEnabled = YES;
    [self.victoryLineLayer removeFromSuperlayer];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
    if (self.multiplayer) {
        [self updateMultiplayerAvatars];
    }
}

#pragma mark - Players avatars

- (void)setupPlayersAvatars
{
    self.firstPlayerImageView.layer.masksToBounds = YES;
    self.secondPlayerImageView.layer.masksToBounds = YES;
    
    self.firstPlayerImageView.layer.borderWidth = 3.f;
    self.secondPlayerImageView.layer.borderWidth = 3.f;
    
    self.firstPlayerImageView.layer.borderColor = [UIColor appButtonTextColor].CGColor;
    self.secondPlayerImageView.layer.borderColor = [UIColor appButtonTextColor].CGColor;
}

- (void)updatePlayersAvatars
{
    self.firstPlayerImageView.layer.cornerRadius = CGRectGetMidX(self.firstPlayerImageView.bounds);
    self.secondPlayerImageView.layer.cornerRadius = CGRectGetMidX(self.secondPlayerImageView.bounds);
}

- (void)firstPlayerStep
{
    CAAnimationGroup *firstPlayerAnim = [CAAnimationGroup animation];
    firstPlayerAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    firstPlayerAnim.duration = PlayerImageAnimationTime;
    firstPlayerAnim.animations = @[[self widthAnimFromValue:self.firstPlayerImageView.layer.borderWidth toValue:5.],
                                   [self colorAnimFromValue:self.firstPlayerImageView.layer.borderColor toValue:[UIColor activePlayerColor].CGColor]];
    [self.firstPlayerImageView.layer addAnimation:firstPlayerAnim forKey:nil];
    self.firstPlayerImageView.layer.borderWidth = 5.;
    self.firstPlayerImageView.layer.borderColor = [UIColor activePlayerColor].CGColor;
    
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
                                    [self colorAnimFromValue:self.secondPlayerImageView.layer.borderColor toValue:[UIColor activePlayerColor].CGColor]];
    [self.secondPlayerImageView.layer addAnimation:secondPlayerAnim forKey:nil];
    self.secondPlayerImageView.layer.borderWidth = 5.;
    self.secondPlayerImageView.layer.borderColor = [UIColor activePlayerColor].CGColor;
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

- (CAKeyframeAnimation *)burstAnimWithStartPosition:(CGPoint)position
{
    CAKeyframeAnimation *burstAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    burstAnim.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(position.x + 5, position.y)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x - 5, position.y)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x + 3, position.y)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x - 3, position.y)],
                         [NSValue valueWithCGPoint:position]
                         ];
    burstAnim.duration = 0.3f;
    burstAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    burstAnim.removedOnCompletion = YES;
    return burstAnim;
}

- (void)updateMultiplayerAvatars
{
    BOOL firstPlayerIsCross = self.multiplayer.activePlayer == PlayerFirst;
    self.multiplayerChangedPlace = !firstPlayerIsCross;
    
    UIImage *crossPlayerImage = [UIImage imageNamed:@"xPlayer"];
    UIImage *zeroPlayerImage = [UIImage imageNamed:@"oPlayer"];
    
    self.firstPlayerImageView.image = firstPlayerIsCross ? crossPlayerImage : zeroPlayerImage;
    self.secondPlayerImageView.image = firstPlayerIsCross ? zeroPlayerImage : crossPlayerImage;
    
    if (firstPlayerIsCross) {
        [self firstPlayerStep];
    } else {
        [self secondPlayerStep];
    }
}

@end