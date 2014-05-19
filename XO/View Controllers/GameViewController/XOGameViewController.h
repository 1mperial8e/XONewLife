//
//  TTGameViewController.h
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XOGameFieldViewController.h"

@interface XOGameViewController : UIViewController

@property (weak, nonatomic) XOGameFieldViewController *gameFieldViewController;
@end
