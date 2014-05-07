//
//  GameManager.h
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GameManager : NSObject

@property (nonatomic, weak) NSString* difficulty;
@property (nonatomic) BOOL sound;
@property (nonatomic) BOOL music;
@property (nonatomic) BOOL push;
@property (nonatomic) BOOL googleAnalitics;
@property (nonatomic, weak) NSString *googleUserName;
@property (nonatomic, weak) NSString *googleUserImage;
@property (nonatomic, strong) NSString *opponentName;
@property (nonatomic, strong) NSURL *opponentImage;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, weak) NSString *mode;
@property (nonatomic) int easyVictory;
@property (nonatomic) int mediumVictory;
@property (nonatomic) int hardVictory;
@property (nonatomic) int onlineVictory;

+ (GameManager*)sharedInstance;
- (void) setSettings;
- (void) updateProgress;
- (void)saveData:(NSString*)dataSTR;
- (void) loadData;

@end
