//
//  XOStartSequeAnimation.m
//  XO
//
//  Created by Misha on 13.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOStartSequeAnimation.h"
@interface XOStartSequeAnimation ()
@property CGPoint originatingPoint;
@end
@implementation XOStartSequeAnimation

- (id) initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
	if (self) {
		
	}
	return self;
}
/*- (void) perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    // Add the destination view as a subview, temporarily
    [sourceViewController.view addSubview:destinationViewController.view];
    
    // Transformation start scale
    destinationViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
    
    // Store original centre point of the destination view
    CGPoint originalCenter = destinationViewController.view.center;
    // Set center to start point of the button
    destinationViewController.view.center = CGPointMake(240, 320);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Grow!
                         destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         destinationViewController.view.center = originalCenter;
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
                        // [sourceViewController presentViewController:destinationViewController animated:NO completion:NULL]; // present VC
                     }];
}*/
- (void)perform
{
    float duration = 3;
    NSMutableArray *destSubviews = [NSMutableArray arrayWithArray:[[self.destinationViewController view] subviews]];
    NSMutableArray *sourseSubviews = [NSMutableArray arrayWithArray:[[self.sourceViewController view] subviews]];
    UIView *sourToTopView = [[self.sourceViewController view] viewWithTag:42];
    UIView *sourToButView = [[self.sourceViewController view] viewWithTag:43];
    
    [sourseSubviews removeObject:sourToButView];
    [sourseSubviews removeObject:sourToTopView];
    
    for (UIView *v in sourseSubviews) {
        float screenHeight = CGRectGetHeight([self.sourceViewController view].bounds);
        CGPoint newPosition;// = CGPointMake(v.layer.position.x, -250);
        if (CGRectGetMinY(v.frame)>screenHeight/2) {
            newPosition = CGPointMake(v.layer.position.x, screenHeight*1.5);
        } else {
            newPosition = CGPointMake(v.layer.position.x, -(screenHeight/2));
        }
        //CGPoint newPosition = CGPointMake(v.layer.position.x, -250);
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
        anim.fromValue = [NSValue valueWithCGPoint:v.layer.position];
        anim.toValue = [NSValue valueWithCGPoint:newPosition];
        anim.duration = arc4random()%(int)duration;
        [v.layer addAnimation:anim forKey:@"AnimateFrame"];
        [UIView animateWithDuration:duration animations:^{
            //v.alpha = 0;
        }];
    }
    for (UIView *v in destSubviews) {
        v.alpha = 0;
        float screenHeight = CGRectGetHeight([self.sourceViewController view].bounds);
        CGPoint newPosition;
        if (CGRectGetMidY(v.frame)>screenHeight/2) {
            newPosition = CGPointMake(v.layer.position.x, screenHeight*1.5);
        } else {
            newPosition = CGPointMake(v.layer.position.x, -(screenHeight/2));
        }
        //CGPoint newPosition = CGPointMake(v.layer.position.x, -250);
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
        anim.toValue = [NSValue valueWithCGPoint:v.layer.position];
        anim.fromValue = [NSValue valueWithCGPoint:newPosition];
        anim.duration = (duration/2)+arc4random()%(int)duration;
        [v.layer addAnimation:anim forKey:@"AnimateFrame"];
        [UIView animateWithDuration:duration animations:^{
            v.alpha = 1;
        }];
    }
    
    [self toTop:sourToTopView duration:duration];
    [self toBut:sourToButView duration:duration];
    //[self.destinationViewController view].alpha = 0;
    [self.destinationViewController view].layer.zPosition = 0;
    //[self.sourceViewController addChildViewController:self.destinationViewController];
    [[self.sourceViewController view] addSubview:[self.destinationViewController view]];
        [UIView animateWithDuration:duration animations:^{
            //[self.sourceViewController view].alpha = 0;
            //[self.destinationViewController view].alpha = 1;
        } completion:^(BOOL finished) {
            [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
            //[self.sourceViewController pushViewController:self.destinationViewController animated:NO];
        }];
    
}
- (void)toTop:(UIView *)view duration:(float)duration
{
    view.layer.zPosition = MAXFLOAT;
    CGPoint topNewPosition = CGPointMake(view.layer.position.x, view.layer.position.y-view.bounds.size.height);
    CABasicAnimation* theAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    theAnim.fromValue = [NSValue valueWithCGPoint:view.layer.position];
    theAnim.toValue = [NSValue valueWithCGPoint:topNewPosition];
    theAnim.duration = duration;
    [view.layer addAnimation:theAnim forKey:@"AnimateFrame"];
    view.layer.position = [theAnim.toValue CGPointValue];
    view.layer.zPosition = 0;
}
- (void)toBut:(UIView *)view duration:(float)duration
{
    view.layer.zPosition = MAXFLOAT;
    CGPoint butImNew = CGPointMake(view.layer.position.x, view.layer.position.y+view.bounds.size.height);
    CABasicAnimation* theAnimb = [CABasicAnimation animationWithKeyPath:@"position"];
    theAnimb.fromValue = [NSValue valueWithCGPoint:view.layer.position];
    theAnimb.toValue = [NSValue valueWithCGPoint:butImNew];
    theAnimb.duration = duration;
    theAnimb.removedOnCompletion = NO;
    [view.layer addAnimation:theAnimb forKey:@"AnimateFrame"];
    view.layer.position = [theAnimb.toValue CGPointValue];
    view.layer.zPosition = 0;
}
- (void) perform1 {
    //[self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
    //[self.destinationViewController view].alpha = 0;
    //[self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:nil];
    NSMutableArray *allViews = [NSMutableArray arrayWithArray:[[self.sourceViewController view] subviews]];
    NSMutableArray *allDestViews =[NSMutableArray arrayWithArray:[[self.destinationViewController view] subviews]];
    for (UIView *v in allDestViews) {
        v.alpha = 0;
    }
    UIImageView *topImage = (UIImageView *)[[self.sourceViewController view] viewWithTag:42];
    UIImageView *butImage = (UIImageView *)[[self.sourceViewController view] viewWithTag:43];
    [allViews removeObject:topImage];
    [allViews removeObject:butImage];
    [UIView animateWithDuration:.3 animations:^{
        for (UIView *v in allViews) {
            v.alpha = 0;
        }
        //[self.sourceViewController view].backgroundColor = [UIColor clearColor];
        CGPoint topNewPosition = CGPointMake(topImage.layer.position.x, topImage.layer.position.y-topImage.bounds.size.height);
        CABasicAnimation* theAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        theAnim.fromValue = [NSValue valueWithCGPoint:topImage.layer.position];
        theAnim.toValue = [NSValue valueWithCGPoint:topNewPosition];
        theAnim.duration = 0.3;
        [topImage.layer addAnimation:theAnim forKey:@"AnimateFrame"];
        
        CGPoint butImNew = CGPointMake(butImage.layer.position.x, butImage.layer.position.y+butImage.bounds.size.height);
        CABasicAnimation* theAnimb = [CABasicAnimation animationWithKeyPath:@"position"];
        theAnimb.fromValue = [NSValue valueWithCGPoint:butImage.layer.position];
        theAnimb.toValue = [NSValue valueWithCGPoint:butImNew];
        theAnimb.duration = 0.3;
        [butImage.layer addAnimation:theAnimb forKey:@"AnimateFrame"];
        topImage.alpha = 0;
        butImage.alpha = 0;
    } completion:^(BOOL finished) {
        topImage.alpha=0;
        butImage.alpha=0;
        [self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:nil];
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in allDestViews) {
                v.alpha = 1;
            }
        }];
        
    }];
    
}
@end
