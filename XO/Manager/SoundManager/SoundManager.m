//
//  SoundManager.m
//  XO
//
//  Created by Stas Volskyi on 07.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "SoundManager.h"
#import <AVFoundation/AVFoundation.h>

static CGFloat const DefaultPlayerVolume = 0.6F;

@interface SoundManager ()

// MARK: players
@property (strong, nonatomic, nonnull) AVAudioPlayer *musicPlayer;
@property (strong, nonatomic, nonnull) AVAudioPlayer *clickSoundPlayer;
@property (strong, nonatomic, nonnull) AVAudioPlayer *xTurnSoundPlayer;
@property (strong, nonatomic, nonnull) AVAudioPlayer *oTurnSoundPlayer;

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
    
    if (on) {
        self.musicPlayer.currentTime = 0;
        [self.musicPlayer play];
    } else {
        [self.musicPlayer stop];
    }
}

- (void)playClickSound
{
    if (self.isSoundOn) {
        [self.clickSoundPlayer play];
    }
}

- (void)playXTurnSound
{
    if (self.isSoundOn) {
        [self.xTurnSoundPlayer play];
    }
}

- (void)playOTurnSound
{
    if (self.isSoundOn) {
        [self.oTurnSoundPlayer play];
    }
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

#pragma mark - Players

- (void)initPlayers
{
    [self createMusicPlayer];
    [self createClickPlayer];
    [self createXTurnPlayer];
    [self createOTurnPlayer];
    
    if (self.isMusicOn) {
        [self.musicPlayer play];
    }
}

- (void)createMusicPlayer
{
    NSError *error;    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    NSParameterAssert(musicPath);
    NSURL *musicUrl = [NSURL fileURLWithPath:musicPath];
    
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
    NSAssert(error == nil, @"Sound manager error. Can't create music player");
    
    self.musicPlayer.volume = DefaultPlayerVolume;
    self.musicPlayer.numberOfLoops = MAXFLOAT;
    [self.musicPlayer prepareToPlay];
}

- (void)createClickPlayer
{
    NSError *error;
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"sound_click" ofType:@"mp3"];
    NSParameterAssert(soundPath);
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    self.clickSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    NSAssert(error == nil, @"Sound manager error. Can't create click sound player");
    
    self.clickSoundPlayer.volume = DefaultPlayerVolume;
    [self.clickSoundPlayer prepareToPlay];
}

- (void)createXTurnPlayer
{
    NSError *error;
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"sound_goes_x" ofType:@"mp3"];
    NSParameterAssert(soundPath);
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    self.xTurnSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    NSAssert(error == nil, @"Sound manager error. Can't create xTurn sound player");
    
    self.xTurnSoundPlayer.volume = DefaultPlayerVolume;
    [self.xTurnSoundPlayer prepareToPlay];
}

- (void)createOTurnPlayer
{
    NSError *error;
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"sound_goes_o" ofType:@"mp3"];
    NSParameterAssert(soundPath);
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    self.oTurnSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    NSAssert(error == nil, @"Sound manager error. Can't create oTurn sound player");
    
    self.oTurnSoundPlayer.volume = DefaultPlayerVolume;
    [self.oTurnSoundPlayer prepareToPlay];
}

@end
