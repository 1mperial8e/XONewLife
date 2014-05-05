//
//  TTGameViewController.m
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "XOGameViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GameManager.h"

@interface XOGameViewController (){
    SystemSoundID mySound;
}

@property (weak, nonatomic) IBOutlet UIView *gameFieldContainerView;
@property (weak, nonatomic) UIViewController *gameFieldViewController;
@property (weak, nonatomic) IBOutlet UIImageView *myPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *opponentPhoto;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UILabel *opponentName;

- (IBAction)back:(id)sender;

@end

@implementation XOGameViewController

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
    // Do any additional setup after loading the view.
    _gameFieldViewController = [[UIStoryboard storyboardWithName:@"GameField" bundle:nil] instantiateViewControllerWithIdentifier:@"gameField"];
    //_gameFieldContainerView = _gameFieldViewController.view;
    //[_gameFieldContainerView addSubview:_gameFieldViewController.view];
    [self addChildViewController:_gameFieldViewController];
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"step" ofType:@"wav"];
    NSURL *fileURL = [NSURL URLWithString:soundPath];
    if (fileURL != nil)
    {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &mySound);
    }
    [[self.myPhoto layer] setCornerRadius:32.0];
    self.myPhoto.clipsToBounds=YES;
    self.myPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[GameManager sharedInstance].googleUserImage]]];
    self.myName.text=[GameManager sharedInstance].googleUserName;
    [[self.opponentPhoto layer] setCornerRadius:32.0];
    self.opponentPhoto.clipsToBounds=YES;
    self.opponentPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[GameManager sharedInstance].opponentImage]]];
    self.opponentName.text=[GameManager sharedInstance].opponentName;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playSoud{
    if ([GameManager sharedInstance].sound==YES) {
         AudioServicesPlaySystemSound(mySound);
    }    
}

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(mySound);
}


@end
