//
//  GameManager.m
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

static GameManager* _instance=nil;

+ (GameManager*)sharedInstance{
    @synchronized(self) {
    if (_instance==nil) {
        _instance=[[self alloc] init];
    }
    return _instance;
    }
}

- (void) setSettings{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [GameManager sharedInstance].sound=[userDefaults boolForKey:@"sound"];
    [GameManager sharedInstance].music=[userDefaults boolForKey:@"music"];
    [GameManager sharedInstance].googleAnalitics=[userDefaults boolForKey:@"googleAnalitics"];
    [GameManager sharedInstance].push=[userDefaults boolForKey:@"push"];
    [GameManager sharedInstance].easyVictory=[userDefaults integerForKey:@"easyVictory"];
    [GameManager sharedInstance].mediumVictory=[userDefaults integerForKey:@"mediumVictory"];
    [GameManager sharedInstance].hardVictory=[userDefaults integerForKey:@"hardVictory"];
    [GameManager sharedInstance].onlineVictory=[userDefaults integerForKey:@"onlineVictory"];
}

- (void) updateProgress{
    NSString *key;
    NSInteger *value;
    if ([self.mode isEqualToString:ONLINE_PLAYERS]) {
        self.onlineVictory++;
        value=&self->_onlineVictory;
        key=ONLINE_VICTORY;
    }
    else if ([self.mode isEqualToString:SINGLE_PLAYER]) {
        if ([self.difficulty isEqualToString:EASY_MODE]){
            self.easyVictory++;
            value=&self->_easyVictory;
             key=EASY_VICTORY;
        }
        if ([self.difficulty isEqualToString:MEDIUM_MODE]){
            self.mediumVictory++;
            value=&self->_mediumVictory;
             key=MEDIUM_VICTORY;
        }
        if ([self.difficulty isEqualToString:HARD_MODE]){
            self.hardVictory++;
            value=&self->_hardVictory;
             key=HARD_VICTORY;
        }
    }
    [self saveProgress:key:value];
}

- (void)saveProgress:(NSString*)key :(NSInteger*)value{
    NSUserDefaults *userDefaults=[[NSUserDefaults alloc] init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:*value forKey:key];
    [userDefaults synchronize];
}

- (void)dealloc{
    _player=nil;
}

@end
