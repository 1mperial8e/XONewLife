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
#import "XOGameModel.h"
#import "SoundManager.h"

@interface XOGameViewController () <XOStepTimerDelegate, weHaveVictory>{
    NSTimer *stepTimer;
    int time;
}

@property (weak, nonatomic) IBOutlet UIView *gameFieldContainerView;
@property (weak, nonatomic) UIViewController *gameFieldViewController;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UILabel *opponentName;
@property (weak, nonatomic) IBOutlet UIImageView *myPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *opponentPhoto;
@property (weak, nonatomic) IBOutlet UIView *myPhotoFrame;
@property (weak, nonatomic) IBOutlet UIView *opponentPhotoFrame;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

- (IBAction)back:(id)sender;

@end

@implementation XOGameViewController

#pragma mark - Lifecicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configGameField];
    [XOGameModel sharedInstance].timerDelegate = self;
    [XOGameModel sharedInstance].victoryDelegate = self;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    if ([[GameManager sharedInstance].mode isEqualToString:ONLINE_PLAYERS]){
        [[GameManager sharedInstance] loadData];
        [[GameManager sharedInstance] tryToBeFirst];
    }
    time=30;
    stepTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(onTick:)
                                             userInfo:nil
                                              repeats:YES];

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
    if ([[GameManager sharedInstance].mode isEqualToString:ONLINE_PLAYERS]){
    [[MPManager sharedInstance].roomToTrack leave];
    }
    [[XOGameModel sharedInstance] clear];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[SoundManager sharedInstance] playClickSound];
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
    self.myName.layer.cornerRadius=4;
    self.opponentName.layer.cornerRadius=4;
    self.myPhoto.layer.cornerRadius=27.5;
    self.opponentPhoto.layer.cornerRadius=27.5;
    self.myPhotoFrame.layer.cornerRadius=32.5;
    self.opponentPhotoFrame.layer.cornerRadius=32.5;
    self.myPhoto.clipsToBounds=YES;
    self.opponentPhoto.clipsToBounds=YES;
}

- (void)onTick:(NSTimer *)timer{
    time--;
    self.timerLabel.text=[NSString stringWithFormat:@"%i",time];
    if (time==0) {
        [stepTimer invalidate];
        time=30;
    }
}

#pragma mark - XOStepTimerDelegate

- (void) resetTimer{
    time=30;
}
- (void) stopTimer
{
    [stepTimer invalidate];
}
#pragma mark - victoryDelegate

- (void) drawVector:(XOVectorType)vectorType atLine:(int)line{
    UIImage *lineIMG = [[UIImage alloc] init];
    CGRect frame;
       switch (vectorType) {
        case XOVectorTypeDiagonalLeft:{
            lineIMG=[UIImage imageNamed:@"left"];
            frame=CGRectMake(0,0,self.gameFieldContainerView.frame.size.width,self.gameFieldContainerView.frame.size.height);
        }
        break;
        case XOVectorTypeDiagonalRight:{
            lineIMG=[UIImage imageNamed:@"right"];
            frame=CGRectMake(0,0,self.gameFieldContainerView.frame.size.width,self.gameFieldContainerView.frame.size.height);
        }
        break;
        case XOVectorTypeHorisontal:{
            lineIMG=[UIImage imageNamed:@"horizontal"];
            line*=self.gameFieldContainerView.frame.size.height/3;
            frame=CGRectMake(0, ((self.gameFieldContainerView.frame.size.height/3)/4)+line, self.gameFieldContainerView.frame.size.width, self.gameFieldContainerView.frame.size.height/10);
        }
        break;
        case XOVectorTypeVertical:{
            lineIMG=[UIImage imageNamed:@"vertical"];
            line*=self.gameFieldContainerView.frame.size.width/3;
            frame=CGRectMake(((self.gameFieldContainerView.frame.size.width/3)/3)+line, 0, self.gameFieldContainerView.frame.size.width/10, self.gameFieldContainerView.frame.size.height);
        }
        break;
    }
    UIImageView *lineView=[[UIImageView alloc] initWithImage:lineIMG];
    lineView.frame=frame;
    [self.gameFieldContainerView addSubview:lineView];
}


@end
