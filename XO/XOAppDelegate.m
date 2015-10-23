//
//  XOAppDelegate.m
//  XO
//
//  Created by Stas Volskyi on 03.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOAppDelegate.h"
//#import "MPManager.h"
#import <GooglePlus/GooglePlus.h>

@implementation XOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [GPGManager sharedInstance].realTimeRoomDelegate = [MPManager sharedInstance];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
