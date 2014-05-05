//
//  TTGameField.m
//  Tic tac toe
//
//  Created by Misha on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "TTBananasView.h"

@implementation TTBananasView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void) setMode:(int)mode
{
    if (mode>0) {
        self.backgroundColor = [UIColor redColor];
    } else if (mode<0){
        self.backgroundColor = [UIColor greenColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
