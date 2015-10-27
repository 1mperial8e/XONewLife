//
//  UIFont+AppFont.m
//  XO
//
//  Created by Kirill Gorbushko on 27.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "UIFont+AppFont.h"

@implementation UIFont (AppFont)

#pragma mark - Public

+ (UIFont *)phosphateSolidFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Phosphate-Solid" size:size];
}

+ (UIFont *)phosphateInlineFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Phosphate-Inline" size:size];
}

+ (UIFont *)gilSansLightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"GillSans-Light" size:size];
}


@end
