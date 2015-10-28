//
//  SwitchControlView.h
//  XO
//
//  Created by Kirill Gorbushko on 15.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
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