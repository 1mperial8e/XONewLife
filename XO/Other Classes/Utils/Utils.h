//
//  Utils.h
//  XO
//
//  Created by Kirill Gorbushko on 27.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface Utils : NSObject

+ (NSString *)appName;
+ (UIView *)topView;

#pragma mark - InformationView

+ (void)alertViewWithMessage:(NSString *)message;
+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate;
+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate otherButtonTitles:(NSString *)otherButtonTitles, ...;


@end
