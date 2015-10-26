//
//  XOAI.h
//  XO
//
//  Created by Misha on 11.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XOObjectiveMatrix.h"
typedef NSIndexPath* (^CreateMove)(int i, int j);
@interface XOAI : NSObject
@property (nonatomic, copy) CreateMove createMove;
- (NSIndexPath *)makeMove;
- (void)moveWithTimer:(int)maxTime;
@end
