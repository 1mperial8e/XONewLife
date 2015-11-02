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
@property (strong, nonatomic, nonnull) AVAudioPlayer *victorySoundPlayer;
@property (strong, nonatomic, nonnull) AVAudioPlayer *looseSoundPlayer;

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

- (void)playWinSound
{
    if (self.isSoundOn) {
        [self.victorySoundPlayer play];
    }
}

- (void)playLooseSound
{
    if (self.isSoundOn) {
        [self.looseSoundPlayer play];
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
    self.musicPlayer = [self createMusicPlayerWithMusicName:@"music"];
    self.clickSoundPlayer = [self createMusicPlayerWithMusicName:@"sound_click"];
    self.xTurnSoundPlayer = [self createMusicPlayerWithMusicName:@"sound_goes_x"];
    self.oTurnSoundPlayer = [self createMusicPlayerWithMusicName:@"sound_goes_o"];
    self.victorySoundPlayer = [self createMusicPlayerWithMusicName:@"sound_win"];
    self.looseSoundPlayer = [self createMusicPlayerWithMusicName:@"sound_lose"];
    
    self.musicPlayer.numberOfLoops = MAXFLOAT;
    if (self.isMusicOn) {
        [self.musicPlayer play];
    }
}

- (AVAudioPlayer *)createMusicPlayerWithMusicName:(NSString *)fileName
{
    NSError *error;
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    NSParameterAssert(musicPath);
    NSURL *musicUrl = [NSURL fileURLWithPath:musicPath];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
    NSAssert(error == nil, @"Sound manager error. Can't create music player");
    
    player.volume = DefaultPlayerVolume;
    [player prepareToPlay];
    return player;
}

@end
