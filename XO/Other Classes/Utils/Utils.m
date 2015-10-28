//
//  Utils.m
//  XO
//
//  Created by Kirill Gorbushko on 27.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"

@implementation Utils

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
}

+ (UIView *)topView
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
}

#pragma mark - InformationView

+ (void)alertViewWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[Utils appName] message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"utils.buttonTitle.OK", nil) otherButtonTitles: nil] show];
    });
}

+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[Utils appName] message:message delegate:alertViewDelegate cancelButtonTitle:NSLocalizedString(@"utils.buttonTitle.OK", nil) otherButtonTitles: nil] show];
    });
}

+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[Utils appName] message:message delegate:alertViewDelegate cancelButtonTitle:NSLocalizedString(@"utils.buttonTitle.OK", nil) otherButtonTitles:otherButtonTitles, nil] show];
    });
}

@end
