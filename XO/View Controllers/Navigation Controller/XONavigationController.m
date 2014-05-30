//
//  XONavigationController.m
//  XO
//
//  Created by Misha on 15.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XONavigationController.h"
#import "ADVManager.h"
#import "ADVContainer.h"
#import "SADWebView.h"
#import "XOStartViewController.h"

@interface XONavigationController () <SADWebViewDelegate>

@property (nonatomic, weak) IBOutlet ADVContainer *containerView;
@property (nonatomic) BOOL advLoaded;
@property (nonatomic, strong) SADWebView *webView;
@end

@implementation XONavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _containerView = (ADVContainer *)[self.visibleViewController.view viewWithTag:135];
    _containerView.hidden = YES;
    self.delegate = self;
    if (!_webView) {
        _webView = [[SADWebView alloc]initWithId:START_AD_MOB_ID];
        _webView.sadDelegate = self;
    }
    [self loadAd];
}

- (void)tick:(NSTimer *)timer
{
    [self loadAd];
    [timer invalidate];
    timer = nil;
    NSLog(@"tryReload");
}

- (void) loadAd{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"ru"] || [language isEqualToString:@"uk"]) {
        [_webView loadAd:LANGUAGE_RU];
    }
    else{
        [_webView loadAd:LANGUAGE_EN];
    }
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - NavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    _containerView = (ADVContainer *)[self.visibleViewController.view viewWithTag:135];
    ((ADVContainer *)[self.visibleViewController.view viewWithTag:135]).backgroundColor = [UIColor colorWithPatternImage:[self imageWithView:_webView]];
    if (_advLoaded) {
        _containerView = (ADVContainer *)[self.visibleViewController.view viewWithTag:135];
       ((ADVContainer *)[self.visibleViewController.view viewWithTag:135]).backgroundColor = [UIColor colorWithPatternImage:[self imageWithView:_webView]];
        [_containerView setHidden:NO animate:YES];
    } else {
        _containerView.hidden = YES;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    _containerView = (ADVContainer *)[self.visibleViewController.view viewWithTag:135];
    [(ADVContainer *)[self.visibleViewController.view viewWithTag:135] addSubview:_webView];
}

#pragma mark - SAD Delegate

-(void)onReceivedAd
{
    _advLoaded=YES;
    _webView.frame=CGRectMake(0, 0, self.view.bounds.size.width, 120);
    if (_containerView.hidden) {
        [_containerView setSize:_webView.scrollView.contentSize.height];
        [_containerView setHidden:NO animate:YES];
    }
    ((XOStartViewController*)[self.viewControllers firstObject]).bottomMargin.constant=0;
}

-(void)onError:(SADVIEW_ERROR)error
{
    NSLog(@"Error! %u", error);
    ((XOStartViewController*)[self.viewControllers firstObject]).bottomMargin.constant=12;
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(tick:) userInfo:nil repeats:NO];
    if (!_containerView.hidden) {
        [_containerView setHidden:YES animate:YES];
    }
}

-(void)noAdFound
{
    _advLoaded=NO;
    NSLog(@"Not Found");
    ((XOStartViewController*)[self.viewControllers firstObject]).bottomMargin.constant=12;
    if (!_containerView.hidden) {
        [_containerView setHidden:YES animate:YES];
    }
}

@end
