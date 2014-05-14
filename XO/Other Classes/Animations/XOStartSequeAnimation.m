//
//  XOStartSequeAnimation.m
//  XO
//
//  Created by Misha on 13.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOStartSequeAnimation.h"

@implementation XOStartSequeAnimation

- (id) initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
	if (self) {
		
	}
	return self;
}
- (void) perform {
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
        //[self.destinationViewController view].alpha = 1;
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
