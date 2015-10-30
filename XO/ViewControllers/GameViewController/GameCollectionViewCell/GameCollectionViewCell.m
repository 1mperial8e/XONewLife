//
//  GameCollectionViewCell.m
//  XO
//
//  Created by Stas Volskyi on 10/30/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "GameCollectionViewCell.h"

static NSString *const crossIconPattern = @"cross_";
static NSString *const zeroIconPattern = @"zero_";

@interface GameCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GameCollectionViewCell

#pragma mark - Static

+ (NSString *)ID
{
    return NSStringFromClass([self class]);
}

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    self.imageView.image = nil;
}

- (void)prepareForReuse
{
    self.imageView.image = nil;
}

#pragma mark Public

- (void)fillWithCross:(BOOL)isCross
{
    NSString *pattern = isCross ? crossIconPattern : zeroIconPattern;
    int imageNumber = arc4random_uniform(4) + 1;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%i", pattern, imageNumber]];
    NSParameterAssert(image);
    self.imageView.image = image;
}

- (BOOL)isEmpty
{
    return (self.imageView.image == nil);
}

@end
