//
//  TTGameViewController.m
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "XOGameViewController.h"
#import "GameManager.h"
#import "MPManager.h"

@interface XOGameViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameFieldContainerView;
@property (weak, nonatomic) UIViewController *gameFieldViewController;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UILabel *opponentName;
@property (weak, nonatomic) IBOutlet UIImageView *myPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *opponentPhoto;
@property (weak, nonatomic) IBOutlet UIView *myPhotoFrame;
@property (weak, nonatomic) IBOutlet UIView *opponentPhotoFrame;

- (IBAction)back:(id)sender;

@end

@implementation XOGameViewController

#pragma mark - Lifecicle
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
    [self configGameField];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configGameField
{
    _gameFieldViewController = [[UIStoryboard storyboardWithName:@"GameField" bundle:nil] instantiateViewControllerWithIdentifier:@"gameField"];
    [_gameFieldContainerView addSubview:_gameFieldViewController.view];
    _gameFieldViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_gameFieldContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_gameFieldContainerView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_gameFieldViewController.view
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:0]];
    
    [_gameFieldContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_gameFieldContainerView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_gameFieldViewController.view
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:0]];
    [_gameFieldContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_gameFieldContainerView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_gameFieldViewController.view
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0
                                                                         constant:0]];
    [_gameFieldContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_gameFieldContainerView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_gameFieldViewController.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0
                                                                         constant:0]];
    [self addChildViewController:_gameFieldViewController];
    [self setPlayersInfo];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    [[MPManager sharedInstance].roomToTrack leave];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setPlayersInfo{
    if ([[GameManager sharedInstance].mode isEqualToString:ONLINE_PLAYERS]){
    self.myName.text=[GameManager sharedInstance].googleUserName;
    self.opponentName.text=[GameManager sharedInstance].opponentName;
    self.myPhoto.image=[UIImage imageWithData:[NSData  dataWithContentsOfURL:[NSURL URLWithString:[GameManager sharedInstance].googleUserImage]]];
    self.opponentPhoto.image=[UIImage imageWithData:[NSData  dataWithContentsOfURL:[GameManager sharedInstance].opponentImage]];
    }
    else if ([[GameManager sharedInstance].mode isEqualToString:TWO_PLAYERS]){
        self.myName.text=@"Player1";
        self.opponentName.text=@"Player2";
        self.myPhoto.image=[UIImage imageNamed:@"cross_1"];
        self.opponentPhoto.image=[UIImage imageNamed:@"zero_4"];
    }
    else if ([[GameManager sharedInstance].mode isEqualToString:SINGLE_PLAYER]){
        self.myName.text=@"Me";
        self.opponentName.text=@"iPhone";
        self.myPhoto.image=[UIImage imageWithData:[NSData  dataWithContentsOfURL:[NSURL URLWithString:[GameManager sharedInstance].googleUserImage]]];
        self.opponentPhoto.image=[UIImage imageNamed:@"apple"];
    }
    self.myName.layer.cornerRadius=6;
    self.opponentName.layer.cornerRadius=6;
    self.myPhoto.layer.cornerRadius=33;
    self.opponentPhoto.layer.cornerRadius=33;
    self.myPhotoFrame.layer.cornerRadius=36;
    self.opponentPhotoFrame.layer.cornerRadius=36;
    self.myPhoto.clipsToBounds=YES;
    self.opponentPhoto.clipsToBounds=YES;
}
@end
