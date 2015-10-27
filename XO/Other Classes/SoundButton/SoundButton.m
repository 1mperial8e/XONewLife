//
//  SoundButton.m
//  XO
//
//  Created by Kirill Gorbushko on 26.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
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