//
//  TTGameViewController.h
//  XO
//
//  Created by Stas Volskyi on 30.04.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

@interface GameViewController : BaseViewController

@property (assign, nonatomic) GameMode gameMode;

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *opponentName;

@property (assign, nonatomic) BOOL isHost;

@end
