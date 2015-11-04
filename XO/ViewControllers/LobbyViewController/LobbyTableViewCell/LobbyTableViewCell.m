//
//  LobbyTableViewCell.m
//  XO
//
//  Created by Stas Volskyi on 11/3/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "LobbyTableViewCell.h"

@interface LobbyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *connectToUserButton;

@property (assign, nonatomic) NSInteger index;

@end

@implementation LobbyTableViewCell

#pragma mark - Static

+ (NSString *)ID
{
    return NSStringFromClass([self class]);
}

#pragma mark - Public

- (void)configureWithUserName:(NSString *)userName andIndex:(NSInteger)index
{
    NSParameterAssert(userName);
    [self.connectToUserButton setTitle:userName forState:UIControlStateNormal];
    [self.connectToUserButton setTitleColor:[UIColor appButtonTextColor] forState:UIControlStateNormal];
    self.connectToUserButton.titleLabel.font = [UIFont adigianaFontWithSize:28.f];
    
    int imageNumber = arc4random_uniform(2) + 1;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"button%i", imageNumber]];
    NSParameterAssert(image);
    [self.connectToUserButton setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)cottectToUserAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(connectToUserAtIndex:)]) {
        [self.delegate connectToUserAtIndex:self.index];
    }
}

@end
