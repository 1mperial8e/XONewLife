//
//  XOGameModeViewController.m
//  XO
//
//  Created by Stas Volskyi on 04.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOGameModeViewController.h"
#import "GameManager.h"

@interface XOGameModeViewController ()

- (IBAction)back:(id)sender;
- (IBAction)easyMode:(id)sender;
- (IBAction)mediumMode:(id)sender;
- (IBAction)hardMode:(id)sender;

@end

@implementation XOGameModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];

}

- (IBAction)easyMode:(id)sender{
    [GameManager sharedInstance].difficulty=EASY_MODE;
}

- (IBAction)mediumMode:(id)sender{
    [GameManager sharedInstance].difficulty=MEDIUM_MODE;
}

- (IBAction)hardMode:(id)sender{
    [GameManager sharedInstance].difficulty=HARD_MODE;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
