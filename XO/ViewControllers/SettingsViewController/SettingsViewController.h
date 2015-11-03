//
//  TTSettengsViewController.h
//  XO
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//
#import "SwitchControlView.h"

@interface SettingsViewController : BaseViewController <SwitchControlViewDelegate>

@property (strong, nonatomic) void (^didChangeAIMode)();
@property (strong, nonatomic) void (^didResetScore)();

@end
