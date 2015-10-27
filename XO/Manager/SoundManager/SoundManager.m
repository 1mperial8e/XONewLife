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
    });
    return sharedInstance;
}

- (void)playClickSound
{
    
}

@end
