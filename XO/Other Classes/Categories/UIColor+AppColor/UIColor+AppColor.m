//
//  UIColor+AppColor.m
//  XO
//
//  Created by Kirill Gorbushko on 27.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "UIColor+AppColor.h"

@implementation UIColor (AppColor)

#pragma mark - Public

+ (UIColor *)appNavigationBarTextColor
{
    return [UIColor colorWithRealRed:250 green:209 blue:166 alpha:1.0f];
}

#pragma mark - Private

+ (UIColor *)colorWithRealRed:(int)red green:(int)green blue:(int)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:((float)red)/255.f green:((float)green)/255.f blue:((float)blue)/255.f alpha:((float)alpha)/1.f];
}

@end
