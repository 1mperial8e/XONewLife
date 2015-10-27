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
}

@end
