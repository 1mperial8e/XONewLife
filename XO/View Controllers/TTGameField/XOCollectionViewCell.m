//
//  XOCollectionViewCell.m
//  XO
//
//  Created by Misha on 05.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOCollectionViewCell.h"
@interface XOCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) NSArray *cross;
@property (strong, nonatomic) NSArray *zeros;
@end
@implementation XOCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _cross = @[[UIImage imageNamed:@"cross_1"],[UIImage imageNamed:@"cross_2"],[UIImage imageNamed:@"cross_3"],[UIImage imageNamed:@"cross_4"],[UIImage imageNamed:@"cross_5"]];
        _zeros = @[[UIImage imageNamed:@"zero_1"],[UIImage imageNamed:@"zero_2"],[UIImage imageNamed:@"zero_3"],[UIImage imageNamed:@"zero_4"],[UIImage imageNamed:@"zero_5"]];
    }
    return self;
}

- (void)setMode:(int)mode
{
    //NSLog(@"%@", NSStringFromCGRect(self.sizeToFit));
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
-(void) dealloc
{
    
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
