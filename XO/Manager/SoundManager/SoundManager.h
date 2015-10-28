//
//  SoundManager.h
//  XO
//
//  Created by Stas Volskyi on 07.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

@interface SoundManager : NSObject

@property (assign, nonatomic, readonly) BOOL isSoundOn;
@property (assign, nonatomic, readonly) BOOL isMusicOn;

+ (instancetype)sharedInstance;

- (void)turnSoundOn:(BOOL)on;
- (void)turnMusicOn:(BOOL)on;

// MARK: Play methods
- (void)playClickSound;
- (void)playXTurnSound;
- (void)playOTurnSound;

@end
