//
//  TTSettengsViewController.m
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "XOSettingsViewController.h"
#import "XOStartViewController.h"
#import "GameManager.h"
#import "SoundManager.h"

@interface XOSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInOut;
@property (weak, nonatomic) IBOutlet UIButton *enableSound;
@property (weak, nonatomic) IBOutlet UIButton *enableMusic;
@property (weak, nonatomic) IBOutlet UIButton *enablePush;
@property (weak, nonatomic) IBOutlet UIButton *enableGoogleAnalitics;

- (IBAction)signInOut:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)enableSound:(id)sender;
- (IBAction)enableMusic:(id)sender;
- (IBAction)enablePush:(id)sender;
- (IBAction)enableGoogleAnalitics:(id)sender;

@end

@implementation XOSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setControlState];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];

}


- (IBAction)signInOut:(id)sender {
    if ([[GPGManager sharedInstance] isSignedIn]){
        [self.signInOut setTitle:@"G+ | sign in" forState:UIControlStateNormal];
        [[GPGManager sharedInstance] signOut];
    }
    else{
        [[GPPSignIn sharedInstance] authenticate];
        [self.signInOut setTitle:@"G+ | sign out" forState:UIControlStateNormal];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[SoundManager sharedInstance] playClickSound];
}
- (IBAction)enableSound:(id)sender{
    [self changeSettings:@"sound"];
    [[SoundManager sharedInstance] playClickSound];
}
- (IBAction)enableMusic:(id)sender{
    [self changeSettings:@"music"];
    [[SoundManager sharedInstance] playClickSound];
}
- (IBAction)enablePush:(id)sender{
    [self changeSettings:@"push"];
    [[SoundManager sharedInstance] playClickSound];
}
- (IBAction)enableGoogleAnalitics:(id)sender{
    [self changeSettings:@"googleAnalitics"];
    [[SoundManager sharedInstance] playClickSound];
}

- (void)changeSettings:(NSString*)settings{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:settings]==NO){
        [userDefaults setBool:YES forKey:settings];
    }else{
        [userDefaults setBool:NO forKey:settings];        
    }
    [userDefaults synchronize];
    [[GameManager sharedInstance] setSettings];
    [self setControlState];
}

- (void) setControlState{
    if ([[GPGManager sharedInstance] isSignedIn]) {
        [self.signInOut setTitle:@"G+ | sign out" forState:UIControlStateNormal];
    }
    else{
        [self.signInOut setTitle:@"G+ | sign in" forState:UIControlStateNormal];
    }
    if ([GameManager sharedInstance].sound) {
        [self.enableSound setTitle:@"Sound ON" forState:UIControlStateNormal];
    }
    else{
        [self.enableSound setTitle:@"Sound OFF" forState:UIControlStateNormal];
    }
    if ([GameManager sharedInstance].music) {
        [self.enableMusic setTitle:@"Music ON" forState:UIControlStateNormal];
    }
    else{
        [self.enableMusic setTitle:@"Music OFF" forState:UIControlStateNormal];
    }
    if ([GameManager sharedInstance].googleAnalitics) {
        [self.enableGoogleAnalitics setTitle:@"Google Analitics ON" forState:UIControlStateNormal];
    }
    else{
        [self.enableGoogleAnalitics setTitle:@"Google Analitics OFF" forState:UIControlStateNormal];
    }
    if ([GameManager sharedInstance].push) {
        [self.enablePush setTitle:@"Push ON" forState:UIControlStateNormal];
    }
    else{
        [self.enablePush setTitle:@"Push OFF" forState:UIControlStateNormal];
    }
}

@end
