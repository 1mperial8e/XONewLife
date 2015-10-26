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
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
}

@end
