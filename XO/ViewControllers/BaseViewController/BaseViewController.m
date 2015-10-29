//
//  BaseViewController.m
//  XO
//
//  Created by Stas Volskyi on 10/26/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    imageView.image = [UIImage imageNamed:@"background"];
    [self.view insertSubview:imageView atIndex:0];
    
    [self prepareNavigationBar];
}

#pragma mark - IbActions

- (void)backButtonTapped:(id)sender
{
    [[SoundManager sharedInstance] playClickSound];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)prepareNavigationBar
{
    NSMutableDictionary *textAttributes = [@{NSFontAttributeName : [UIFont adigianaFontWithSize:26.f],
                                             NSForegroundColorAttributeName : [UIColor appNavigationBarTextColor]} mutableCopy];
    
    [self.navigationController.navigationBar setTintColor:[UIColor appNavigationBarTextColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton = YES;
    
    NSString *localizedBack = NSLocalizedString(@"common.back", nil);
    [textAttributes setValue:[UIFont adigianaFontWithSize:20.f] forKey:NSFontAttributeName];
    CGSize textSize = [localizedBack sizeWithAttributes:textAttributes];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 10, CGRectGetHeight(self.navigationController.navigationBar.frame))];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:localizedBack
                                                                         attributes:textAttributes];
    [backButton setAttributedTitle:attributedText forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
}

@end