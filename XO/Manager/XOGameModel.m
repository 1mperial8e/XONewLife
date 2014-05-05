//
//  XOGameModel.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOGameModel.h"

@implementation XOGameModel
#pragma mark - Static
static XOGameModel *_instance=Nil;
#pragma mark - Lifecicle
#pragma mark - Custom Accsesors
- (int) gameColumns
{
    if (!_gameColumns) {
        _gameColumns = 3;
    }
    return _gameColumns;
}

#pragma mark - Class Methods
+ (XOGameModel*)sharedInstance{
    @synchronized(self) {
        if (_instance==nil) {
            _instance=[[self alloc] init];
        }
        return _instance;
    }
}
@end
