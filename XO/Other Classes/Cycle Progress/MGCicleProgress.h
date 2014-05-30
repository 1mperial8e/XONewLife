//
//  MGCicleProgress.h
//  Words
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 m2g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGCicleProgress : UIView

@property (nonatomic) float progress;
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic) double maxValue;
@property (nonatomic, strong) UIColor *color;

@end
