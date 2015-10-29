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
    
    self.aboutTextView.font = [UIFont adigianaFontWithSize:18.0f];
    [self localizeUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Private

- (void)localizeUI
{
    self.aboutTextView.text = NSLocalizedString(@"aboutViewController.AboutText", nil);
    self.title = NSLocalizedString(@"aboutViewController.Title", nil);
}

@end