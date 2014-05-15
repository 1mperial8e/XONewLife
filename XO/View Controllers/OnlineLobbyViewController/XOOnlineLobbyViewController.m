//
//  TTOnlineLobbyViewController.m
//  Tic tac toe
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "XOOnlineLobbyViewController.h"
#import "GooglePlus.h"
#import "MPManager.h"
#import "XOGameViewController.h"
#import "SoundManager.h"
#import "XOGameModel.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GameManager.h"

@interface XOOnlineLobbyViewController () <UIAlertViewDelegate, MPLobbyDelegate>

- (IBAction)backButton:(id)sender;
- (IBAction)checkInvites:(id)sender;
- (IBAction)quickGame:(id)sender;
- (IBAction)inviteFriend:(id)sender;

@end

@implementation XOOnlineLobbyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[GPGManager sharedInstance] isSignedIn])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NoConnection", nil) message:NSLocalizedString(@"forPlaying", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"CancelLogin", nil) otherButtonTitles:NSLocalizedString(@"Sign in", nil) , nil];
        [alert show];
    }
    [MPManager sharedInstance].lobbyDelegate = self;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
}

- (void) viewWillAppear:(BOOL)animated{
    [[GameManager sharedInstance] trackScreen:self withName:LOBBY_SCREEN];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)checkInvites:(id)sender {
    [[MPManager sharedInstance] showIncomingInvitesScreen];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)quickGame:(id)sender {
    [self startQuickMatchGameWithTotalPlayers:2];
    [[SoundManager sharedInstance] playClickSound];
}

- (IBAction)inviteFriend:(id)sender {
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
        case 1:{
            [[GPPSignIn sharedInstance] authenticate];
        }
    }
    [[SoundManager sharedInstance] playClickSound];
}

#pragma mark - MPLobbyDelegate methods

- (void)readyToStartMultiPlayerGame
{
    // I can still sometimes receive this if we're in the middle of a game
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
    NSLog(@"Okay! Lobby is ready to show invite VC!");
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
        [XOGameModel sharedInstance].opponentNewGame=NewGameMessageNo;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"End game!", ni
l) message:NSLocalizedString(@"Opponent has left the game :-(", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Exit", nil) otherButtonTitles:nil, nil];
        [[XOGameModel sharedInstance].timerDelegate stopTimer];
        [alert show];
        }
    }
}

#pragma mark - Other methods

- (void)startQuickMatchGameWithTotalPlayers:(int)totalPlayers
{
    [[MPManager sharedInstance] startQuickMatchGameWithTotalPlayers:totalPlayers];
}


@end
