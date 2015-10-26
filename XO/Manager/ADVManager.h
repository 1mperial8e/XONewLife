//
//  ADVManager.h
//  XO
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerView.h"
@interface ADVManager : NSObject
@property (strong, nonatomic) GADBannerView *adv;
@property (strong, nonatomic) UIViewController *advRootViewController;
- (void)load;
+ (ADVManager *)sharedInstance;
@end
