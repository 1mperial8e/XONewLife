//
//  SoundManager.h
//  XO
//
//  Created by Stas Volskyi on 07.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundManager : NSObject

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic) SystemSoundID xTurnSound;
@property (nonatomic) SystemSoundID oTurnSound;
@property (nonatomic) SystemSoundID winSound;
@property (nonatomic) SystemSoundID looseSound;
@property (nonatomic) SystemSoundID clickSound;

+(SoundManager*)sharedInstance;
-(void)playMusic;
-(void)stopMusic;
-(void)playXTurnSound;
-(void)playOTurnSound;
-(void)playWinSound;
-(void)playLoseSound;
-(void)playClickSound;

@end
