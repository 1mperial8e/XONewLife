//
//  TTViewController.h
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@class GPGSignIn;

@interface XOStartViewController : UIViewController <GPPSignInDelegate>

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomMargin;

@end
