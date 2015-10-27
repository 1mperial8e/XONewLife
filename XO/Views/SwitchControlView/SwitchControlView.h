//
//  SwitchControlView.h
//  
//
//  Created by Kirill Gorbushko on 15.10.15.
//  Copyright © 2015 Kirill Gorbushko. All rights reserved.
//

@class SoundButton;

@protocol SwitchControlViewDelegate <NSObject>

@optional
- (void)switchControlDidTappedButton:(SoundButton *)button;

@end

@interface SwitchControlView : UIView

@property (weak, nonatomic) id <SwitchControlViewDelegate> delegate;

@property (strong, nonatomic) UIColor *activeElementTintColor;
@property (strong, nonatomic) UIColor *inActiveElementTintColor;

@property (assign, nonatomic) NSInteger elementsCount;
@property (strong, nonatomic) NSArray *elementsNames;

@property (strong, nonatomic) NSArray *activeBackgroundImages;
@property (strong, nonatomic) NSArray *inActiveBackgroundImages;

- (void)selectElementWithTag:(NSUInteger)tag;

@end