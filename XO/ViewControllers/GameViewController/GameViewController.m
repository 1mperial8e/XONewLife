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
@property (weak, nonatomic) IBOutlet UIImageView *playgroundImageView;

@property (weak, nonatomic) IBOutlet UIImageView *timerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gameScoreImageView;

@property (weak, nonatomic) IBOutlet UIView *gameScoreView;
@property (weak, nonatomic) IBOutlet UIView *gameFieldContainerView;
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// MARK: Multiplayer
@property (strong, nonatomic) BaseGameModel *multiplayer;
@property (strong, nonatomic) ScoreModel *multiplayerScore;
@property (assign, nonatomic) BOOL multiplayerChangedPlace;

//SinglePlayer
@property (strong, nonatomic) GameModelSinglePlayer *singlePlayer;
@property (assign, nonatomic) Player winner;

@property (strong, nonatomic) CAShapeLayer *victoryLineLayer;

@end

@implementation GameViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPlayersAvatars];
    [self configureNavigationItem];
    [self localizeUI];
 
    [self setupGameModel];
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
    [self singlePlayerTurnAtIndexPath:indexPath forPlayer:playerID victoryTurn:vector];
    [self multyPlayerTurnAtIndexPath:indexPath forPlayer:playerID victoryTurn:vector];
    
    [self animateVictoryIfNeededPlayer:playerID victoryTurn:vector];
}

- (void)gameModelDidFailMakeTurnAtIndexPath:(NSIndexPath *)indexPath forPlayer:(Player)playerID
{
    GameCollectionViewCell *selectedCell = (GameCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell.layer addAnimation:[self burstAnimWithStartPosition:selectedCell.layer.position] forKey:nil];
}

