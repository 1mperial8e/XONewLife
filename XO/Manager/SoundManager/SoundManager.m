//
//  SoundManager.m
//  XO
//
//  Created by Stas Volskyi on 07.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance loadSettings];
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

@end
