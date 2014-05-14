//
//  ADVManager.h
//  XO
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADVManager : NSObject
@property (strong, nonatomic) UIView *adv;
@property (strong, nonatomic) UIViewController *advRootViewController;
+ (ADVManager *)sharedInstance;
@end
