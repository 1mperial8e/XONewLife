//
//  ADVContainer.m
//  XO
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "ADVContainer.h"
@interface ADVContainer ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigth;
@end
@implementation ADVContainer
@synthesize hidden = _hidden;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (void)setHidden:(BOOL)hidden
{
    if (hidden) {
        self.heigth.constant = 0;
    } else {
        
        self.heigth.constant = self.frame.size.height;
    }
}
- (void)setHidden:(BOOL)hidden animate:(BOOL)animate
{
    if (animate) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setHidden:hidden];
            [self layoutIfNeeded];
        }];
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
