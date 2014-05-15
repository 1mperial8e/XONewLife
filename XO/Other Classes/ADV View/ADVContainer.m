//
//  ADVContainer.m
//  XO
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "ADVContainer.h"
#import "ADVManager.h"
#import "GADBannerView.h"

@interface ADVContainer ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigth;
@end
@implementation ADVContainer
@synthesize hidden = _hidden;
#pragma mark - Lifecicle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configureView];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureView];
    }
    return self;
}

#pragma mark - Custom Accsessors
- (void)setHidden:(BOOL)hidden
{
    if (hidden) {
        self.heigth.constant = 0;
    } else {
        self.heigth.constant = 50;
    }
    _hidden = hidden;
    
    //[self layoutIfNeeded];
}
- (void)setHidden:(BOOL)hidden animate:(BOOL)animate
{
    [self setHidden:hidden];
    [self setNeedsUpdateConstraints];
    if (animate) {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.superview layoutIfNeeded];
        }];
    } else {
        [self.superview layoutIfNeeded];
    }
}
#pragma mark - Private Methods
- (void)configureView
{
    [self setBackgroundColor:[UIColor redColor]];
    //[self setClipsToBounds:YES];
    
}
- (void)tapreaction:(UITapGestureRecognizer *)tap
{
    [self setHidden:!_hidden animate:YES];
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
