//
//  SoundManager.m
//  XO
//
//  Created by Stas Volskyi on 07.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "SoundManager.h"
#import <AVFoundation/AVFoundation.h>

static CGFloat const DefaultPlayerVolume = 0.6;

@interface SoundManager ()

@property (strong, nonatomic, nonnull) AVAudioPlayer *musicPlayer;
@property (strong, nonatomic, nonnull) AVAudioPlayer *soundPlayer;

@end

@implementation SoundManager

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance loadSettings];
        [sharedInstance initPlayers];
    });
    return sharedInstance;
}

#pragma mark - Public

- (void)turnSoundOn:(BOOL)on
{
    _isSoundOn = on;
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:SoundSettingsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)turnMusicOn:(BOOL)on
{
    _isMusicOn = on;
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:MusicSettingsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)playClickSound
{
    
}

#pragma mark - Private

- (void)loadSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:SoundSettingsKey]) {
        _isMusicOn = [userDefaults boolForKey:MusicSettingsKey];
        _isSoundOn = [userDefaults boolForKey:SoundSettingsKey];
    } else {
        [userDefaults setBool:YES forKey:SoundSettingsKey];
        [userDefaults setBool:YES forKey:MusicSettingsKey];
        [userDefaults synchronize];
        
        _isMusicOn = YES;
        _isSoundOn = YES;
    }
}

- (void)initPlayers
{
    NSError *error;
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    NSParameterAssert(musicPath);
    NSURL *musicUrl = [NSURL fileURLWithPath:musicPath];
    NSParameterAssert(musicUrl);

    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
    NSAssert(error == nil, @"Sound manager error. Can't create music player");
    
    self.musicPlayer.volume = DefaultPlayerVolume;
    [self.musicPlayer prepareToPlay];
}

@end
