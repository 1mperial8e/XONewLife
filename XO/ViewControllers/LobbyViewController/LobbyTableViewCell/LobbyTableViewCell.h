//
//  LobbyTableViewCell.h
//  XO
//
//  Created by Stas Volskyi on 11/3/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@protocol LobbyTableViewCellDelegate <NSObject>

- (void)connectToUserAtIndex:(NSInteger)index;

@end

@interface LobbyTableViewCell : UITableViewCell

@property (weak, nonatomic) id<LobbyTableViewCellDelegate> delegate;

+ (NSString *)ID;

- (void)configureWithUserName:(NSString *)userName andIndex:(NSInteger)index;

@end
