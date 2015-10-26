//
//  XOAlertView.m
//  XO
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "XOAlertView.h"

@implementation XOAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *a = self.subviews;
        for (UIView *v in a) {
            NSLog(@"%@", v);
            v.backgroundColor = [UIColor redColor];
        }
    }
    return self;
}


@end
