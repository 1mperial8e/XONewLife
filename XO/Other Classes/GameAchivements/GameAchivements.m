//
//  GameAchivementsManager.m
//  XO
//
//  Created by Kirill Gorbushko on 27.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

//ViewControllers
#import "GameAchivements.h"

static CGFloat const BannerDispayingDuratin = 2.0;

@interface GameAchivements()

@property (assign, nonatomic) BOOL gameCenterEnabled;
@property (copy, nonatomic) NSString *gameCentreLeaderBoardIdentifier;

@end

@implementation GameAchivements

#pragma mark - Public

+ (instancetype)sharedManager
{
    static GameAchivements *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[GameAchivements alloc] init];
    });
    return sharedManager;
}

#pragma mark - Authentifications

- (BOOL)isUserIdentificated
{
    return self.gameCentreLeaderBoardIdentifier.length;
}

- (void)authentificateUserWithViewController:(UIViewController *)presenter authResult:(Result)authResult
{
    __weak typeof(self) weakSelf = self;
    void (^GetLeaderBoardIdentifier)() = ^() {
        if ([GKLocalPlayer localPlayer].authenticated) {
            weakSelf.gameCenterEnabled = YES;
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                if (!error) {
                    weakSelf.gameCentreLeaderBoardIdentifier = leaderboardIdentifier;
                }
                authResult(error);
            }];
        }
    };
    
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    player.authenticateHandler = ^ (UIViewController *viewController, NSError *error) {
        if (viewController) {
            [presenter presentViewController:viewController animated:YES completion:nil];
        } else {
            GetLeaderBoardIdentifier();
        }
    };
}

#pragma mark - Report

- (void)reportScore:(int64_t)scoreToReport reportResult:(Result)result
{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:self.gameCentreLeaderBoardIdentifier];
    score.value = scoreToReport;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError * _Nullable error) {
        result(error);
    }];
}

#pragma mark - Achivements

- (void)updateAchivementsWithIdentifier:(NSString *)identifier completeProgress:(CGFloat)progress reportResult:(Result)result
{
    GKAchievement *gamePlayerAchivement = [[GKAchievement alloc] initWithIdentifier:identifier];
    gamePlayerAchivement.percentComplete = progress;
    
    [GKAchievement reportAchievements:@[gamePlayerAchivement] withCompletionHandler:^(NSError * _Nullable error) {
        result(error);
    }];
}

- (void)resetAchivements:(Result)result
{
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
        result(error);
    }];
}

#pragma mark - PresentStatistics

- (void)showLeaderboardAndAchivements:(BOOL)showAchivementsBoard presenterViewController:(UIViewController *)presenter
{
    void (^PresentController)() = ^(){
        GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
        gameCenterViewController.gameCenterDelegate = self;
        if (showAchivementsBoard) {
            gameCenterViewController.viewState = GKGameCenterViewControllerStateAchievements;
        } else {
            gameCenterViewController.leaderboardIdentifier = self.gameCentreLeaderBoardIdentifier;
            gameCenterViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        }
        [presenter presentViewController:gameCenterViewController animated:YES completion:nil];
    };
    
    if ([self isUserIdentificated]) {
        PresentController();
    } else {
        [self authentificateUserWithViewController:presenter authResult:^(NSError *error) {
            if (error) {
                [Utils alertViewWithMessage:error.localizedDescription];
            } else {
                PresentController();
            }
        }];
    }
}

#pragma mark - GKGameCenterControllerDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

#pragma mark - Banners

- (void)showNotificationBanner:(NSString *)message
{
    [GKNotificationBanner showBannerWithTitle:NSLocalizedString(@"gameAchivement.bannerTitle", nil) message:message duration:BannerDispayingDuratin completionHandler:nil];
}

@end