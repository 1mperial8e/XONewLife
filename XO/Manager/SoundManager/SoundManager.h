//
//  SoundManager.h
//  XO
//
//  Created by Stas Volskyi on 07.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundManager : NSObject

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *clickSoundPlayer;
@property (nonatomic, strong) AVAudioPlayer *xTurnSoundPlayer;
@property (nonatomic, strong) AVAudioPlayer *oTurnSoundPlayer;
@property (nonatomic, strong) AVAudioPlayer *winSoundPlayer;
@property (nonatomic, strong) AVAudioPlayer *looseSoundPlayer;
@property (nonatomic, weak) NSURL *clickSound;
@property (nonatomic, weak) NSURL *xTurnSound;
@property (nonatomic, weak) NSURL *oTurnSound;
@property (nonatomic, weak) NSURL *winSound;
@property (nonatomic, weak) NSURL *looseSound;


+(SoundManager*)sharedInstance;
-(void)playMusic;
-(void)stopMusic;
-(void)playXTurnSound;
-(void)playOTurnSound;
-(void)playWinSound;
-(void)playLoseSound;
-(void)playClickSound;
- (void)playXOSoundFor:(XOPlayer)player;

@end
