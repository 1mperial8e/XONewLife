//
//  GameManager.h
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XOProgress.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "GADInterstitial.h"


@interface GameManager : NSObject

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
@property (nonatomic, strong) GADInterstitial *interstitial_;

+ (GameManager*)sharedInstance;
- (void) setSettings;
- (void) tryToBeFirst;
- (void) trackScreenWithName:(NSString*)name;

@end
