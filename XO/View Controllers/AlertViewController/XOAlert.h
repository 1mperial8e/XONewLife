//
//  XOAlert.h
//  XO
//
//  Created by Misha on 12.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XOAlert : UIViewController
- (id) initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)oserTitle, ...;

@end