- (void)gameModelDidFinishGameWithPatResult
{
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

#pragma mark - Turns Logic

- (void)multyPlayerTurnAtIndexPath:(NSIndexPath *)indexPath forPlayer:(Player)playerID victoryTurn:(VictoryVectorType)vector
{
    if (self.multiplayer) {
        GameCollectionViewCell *selectedCell = (GameCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        BOOL fillWithCross = (playerID == PlayerFirst);
        fillWithCross = self.multiplayerChangedPlace ? !fillWithCross : fillWithCross;
        [selectedCell fillWithCross:fillWithCross];
        
        if (vector == VectorTypeNone) {
            if (playerID == PlayerSecond) {
                [self firstPlayerStep];
            } else {
                [self secondPlayerStep];
            }
        } else {
            [[SoundManager sharedInstance] playWinSound];
            [self.multiplayerScore updateWithNewVictory:(playerID == PlayerFirst)];
            [self updateMultiplayerScore];
        }
    }
}

- (void)singlePlayerTurnAtIndexPath:(NSIndexPath *)indexPath forPlayer:(Player)playerID victoryTurn:(VictoryVectorType)vector
{
    if (self.singlePlayer) {
        GameCollectionViewCell *selectedCell = (GameCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [selectedCell fillWithCross:(self.singlePlayer.playerOneSign == playerID)];
        
        if (vector == VectorTypeNone) {
            if (playerID == self.singlePlayer.playerOneSign) {
                [self firstPlayerStep];
            } else {
                [self secondPlayerStep];
            }
        } else {
            self.winner = playerID;
            [[SoundManager sharedInstance] playWinSound];
        }
    }
}

#pragma mark - PrepareGameModel

- (void)setupGameModel
{
    if (self.gameMode == GameModeMultiplayer || self.gameMode == GameModeSingle) {
        self.timerView.hidden = YES;
    }
    
    if (self.gameMode == GameModeMultiplayer) {
        self.multiplayer = [[BaseGameModel alloc] init];
        self.multiplayer.delegate = self;
        self.multiplayerChangedPlace = YES;
        
        self.multiplayerScore = [ScoreModel modelWithScore:@"0:0"];
        [self updateMultiplayerAvatars];
        [self updateMultiplayerScore];
        
    } else if (self.gameMode == GameModeSingle) {
        self.winner = PlayerNone;
        
        self.singlePlayer = [[GameModelSinglePlayer alloc] initWithPlayerOneSign:PlayerFirst AISign:PlayerSecond difficultLevel:[GameManager sharedInstance].aiLevel];
        self.singlePlayer.delegate = self;
        self.singlePlayer.activePlayer = PlayerSecond;
        
        [self updateSinglePlayerScore];
        [self updateSinglePlayerAvatars];
    }
}

#pragma mark - VictoryVectorDrawing

- (void)animateVictoryIfNeededPlayer:(Player)playerID victoryTurn:(VictoryVectorType)vector
{
    if (vector != VectorTypeNone) {
#ifdef DEBUG
        NSLog(@"Win player %i", (int)playerID);
#endif
        self.collectionView.userInteractionEnabled = NO;
        [self animateWinWithVictoryVector:vector];
    }
}

- (void)animateWinWithVictoryVector:(VictoryVectorType)victoryVector
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(self.playgroundImageView.bounds.origin.x, self.playgroundImageView.bounds.origin.y, self.playgroundImageView.bounds.size.width, self.playgroundImageView.bounds.size.height);
    imageLayer.backgroundColor = [UIColor clearColor].CGColor;
    UIImage *content = [[UIImage imageNamed:[self imageNameForVector:victoryVector]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageLayer.contents = (__bridge id __nullable)(content).CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    
    self.victoryLineLayer = [CAShapeLayer layer];
    self.victoryLineLayer.frame = imageLayer.frame;
    self.victoryLineLayer.backgroundColor = [UIColor redColor].CGColor;
    self.victoryLineLayer.mask = imageLayer;
    self.victoryLineLayer.position = [self centerForVictoryVector:victoryVector];
    
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
    } else if (self.singlePlayer) {
        [[GameManager sharedInstance] updateScoreForMode:[GameManager sharedInstance].aiLevel withVictory:self.winner];
        [self updateSinglePlayerScore];
        self.winner = PlayerNone;
    }
}

- (CGPoint)centerForVictoryVector:(VictoryVectorType)victoryVector
{
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    if (victoryVector == VectorTypeHorisontalZero) {
        yOffset = - self.gameFieldContainerView.bounds.size.height / 3;
    } else if (victoryVector == VectorTypeHorisontalSecond) {
        yOffset = self.gameFieldContainerView.bounds.size.height / 3;
    } else if (victoryVector == VectorTypeVerticalZero) {
        xOffset = - self.gameFieldContainerView.bounds.size.width / 3;
    } else if (victoryVector == VectorTypeVerticalSecond) {
        xOffset = self.gameFieldContainerView.bounds.size.width / 3;
    }
    CGPoint center = CGPointMake(self.collectionView.center.x + xOffset, self.collectionView.center.y + yOffset);
    return center;
}

- (NSString *)imageNameForVector:(VictoryVectorType)victoryVector
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
    }
    return imageName;
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

- (void)updateMultiplayerAvatars
{
    self.multiplayerChangedPlace = !self.multiplayerChangedPlace;
    if (self.multiplayerChangedPlace) {
        self.multiplayer.activePlayer = PlayerSecond;
    } else {
        self.multiplayer.activePlayer = PlayerFirst;
    }
    BOOL firstPlayerIsCross = self.multiplayer.activePlayer == PlayerFirst;
    
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

- (void)updateSinglePlayerAvatars
{
    UIImage *playerAvatar = [UIImage imageNamed:@"user"];
    UIImage *aiAvatar = [UIImage imageNamed:@"ai_1"];
    
    BOOL playerPosition = self.singlePlayer.playerOneSign == PlayerFirst;
    self.firstPlayerImageView.image = playerPosition ? playerAvatar : aiAvatar;
    self.secondPlayerImageView.image = playerPosition ? aiAvatar : playerAvatar;
    
    if (playerPosition) {
        [self firstPlayerStep];
    } else {
        [self secondPlayerStep];
    }
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

#pragma mark - Animation

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

#pragma mark - Score

- (void)updateMultiplayerScore
{
    self.firstPlayerScoreLabel.text = [NSString stringWithFormat:@"%li", self.multiplayerScore.wins];
    self.secondPlayerScoreLabel.text = [NSString stringWithFormat:@"%li", self.multiplayerScore.looses];
}

- (void)updateSinglePlayerScore
{
    self.firstPlayerScoreLabel.text = [NSString stringWithFormat:@"%li", [GameManager sharedInstance].currentScoreModel.wins];
    self.secondPlayerScoreLabel.text = [NSString stringWithFormat:@"%li", [GameManager sharedInstance].currentScoreModel.looses];
}

@end