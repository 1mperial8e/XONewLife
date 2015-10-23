////
////  ATStartViewController.h
////  Test
////
////  Created by Stas Volskyi on 22.04.14.
////  Copyright (c) 2014 Anatoliy Dalekorey. All rights reserved.
////
//
//#import "AppDelegate.h"
//#import "MPManager.h"
//#import "GameManager.h"
//#import "XOGameModel.h"
//
//@implementation MPManager
//
//static MPManager *_instance = nil;
//
//+ (MPManager *)sharedInstance
//{
//  @synchronized(self) {
//    if (nil == _instance) {
//      _instance = [[self alloc] init];
//      _instance.firstMessage=YES;
//      //_instance.newGame=0;
//    }
//  }
//  return _instance;
//}
//
//- (void)startQuickMatchGameWithTotalPlayers:(int)totalPlayers
//{
//    GPGMultiplayerConfig *config = [[GPGMultiplayerConfig alloc] init];
//    config.minAutoMatchingPlayers = totalPlayers - 1;
//    config.maxAutoMatchingPlayers = totalPlayers - 1;
//    
//    // Could also include variants or exclusive bitmasks here
//    GPGRealTimeRoomViewController *roomViewController = [[GPGRealTimeRoomViewController alloc] initAndCreateRoomWithConfig:config];
//    [self.lobbyDelegate showInviteViewController:roomViewController];
//}
//
//- (void)startInvitationGameWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
//{
//  NSLog(@"Showing a RTRVC with max players of %d", maxPlayers);
//  GPGRealTimeRoomViewController *roomViewController =
//      [[GPGRealTimeRoomViewController alloc] initWithMinPlayers:minPlayers maxPlayers:maxPlayers];
//  NSLog(@"I am ready to show a room view controller %@", roomViewController);
//  [self.lobbyDelegate showInviteViewController:roomViewController];
//}
//
//- (void)showIncomingInvitesScreen
//{
//  [GPGRealTimeRoomMaker listRoomsWithMaxResults:50 completionHandler:^(NSArray *rooms, NSError *error) {
//    NSMutableArray *roomsWithInvites = [NSMutableArray array];
//    for (GPGRealTimeRoomData *roomData in rooms) {
//      NSLog(@"Found a room %@", roomData);
//      if (roomData.status == GPGRealTimeRoomStatusInviting) {
//        [roomsWithInvites addObject:roomData];
//      }
//}
//    GPGRealTimeRoomViewController *invitesRoom = [[GPGRealTimeRoomViewController alloc] initWithRoomDataList:roomsWithInvites];
//    [self.lobbyDelegate showInviteViewController:invitesRoom];
//  }];
//}
//
//- (void)leaveRoom
//{
//    if (self.roomToTrack && self.roomToTrack.status != GPGRealTimeRoomStatusDeleted) {
//        [self.roomToTrack leave];
//    }
//}
//
//- (void)didReceiveRealTimeInviteForRoom:(GPGRealTimeRoomData *)room
//{
//  NSMutableArray *roomDataList = [NSMutableArray arrayWithObject:room];
//  GPGRealTimeRoomViewController *roomViewController =
//  [[GPGRealTimeRoomViewController alloc] initWithRoomDataList:roomDataList];
//  NSLog(@"I received an invite from our room...");
//  if ( [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.presentedViewController
//      isEqual:self.lobbyDelegate]) {
//    NSLog(@"And it looks like our lobby delegate is on top right now");
//    [self.lobbyDelegate showInviteViewController:roomViewController];
//  }
//}
//
//- (void)numberOfInvitesAwaitingResponse:(void (^)(int))returnBlock
//{
//    [GPGRealTimeRoomMaker listRoomsWithMaxResults:50 completionHandler:^(NSArray *rooms, NSError *error) {
//        int incomingInvitesCount = 0;
//        for (GPGRealTimeRoomData *roomData in rooms) {
//            NSLog(@"Found a room %@", roomData);
//            if (roomData.status == GPGRealTimeRoomStatusInviting) {
//                incomingInvitesCount += 1;
//            }
//        }
//        returnBlock(incomingInvitesCount);
//    }];
//}
//
//#pragma mark - GPGRealTimeRoomDelegate methods
//
//- (void)room:(GPGRealTimeRoom *)room didChangeStatus:(GPGRealTimeRoomStatus)status
//{
//    if (status == GPGRealTimeRoomStatusDeleted) {
//        NSLog(@"RoomStatusDeleted");
//        [self.lobbyDelegate multiPlayerGameWasCanceled:NO];
//        _roomToTrack = nil;
//    } else if (status == GPGRealTimeRoomStatusConnecting) {
//        NSLog(@"RoomStatusConnecting");
//    } else if (status == GPGRealTimeRoomStatusActive) {
//    NSLog(@"RoomStatusActive! Game is ready to go");
//    _roomToTrack = room;
//         [[GameManager sharedInstance] tryToBeFirst];
//    // We may have a view controller up on screen if we're using the
//    // invite UI
//    [self.lobbyDelegate readyToStartMultiPlayerGame];
//    } else if (status == GPGRealTimeRoomStatusAutoMatching) {
//    NSLog(@"RoomStatusAutoMatching! Waiting for auto-matching to take place");
//    _roomToTrack = room;
//    } else if (status == GPGRealTimeRoomStatusInviting) {
//    NSLog(@"RoomStatusInviting! Waiting for invites to get accepted");
//    } else {
//    NSLog(@"Unknown room status %d", status);
//    }
//}
//
//- (void)room:(GPGRealTimeRoom *)room participant:(GPGRealTimeParticipant *)participant didChangeStatus:(GPGRealTimeParticipantStatus)status
//{
//      NSString *statusString = @[ @"Invited", @"Joined", @"Declined", @"Left", @"Connection Made" ][status];
//    if ([statusString isEqualToString:@"Connection Made"]){
//        if (![[GameManager sharedInstance].googleUserName isEqualToString:participant.displayName]){
//        [GameManager sharedInstance].opponentName=participant.displayName;
//        [GameManager sharedInstance].opponentImage=participant.avatarUrl;        
//        }
//    }
//    if ([statusString isEqualToString:@"Left"])
//    {
//        [self.roomToTrack leave];
//    }
//}
//
//- (void)room:(GPGRealTimeRoom *)room didChangeConnectedSet:(BOOL)connected
//{
//    NSLog(@"Did change connected set %@", connected ? @"Yes":@"No");
//}
//
//- (void)room:(GPGRealTimeRoom *)room didFailWithError:(NSError *)error
//{
//    NSLog(@"*** ERROR: Room failed with error %@", [error localizedDescription]);
//}
//
//- (void)room:(GPGRealTimeRoom *)room didReceiveData:(NSData *)data fromParticipant:(GPGRealTimeParticipant *)participant dataMode:(GPGRealTimeDataMode)dataMode
//{
//    if (self.firstMessage==YES){
//        NSString *roll= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"MY ROLL - %i, opponent roll - %i", [GameManager sharedInstance].myRoll, [roll intValue]);
//        if(_delegate && [_delegate respondsToSelector:@selector(whoTurnFirst:)])
//        {
//            self.firstMessage=NO;
//            [_delegate whoTurnFirst:[roll intValue]];
//        }
//        return;
//    }
//    NSString * message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    if ([message isEqualToString:@"yes"]) {
//        [XOGameModel sharedInstance].opponentNewGame = NewGameMessageYes;
//    }
//    else if ([message isEqualToString:@"no"]){
//        [XOGameModel sharedInstance].opponentNewGame = NewGameMessageNo;
//    }
//    else{
//        if(_delegate && [_delegate respondsToSelector:@selector(didReceiveMessage:)])
//        {
//            [_delegate didReceiveMessage: message];
//        }
//    }
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//}
//
//- (void)roomViewControllerDidClose:(GPGRealTimeRoomViewController *)roomViewController
//{
//    [self.lobbyDelegate multiPlayerGameWasCanceled:NO];
//}
//
//- (void)sendPlayerMyMessage:(NSString *)message
//{
//    NSData *data;
//    data = [message dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    [self.roomToTrack sendReliableDataToOthers:data];
//  
//}
//
//@end
