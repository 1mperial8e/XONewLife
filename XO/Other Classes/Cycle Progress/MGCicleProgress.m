//
//  MGCicleProgress.m
//  Words
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 m2g. All rights reserved.
//

#import "MGCicleProgress.h"
#import <QuartzCore/QuartzCore.h>
@interface MGCicleProgress ()
@property (nonatomic, assign) CAShapeLayer *wellLayer;
@property (nonatomic, assign) CAShapeLayer *spinLayer;
@property (nonatomic) float wellThickness;
@end
@implementation MGCicleProgress

- (void)_commonInit
{
    CAShapeLayer *w = [CAShapeLayer layer];
    [[self layer] addSublayer:w];
    [w setStrokeColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor]];
    [w setFillColor:[[UIColor clearColor] CGColor]];
    [self setWellLayer:w];
    
    CAShapeLayer *s = [CAShapeLayer layer];
    [s setStrokeColor:[[UIColor colorWithRed:(225/255) green:(207/255) blue:(158/255) alpha:0] CGColor]];
    [s setFillColor:[[UIColor clearColor] CGColor]];
    [[self layer] addSublayer:s];
    [self setSpinLayer:s];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setWellThickness:4.0];
    [self setColor:[UIColor colorWithRed:(225.0/255.0) green:(207.0/255.0) blue:(158.0/255.0) alpha:1]];
    [self setProgress:0.0];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}



- (void)setWellThickness:(float)wellThickness
{
    _wellThickness = wellThickness;
    [[self spinLayer] setLineWidth:_wellThickness];
    [[self wellLayer] setLineWidth:_wellThickness];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [[self spinLayer] setStrokeColor:[_color CGColor]];
}
- (void)setMaxValue:(double)maxValue
{
    _maxValue = maxValue;
    [self setDoubleValue:maxValue];
}
-(void) setDoubleValue:(double)doubleValue
{
    _doubleValue = doubleValue;
    if(!_maxValue)
        _maxValue = 100;
    [self setProgress:(float) doubleValue/_maxValue animated:YES];
}
- (void)setProgress:(float)progress animated:(BOOL)animated
{
    float currentProgress = _progress;
    _progress = progress;
    
    [CATransaction begin];
    if(animated) {
        float delta = fabs(_progress - currentProgress);
        [CATransaction setAnimationDuration:MAX(0.2, delta * 1.0)];
    } else {
        [CATransaction setDisableActions:YES];
    }
    [[self spinLayer] setStrokeEnd:_progress];
    [CATransaction commit];
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (float)radius
{
    CGRect r = CGRectInset([self bounds], [self wellThickness] / 2.0, [self wellThickness] / 2.0);
    float w = r.size.width;
    float h = r.size.height;
    if(w > h)
        return h / 2.0;
    
    return w / 2.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float wt = [self wellThickness];
    CGRect outer = CGRectInset([self bounds], wt / 2.0, wt / 2.0);
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(outer), CGRectGetMidY(outer))
                                                             radius:[self radius]
                                                         startAngle:-M_PI_2 endAngle:(2.0 * M_PI - M_PI_2) clockwise:YES];
    [[self wellLayer] setPath:[outerPath CGPath]];
    [[self spinLayer] setPath:[outerPath CGPath]];
}

@end
