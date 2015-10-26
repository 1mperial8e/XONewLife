//
//  XOGameFieldViewController.h
//  XO
//
//  Created by Misha on 30.04.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XOGameFieldViewControllerDelegate <NSObject>
- (void)willChangeValueForIndexPath:(NSIndexPath *)indexPath;
@end

@interface XOGameFieldViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id <XOGameFieldViewControllerDelegate> delegate;

- (void)clearGameField;
- (void)reload;

@end
