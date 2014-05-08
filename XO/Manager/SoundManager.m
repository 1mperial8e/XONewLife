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
            fileURL = [NSURL URLWithString:soundPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_instance->_clickSound);
            soundPath = [[NSBundle mainBundle] pathForResource:@"sound_goes_o" ofType:@"mp3"];
            fileURL = [NSURL URLWithString:soundPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_instance->_oTurnSound);
            soundPath = [[NSBundle mainBundle] pathForResource:@"sound_goes_x" ofType:@"mp3"];
            fileURL = [NSURL URLWithString:soundPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_instance->_xTurnSound);
            soundPath = [[NSBundle mainBundle] pathForResource:@"sound_win" ofType:@"mp3"];
            fileURL = [NSURL URLWithString:soundPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_instance->_winSound);
            soundPath = [[NSBundle mainBundle] pathForResource:@"sound_lose" ofType:@"mp3"];
            fileURL = [NSURL URLWithString:soundPath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_instance->_looseSound);

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
    if ([GameManager sharedInstance].sound==NO) {
        return;
    }
    AudioServicesPlaySystemSound(_instance->_xTurnSound);
}

-(void)playOTurnSound{
    if ([GameManager sharedInstance].sound==NO) {
        return;
    }
    AudioServicesPlaySystemSound(_instance->_oTurnSound);
}

-(void)playWinSound{
    if ([GameManager sharedInstance].sound==NO) {
        return;
    }
    AudioServicesPlaySystemSound(_instance->_winSound);
}

-(void)playLoseSound{
    if ([GameManager sharedInstance].sound==NO) {
        return;
    }
    AudioServicesPlaySystemSound(_instance->_looseSound);
}

-(void)playClickSound{
    if ([GameManager sharedInstance].sound==NO) {
        return;
    }
    AudioServicesPlaySystemSound(_instance->_clickSound);
}

- (void)dealloc{
    _player=nil;
    AudioServicesDisposeSystemSoundID(_instance->_clickSound);
    AudioServicesDisposeSystemSoundID(_instance->_xTurnSound);
    AudioServicesDisposeSystemSoundID(_instance->_oTurnSound);
    AudioServicesDisposeSystemSoundID(_instance->_winSound);
    AudioServicesDisposeSystemSoundID(_instance->_looseSound);
}

@end
