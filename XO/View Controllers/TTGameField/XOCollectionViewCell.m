//
//  XOCollectionViewCell.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "XOCollectionViewCell.h"

@interface XOCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) NSArray *cross;
@property (strong, nonatomic) NSArray *zeros;

@end

@implementation XOCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadImages];
    }
    return self;
}

- (void)setMode:(NSInteger)mode
{
    if (mode>0) {
        _mode = mode;
        _image.image = _cross[arc4random() % _cross.count];
    } else if (mode<0) {
        _mode = mode;
        _image.image = _zeros[arc4random() % _cross.count];
    } else {
        _image.image = nil;
    }
}
- (void)setSelected:(BOOL)selected
{
    if (selected) {
        //Тут буде анімаціяж
    }
}

- (void)loadImages
{
    self.cross = @[[UIImage imageNamed:@"cross_1"],
                   [UIImage imageNamed:@"cross_2"],
                   [UIImage imageNamed:@"cross_3"],
                   [UIImage imageNamed:@"cross_4"],
                   [UIImage imageNamed:@"cross_5"]];
    
    self.zeros = @[[UIImage imageNamed:@"zero_1"],
                   [UIImage imageNamed:@"zero_2"],
                   [UIImage imageNamed:@"zero_3"],
                   [UIImage imageNamed:@"zero_4"],
                   [UIImage imageNamed:@"zero_5"]];
}

@end
