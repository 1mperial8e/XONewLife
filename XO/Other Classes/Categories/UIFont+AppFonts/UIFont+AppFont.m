//
//  UIFont+AppFont.m
//  XO
//
//  Created by Kirill Gorbushko on 27.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "UIFont+AppFont.h"

@implementation UIFont (AppFont)

#pragma mark - Public

+ (UIFont *)gilSansLightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"GillSans-Light" size:size];
}

+ (UIFont *)gilSansRegularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"GillSans" size:size];
}

+ (UIFont *)adigianaFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Adigiana2" size:size];
}

@end
