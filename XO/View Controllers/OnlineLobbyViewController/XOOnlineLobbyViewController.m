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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"For playing online, please sign in via google+" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign in", nil];
        [alert show];
    }
    [MPManager sharedInstance].lobbyDelegate = self;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkInvites:(id)sender {
    [[MPManager sharedInstance] showIncomingInvitesScreen];
}

- (IBAction)quickGame:(id)sender {
    [self startQuickMatchGameWithTotalPlayers:2];
}

- (IBAction)inviteFriend:(id)sender {
    [[MPManager sharedInstance] startInvitationGameWithMinPlayers:2 maxPlayers:2];
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

- (void)multiPlayerGameWasCanceled
{
    if (self.presentedViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (![[self.navigationController.viewControllers lastObject] isEqual:self])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End game!" message:@"Opponent has left the game :-(" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [alert show];        
    }
}

#pragma mark - Other methods

- (void)startQuickMatchGameWithTotalPlayers:(int)totalPlayers
{
    [[MPManager sharedInstance] startQuickMatchGameWithTotalPlayers:totalPlayers];
}


@end
