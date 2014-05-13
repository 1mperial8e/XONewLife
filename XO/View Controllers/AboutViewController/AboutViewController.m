//
//  AboutViewController.m
//  XO
//
//  Created by Stas Volskyi on 13.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "AboutViewController.h"
#import "SoundManager.h"

@interface AboutViewController ()

- (IBAction)backButton:(id)sender;

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
}



- (IBAction)backButton:(id)sender {
    [[SoundManager sharedInstance] playClickSound];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
