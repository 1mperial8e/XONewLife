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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Private

- (void)localizeUI
{
    self.aboutTextView.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"aboutViewController.AboutText", nil)
                                                                        attributes:@{NSFontAttributeName : [UIFont adigianaFontWithSize:18.0f]}];
    self.title = NSLocalizedString(@"aboutViewController.Title", nil);
}

@end