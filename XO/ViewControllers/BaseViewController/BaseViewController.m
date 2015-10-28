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
    [self.navigationController.navigationBar setTintColor:[UIColor appNavigationBarTextColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName : [UIFont gilSansLightFontWithSize:24.f],
                                                                      NSForegroundColorAttributeName : [UIColor appNavigationBarTextColor]
                                                                      }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped:)];
}

@end