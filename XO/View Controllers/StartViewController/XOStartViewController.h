//
//  TTViewController.h
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "GAITrackedViewController.h"

@class GPGSignIn;

@interface XOStartViewController : GAITrackedViewController <GPPSignInDelegate>

@end
