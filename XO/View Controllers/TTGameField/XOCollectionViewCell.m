//
//  XOCollectionViewCell.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOCollectionViewCell.h"
@interface XOCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end
@implementation XOCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.clipsToBounds = YES;
        [self sizeToFit];
        NSLog(@"%@", NSStringFromCGRect(self.frame));
    }
    return self;
}

- (void)setMode:(int)mode
{
    //NSLog(@"%@", NSStringFromCGRect(self.sizeToFit));
    if (!_mode && mode>0) {
        self.backgroundColor = [UIColor redColor];
        _mode = mode;
        self.label.text = @"X";
    } else if (!_mode && mode<0) {
        self.backgroundColor = [UIColor greenColor];
        _mode = mode;
        self.label.text = @"O";
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
