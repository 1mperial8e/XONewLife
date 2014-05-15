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

@interface XONavigationController ()
@property (nonatomic, weak) IBOutlet ADVContainer *containerView;
@property (nonatomic, strong) GADBannerView *banner;
@property (nonatomic) BOOL advLoaded;
@end

@implementation XONavigationController
@synthesize banner;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    banner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    banner.adUnitID = @"/6253334/dfp_example_ad";
    // "@ca-app-pub-8249028322108129/3701709092"
    // @"ca-app-pub-8249028322108129/6794776292"
    banner.rootViewController =self.topViewController;
    [banner loadRequest:[GADRequest request]];
    _containerView = (ADVContainer *)[self.topViewController.view viewWithTag:135];
    _containerView.backgroundColor = [UIColor redColor];
    [_containerView addSubview:banner];
    [banner loadRequest:[GADRequest request]];
    banner.delegate = self;
    _containerView.hidden = YES;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    
    _advLoaded = YES;
    if (_containerView.hidden) {
        [_containerView setHidden:NO animate:YES];
    }
}
- (void)tick:(NSTimer *)timer
{
    [banner loadRequest:[GADRequest request]];
    [timer invalidate];
    timer = nil;
    NSLog(@"tryReload");
}
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(tick:) userInfo:nil repeats:NO];
    _advLoaded = NO;
    [_containerView setHidden:YES animate:YES];
    NSLog(@"Error")
    ;
}
- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - NavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"WillShow");

    _containerView = (ADVContainer *)[self.visibleViewController.view viewWithTag:135];
    ((ADVContainer *)[self.visibleViewController.view viewWithTag:135]).backgroundColor = [UIColor colorWithPatternImage:[self imageWithView:banner]];
    if (_advLoaded) {
        _containerView = (ADVContainer *)[self.visibleViewController.view viewWithTag:135];
        ((ADVContainer *)[self.visibleViewController.view viewWithTag:135]).backgroundColor = [UIColor colorWithPatternImage:[self imageWithView:banner]];
        [_containerView setHidden:NO animate:YES];
    } else {
        _containerView.hidden = YES;
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    _containerView = (ADVContainer *)[self.visibleViewController.view viewWithTag:135];
    [(ADVContainer *)[self.visibleViewController.view viewWithTag:135] addSubview:banner];
}
@end
