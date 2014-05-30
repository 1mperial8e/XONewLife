//
//  TTOnlineLobbyViewController.m
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "XOOnlineLobbyViewController.h"
#import "MPManager.h"
#import "XOGameViewController.h"
#import "SoundManager.h"
#import "XOGameModel.h"
#import "GameManager.h"

@interface XOOnlineLobbyViewController () <UIAlertViewDelegate, MPLobbyDelegate>

@property (nonatomic) BOOL alreadyFinish;

- (IBAction)backButton:(id)sender;
- (IBAction)checkInvites:(id)sender;
- (IBAction)quickGame:(id)sender;
- (IBAction)inviteFriend:(id)sender;

@end

@implementation XOOnlineLobbyViewController



#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MPManager sharedInstance].lobbyDelegate = self;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
}

- (void) viewWillAppear:(BOOL)animated{
    [[GameManager sharedInstance] trackScreenWithName:LOBBY_SCREEN];
    [[GameManager sharedInstance] testInternetConnection];    
}

- (void) viewDidDisappear:(BOOL)animated{
    _alreadyFinish=NO;
}

#pragma mark - UIActions

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)checkInvites:(id)sender {
    [[GameManager sharedInstance] trackScreenWithName:SHOW_INVITES_SCREEN];
    [[MPManager sharedInstance] showIncomingInvitesScreen];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)quickGame:(id)sender {
    [[GameManager sharedInstance] trackScreenWithName:QUICK_GAME_SCREEN];
    [self startQuickMatchGameWithTotalPlayers:2];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)inviteFriend:(id)sender {
    [[GameManager sharedInstance] trackScreenWithName:INVITE_FRIEND_SCREEN];
    [[MPManager sharedInstance] startInvitationGameWithMinPlayers:2 maxPlayers:2];
    [[SoundManager sharedInstance] playClickSound];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
        }
        break;
    }
    [[SoundManager sharedInstance] playClickSound];
}

#pragma mark - MPLobbyDelegate methods

- (void)readyToStartMultiPlayerGame
{
    if (![[self.navigationController.viewControllers lastObject] isEqual:self]) {
        return;
    }
    if (self.presentedViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        XOGameViewController *gameView=[[UIStoryboard storyboardWithName:@"iPhone" bundle:Nil] instantiateViewControllerWithIdentifier:@"game"];
        [self.navigationController pushViewController:gameView animated:YES];       
    }
}

- (void)showInviteViewController:(UIViewController *)vcToShow
{
    [self presentViewController:vcToShow animated:YES completion:nil];
}

- (void)multiPlayerGameWasCanceled:(BOOL)byMe
{
    if (self.presentedViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[SoundManager sharedInstance] playClickSound];
    }
    if (![[self.navigationController.viewControllers lastObject] isEqual:self])
    {
    if (byMe==YES){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        if (_alreadyFinish==NO){
            _alreadyFinish=YES;
            [[MPManager sharedInstance] leaveRoom];
            [XOGameModel sharedInstance].opponentNewGame=NewGameMessageNo;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"End game!", nil) message:NSLocalizedString(@"Opponent has left the game :-(", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Exit", nil) otherButtonTitles:nil, nil];
            [[XOGameModel sharedInstance].timerDelegate stopTimer];
            [alert show];
            }
        }
    }
}

#pragma mark - Other methods

- (void)startQuickMatchGameWithTotalPlayers:(int)totalPlayers
{
    [[MPManager sharedInstance] startQuickMatchGameWithTotalPlayers:totalPlayers];
}


@end
