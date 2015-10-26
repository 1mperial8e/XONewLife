//
//  GameManager.h
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

@interface GameManager : NSObject{
    GADInterstitial *interstitial_;
    MyReachability *internetReachableFoo;
}

@property (nonatomic) BOOL sound;
@property (nonatomic) BOOL music;
@property (nonatomic) BOOL push;
@property (nonatomic) BOOL googleAnalitics;
@property (nonatomic, weak) NSString *googleUserName;
@property (nonatomic, weak) NSString *googleUserImage;
@property (nonatomic, strong) NSString *opponentName;
@property (nonatomic, strong) NSURL *opponentImage;
@property (nonatomic) XOGameMode mode;
@property (nonatomic, strong) XOProgress *progress;
@property (nonatomic) int firstPlayerVictory;
@property (nonatomic) int secondPlayerVictory; 
@property (nonatomic) int myRoll;
@property (nonatomic) BOOL iTurnFirst;
@property (nonatomic) id<GAITracker> tracker;

+ (GameManager*)sharedInstance;
- (void) setSettings;
- (void) tryToBeFirst;
- (void) trackScreenWithName:(NSString*)name;
- (void) setInterstitialDelegate:(id)delegate;
- (void) showFullScreenADVOnViewController:(UIViewController*)viewController;
- (void) loadFullScreenADV;
- (void)testInternetConnection;

@end
