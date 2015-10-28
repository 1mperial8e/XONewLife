//
//  GameAchivementsManager.h
//  XO
//
//  Created by Kirill Gorbushko on 27.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

//Frameworks
#import <GameKit/GameKit.h>

static NSString *const AchivementIdentifierFirstGame = @"";
//to add more achivements here...

typedef void (^Result)(NSError *error);

@interface GameAchivements : NSObject <GKGameCenterControllerDelegate>

- (BOOL)isUserIdentificated;
- (void)authentificateUserWithViewController:(UIViewController *)presenter authResult:(Result)authResult;

- (void)reportScore:(int64_t)scoreToReport reportResult:(Result)result;

- (void)updateAchivementsWithIdentifier:(NSString *)identifier completeProgress:(CGFloat)progress reportResult:(Result)result;
- (void)resetAchivements:(Result)result;

- (void)showLeaderboardAndAchivements:(BOOL)showAchivementsBoard presenterViewController:(UIViewController *)presenter;

@end
