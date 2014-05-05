//
//  XOGameModel.h
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XOGameModel : NSObject
@property (nonatomic) int gameColumns;
@property (nonatomic, weak) NSDate *endGameTime;
@property (nonatomic) BOOL xTurn;
@property (nonatomic, weak) NSString *gameMode;
@property (nonatomic) int gameFieldValue;

+ (XOGameModel *)sharedInstance;
@end
