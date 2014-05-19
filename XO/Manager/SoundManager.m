//
//  SoundManager.m
//  XO
//
//  Created by Stas Volskyi on 07.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "SoundManager.h"
#import "GameManager.h"

@implementation SoundManager

static SoundManager *_instance = nil;

+(SoundManager*)sharedInstance{
    @synchronized(self) {
        if (nil == _instance) {
            _instance = [[self alloc] init];
            NSError *error;
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
            NSURL *fileURL = [NSURL URLWithString:soundPath];
            _instance.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
            [_instance.player prepareToPlay];
            _instance.player.numberOfLoops=-1;
            soundPath = [[NSBundle mainBundle] pathForResource:@"sound_click" ofType:@"mp3"];
            _instance.clickSound = [NSURL URLWithString:soundPath];
            soundPath = [[NSBundle mainBundle] pathForResource:@"sound_goes_x" ofType:@"mp3"];
            _instance.xTurnSound = [NSURL URLWithString:soundPath];
            soundPath = [[NSBundle mainBundle] pathForResource:@"sound_goes_o" ofType:@"mp3"];
            _instance.oTurnSound = [NSURL URLWithString:soundPath];
            soundPath = [[NSBundle mainBundle] pathForResource:@"sound_win" ofType:@"mp3"];
            _instance.winSound = [NSURL URLWithString:soundPath];
            soundPath = [[NSBundle mainBundle] pathForResource:@"sound_lose" ofType:@"mp3"];
            _instance.looseSound = [NSURL URLWithString:soundPath];
            _instance.clickSoundPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:_instance.clickSound error:&error];
            [_instance.clickSoundPlayer prepareToPlay];
            _instance.clickSoundPlayer.numberOfLoops=0;
            _instance.xTurnSoundPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:_instance.xTurnSound error:&error];
            [_instance.xTurnSoundPlayer prepareToPlay];
            _instance.xTurnSoundPlayer.numberOfLoops=0;
            _instance.oTurnSoundPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:_instance.oTurnSound error:&error];
            [_instance.oTurnSoundPlayer prepareToPlay];
            _instance.oTurnSoundPlayer.numberOfLoops=0;
            _instance.winSoundPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:_instance.winSound error:&error];
            [_instance.winSoundPlayer prepareToPlay];
            _instance.winSoundPlayer.numberOfLoops=0;
            _instance.looseSoundPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:_instance.looseSound error:&error];
            [_instance.looseSoundPlayer prepareToPlay];
            _instance.looseSoundPlayer.numberOfLoops=0;
        }
    }
    return _instance;
}

-(void)playMusic{
    [_instance.player play];
}

-(void)stopMusic{
    [_instance.player stop];
}

-(void)playXTurnSound{
    if ([GameManager sharedInstance].sound==YES) {
        [_xTurnSoundPlayer play];
    }
}

-(void)playOTurnSound{
    if ([GameManager sharedInstance].sound==YES) {
        [_oTurnSoundPlayer play];
    }
}

-(void)playWinSound{
    if ([GameManager sharedInstance].sound==YES) {
        [_winSoundPlayer play];
    }
}

-(void)playLoseSound{
    if ([GameManager sharedInstance].sound==YES) {
        [_looseSoundPlayer play];
    }
}

-(void)playClickSound{
    if ([GameManager sharedInstance].sound==YES) {
        [_clickSoundPlayer play];
    }
}

- (void)playXOSoundFor:(XOPlayer)player
{
    switch (player) {
        case XOPlayerFirst:
            [self playXTurnSound];
            break;
        case XOPlayerSecond:
            [self playOTurnSound];
            break;
        default:
            break;
    }
}
- (void)dealloc{
    _player=nil;
    _clickSoundPlayer=nil;
    _looseSoundPlayer=nil;
    _winSoundPlayer=nil;
    _xTurnSoundPlayer=nil;
    _oTurnSoundPlayer=nil;
}

@end
