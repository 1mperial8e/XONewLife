//
//  SwitchControlView.m
//  XO
//
//  Created by Kirill Gorbushko on 15.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "SwitchControlView.h"
#import "SoundButton.h"

@interface SwitchControlView()

@property (assign, nonatomic) NSInteger currentlySelectedElement;

@end

@implementation SwitchControlView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self prepareInitialParameters];
    }
    return self;
}

- (void)layoutSubviews
{
    [self drawElements];
}

#pragma mark - Public

- (void)selectElementWithTag:(NSUInteger)tag
{
    if (tag <= self.elementsCount) {
        SoundButton *prevButton = (SoundButton *)[self viewWithTag:self.currentlySelectedElement];
        prevButton.selected = NO;
        self.currentlySelectedElement = tag;
        SoundButton *selectedButton = (SoundButton *)[self viewWithTag:tag];
        selectedButton.selected = YES;
    }
}

#pragma mark - IbActions

- (void)didPressElement:(SoundButton *)element
{
    SoundButton *prevButton = (SoundButton *)[self viewWithTag:self.currentlySelectedElement];
    prevButton.selected = NO;
    self.currentlySelectedElement = element.tag;
    element.selected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchControlDidTappedButton:)]) {
        [self.delegate switchControlDidTappedButton:element];
    }
}

#pragma mark - Drawings

- (void)drawElements
{
    [self setupButtons];
}

- (void)setupButtons
{
    for (UIView *possibleButton in self.subviews) {
        if ([possibleButton isKindOfClass:[SoundButton class]]) {
            [possibleButton removeFromSuperview];
        }
    }
    
    CGRect buttonBoundsRect = CGRectMake(0, 0, self.frame.size.width / self.elementsCount, self.frame.size.height);
    
    for (int i = 0; i < self.elementsCount; i++) {
        CGFloat buttonXPoint = i * buttonBoundsRect.size.width;
        
        SoundButton *elementButton = [[SoundButton alloc] initWithFrame:CGRectMake(buttonXPoint, 0, buttonBoundsRect.size.width, buttonBoundsRect.size.height)];
        [elementButton setTitle:self.elementsNames[i] forState:UIControlStateNormal];
        
        [elementButton setTitleColor:self.activeElementTintColor forState:UIControlStateSelected];
        [elementButton setTitleColor:self.inActiveElementTintColor forState:UIControlStateNormal];
        [elementButton addTarget:self action:@selector(didPressElement:) forControlEvents:UIControlEventTouchDown];
        
        [elementButton setBackgroundImage:self.activeBackgroundImages[i] forState:UIControlStateSelected];
        [elementButton setBackgroundImage:self.inActiveBackgroundImages[i] forState:UIControlStateNormal];
        
        elementButton.titleLabel.font = [UIFont adigianaFontWithSize:24.f];

        elementButton.tag = i+1;
        
        if (i+1 == self.currentlySelectedElement) {
            elementButton.selected = YES;
        }
        
        [self addSubview:elementButton];
    }
}

#pragma mark - Private

- (void)prepareInitialParameters
{
    self.elementsCount = self.elementsCount ? self.elementsCount : 3;
    self.elementsNames = self.elementsNames.count ? self.elementsNames : @[@"First", @"Second", @"Third"];
    self.activeElementTintColor = self.activeElementTintColor ? self.activeElementTintColor : [UIColor lightGrayColor];
    self.inActiveElementTintColor = self.inActiveElementTintColor ? self.inActiveElementTintColor : [UIColor grayColor];
    
    self.currentlySelectedElement = 1;
}

- (void)addConstraintsForView:(UIView *)view
{
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeRight
                                                       multiplier:1.0
                                                         constant:0]
                           ]];
}

@end
