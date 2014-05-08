//
//  XOGameModel.h
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

//@interface XOPlayer : NSObject
//@property (nonatomic, weak) NSString *name;
//@property (nonatomic, weak) NSString *avatar;
//@property (nonatomic) int index;
//@property (nonatomic) BOOL turn;
//@end

#import <Foundation/Foundation.h>
#import "XOMatrix.h"
#import "XOGameFieldViewController.h"
#import "MPManager.h"
#import "Constants.h"

@protocol XOGameModelDelegate <NSObject>
@optional
- (void)gameOver;
- (void)changeValue:(int)value forPoint:(CGPoint)point;
- (void)playerWin:(XOPlayer)player;
- (void)willChangeValue:(int)value forIndexPath:(NSIndexPath *)indexPath;
- (void)didChangeValue:(int)value forIndexPath:(NSIndexPath *)indexPath;
@end

@protocol XOStepTimerDelegate <NSObject>
@optional
- (void)resetTimer;
- (void)stopTimer;
@end

@protocol weHaveVictory <NSObject>
@optional
- (void)drawVector:(XOVectorType)vectorType atLine:(int)line;
@end

@interface XOGameModel : NSObject <XOGameFieldViewControllerDelegate, GameDelegate>
@property (nonatomic, assign) int gameColumns;
@property (nonatomic, strong) NSDate *endGameTime;
@property (nonatomic) BOOL xTurn;
@property (nonatomic) XOPlayer player;
@property (nonatomic) XOPlayer winner;
@property (nonatomic) int dimension;
@property (nonatomic) XOGameMode gameMode;
@property (nonatomic, strong) XOMatrix *gameFieldMatrix;
@property (nonatomic, weak) id <XOGameModelDelegate> delegate;
@property (nonatomic, weak) id <XOStepTimerDelegate> timerDelegate;
@property (nonatomic, weak) id <weHaveVictory> victoryDelegate;

- (void)clear;
- (void)setMoveForIndexPath:(NSIndexPath *)indexPath;
+ (XOGameModel *)sharedInstance;
@end
