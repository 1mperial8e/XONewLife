//
//  ScoreModel.h
//  XO
//
//  Created by Stas Volskyi on 10/28/15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

@interface ScoreModel : NSObject

@property (assign, nonatomic, readonly) NSInteger wins;
@property (assign, nonatomic, readonly) NSInteger looses;

+ (instancetype)modelWithScore:(NSString *)score;

- (void)updateWithScore:(NSString *)score;
- (void)updateWithNewVictory:(BOOL)isVictory;
- (NSString *)scoreString;

@end
