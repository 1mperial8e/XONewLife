//
//  ADVManager.m
//  XO
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
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
        
        //self.adv =_banner;
        
    }
    return self;
}
- (void)load
{
    _adv = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    _adv.adUnitID = @"/6253334/dfp_example_ad";
    
    _adv.rootViewController =_advRootViewController;
    [_adv loadRequest:[GADRequest request]];

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
