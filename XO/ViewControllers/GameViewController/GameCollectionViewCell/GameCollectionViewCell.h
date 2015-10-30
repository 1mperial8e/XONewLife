//
//  GameCollectionViewCell.h
//  XO
//
//  Created by Stas Volskyi on 10/30/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface GameCollectionViewCell : UICollectionViewCell

+ (NSString *)ID;

- (void)fillWithCross:(BOOL)isCross;
- (BOOL)isEmpty;

@end
