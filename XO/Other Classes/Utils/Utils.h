//
//  Utils.h
//  XO
//
//  Created by Kirill Gorbushko on 27.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

@interface Utils : NSObject

+ (NSString *)appName;
+ (UIView *)topView;

#pragma mark - InformationView

+ (void)alertViewWithMessage:(NSString *)message;
+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate;
+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate otherButtonTitles:(NSString *)otherButtonTitles, ...;


@end
