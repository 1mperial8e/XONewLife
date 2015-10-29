//
//  SoundButton.m
//  XO
//
//  Created by Kirill Gorbushko on 26.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "SoundButton.h"

@implementation SoundButton

#pragma mark - Override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[SoundManager sharedInstance] playClickSound];
    [super touchesBegan:touches withEvent:event];
}

@end