//
//  ScoreModel.m
//  XO
//
//  Created by Stas Volskyi on 10/28/15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "ScoreModel.h"

@implementation ScoreModel

#pragma mark - Init

+ (instancetype)modelWithScore:(NSString *)score
{
    return [[self alloc] initWithScore:score];
}

- (instancetype)initWithScore:(NSString *)score
{
    self = [super init];
    if (self) {
        [self updateWithScore:score];
    }
    return self;
}

- (void)updateWithScore:(NSString *)score
{
    NSParameterAssert(score);
    NSArray *components = [score componentsSeparatedByString:@":"];
    NSParameterAssert(components.count == 2);
    
    _wins = [components.firstObject integerValue];
    _looses = [components.lastObject integerValue];
}

- (void)updateWithNewVictory:(BOOL)isVictory
{
    if (isVictory) {
        _wins++;
    } else {
        _looses++;
    }
}

- (NSString *)scoreString
{
    return [NSString stringWithFormat:@"%li:%li", self.wins, self.looses];
}

@end
