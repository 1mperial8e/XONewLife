//
//  UIColor+AppColor.m
//  XO
//
//  Created by Kirill Gorbushko on 27.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "UIColor+AppColor.h"

@implementation UIColor (AppColor)

#pragma mark - Public

+ (UIColor *)appNavigationBarTextColor
{
    return [UIColor colorWithRealRed:250 green:209 blue:166 alpha:1.0f];
}

+ (UIColor *)appButtonTextColor
{
    return [UIColor colorWithRealRed:68 green:28 blue:0 alpha:1.0f];
}

+ (UIColor *)activePlayerColor
{
    return [UIColor colorWithRealRed:0 green:128 blue:64 alpha:1.0f];
}

#pragma mark - Private

+ (UIColor *)colorWithRealRed:(int)red green:(int)green blue:(int)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:((float)red)/255.f green:((float)green)/255.f blue:((float)blue)/255.f alpha:((float)alpha)/1.f];
}

@end
