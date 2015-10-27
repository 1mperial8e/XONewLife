//
//  AboutViewController.m
//  XO
//
//  Created by Stas Volskyi on 13.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation AboutViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self localizeUI];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - Private

- (void)localizeUI
{
    self.aboutTextView.text = NSLocalizedString(@"aboutViewController.AboutText", nil);
    self.title = NSLocalizedString(@"aboutViewController.Title", nil);
}

@end