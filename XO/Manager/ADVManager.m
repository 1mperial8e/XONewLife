//
//  ADVManager.m
//  XO
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "ADVManager.h"
#import "GADBannerView.h"
@interface ADVManager ()
@property (nonatomic) GADBannerView *banner;
@end
@implementation ADVManager
static ADVManager* _instance=nil;
#pragma mark - Lifecicle
- (id)init
{
    self = [super init];
    if (self) {
        _banner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        
        _banner.adUnitID = @"INSERT_YOUR_AD_UNIT_ID_HERE";
        
        _banner.rootViewController = self.advRootViewController;
        [self.adv addSubview:_banner];
        
        [_banner loadRequest:[GADRequest request]];
    }
    return self;
}
#pragma mark - Class Methods
+ (ADVManager *)sharedInstance
{
    @synchronized(self) {
        if (nil == _instance) {
            _instance = [[self alloc] init];
            
        }
    }
    return _instance;
}
@end
