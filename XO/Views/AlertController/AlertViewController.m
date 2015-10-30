//
//  AlertViewController.m
//  XO
//
//  Created by Stas Volskyi on 10/29/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AlertViewController.h"
#import "SoundButton.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

static CGFloat const DefaultSpacing = 10.0f;
static CGFloat const ButtonHeight = 75.0f;

static CGFloat const AlertViewWidthMultiplier = 0.7f;
static CGFloat const ActionSheetWidthMultiplier = 0.9f;

static CGFloat const ActionSheetAnimationTime = 0.35f;

@interface AlertViewController ()

@property (strong, nonatomic, nonnull) NSMutableArray<NSObject *> *otherButtons;
@property (strong, nonatomic, nonnull) NSMutableDictionary *buttonsHanlers;

@property (strong, nonatomic, nonnull) UIView *container;

@property (assign, nonatomic) BOOL closedByCancelButton;

@property (strong, nonatomic, nullable) SoundButton *closedButton;

@end

@implementation AlertViewController

#pragma mark - Init

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
{
    return [self initWithTitle:title
                       message:message
                         style:AlertControllerStyleActionSheet
             cancelButtonTitle:nil];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
{
    return [self initWithTitle:title
                       message:message
                         style:AlertControllerStyleActionSheet
             cancelButtonTitle:cancelButtonTitle];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(AlertControllerStyle)style
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
{
    self = [super init];
    if (self) {
        self.controllerTitle = title;
        self.message = message;
        _cancelButtonTitle = cancelButtonTitle;
        self.style = style;
        self.otherButtons = [NSMutableArray array];
        self.buttonsHanlers = [NSMutableDictionary dictionary];
        
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

#pragma mark - Configure

- (void)addButtonWithTitle:(nonnull NSString *)title
                    target:(nonnull id)target
                  selector:(nonnull SEL)selector
{
    NSParameterAssert(title);
    NSParameterAssert(target);
    NSParameterAssert(selector);
    
    if (title.length && target && selector) {
        SoundButton *button = [[SoundButton alloc] init];
        button.target = target;
        button.selector = selector;
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(targetedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.otherButtons addObject:button];
    }
}

- (void)addButtonWithTitle:(nonnull NSString *)title completionHandler:(void (^ _Nonnull)())completionHadler
{
    NSParameterAssert(title);
    if (title && completionHadler) {
        SoundButton *button = [[SoundButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(customButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.otherButtons addObject:button];
        
        void (^handlerCopy)() = [completionHadler copy];
        NSParameterAssert(handlerCopy);
        [self.buttonsHanlers setObject:handlerCopy forKey:[NSString stringWithFormat: @"%p", button]];
    }
}

#pragma mark - Handler

- (void)cancelButtonAction:(id)sender
{
    self.closedByCancelButton = YES;
    if (self.style == AlertControllerStyleAlertView) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self animateAlertDismiss];
    }
}

- (void)customButtonAction:(SoundButton *)sender
{
    if (self.style == AlertControllerStyleActionSheet && self.container.layer.animationKeys.count == 0) {
        self.closedButton = sender;
        [self animateAlertDismiss];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf callHandlerForButton:sender];
    }];
}

- (void)targetedButtonAction:(SoundButton *)sender
{
    if (self.style == AlertControllerStyleAlertView) {
        [self dismissViewControllerAnimated:YES completion:^{
            [sender.target performSelectorOnMainThread:sender.selector withObject:sender waitUntilDone:NO];
        }];
    } else {
        self.closedButton = sender;
        [self animateAlertDismiss];
    }
}

- (void)callHandlerForButton:(SoundButton *)sender
{
    void (^handler)() = self.buttonsHanlers[[NSString stringWithFormat: @"%p", sender]];
    if (handler) {
        handler();
    }
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCancelButton];
    [self setupBaseUI];
    
    self.closedByCancelButton = NO;
    if (self.style == AlertControllerStyleActionSheet) {
        [self buildActionSheet];
        CGPoint center = self.container.center;
        center.y += CGRectGetHeight(self.container.frame);
        self.container.center = center;
    } else {
        [self buildAlertView];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.style == AlertControllerStyleActionSheet && !self.container.layer.animationKeys.count) {
        [self animateAlertPresent];
    }
}

#pragma mark - Private

- (void)addCancelButton
{
    if (self.cancelButtonTitle.length) {
        SoundButton *button = [[SoundButton alloc] init];
        [button setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.otherButtons addObject:button];
    }
}

#pragma mark - Build UI

- (void)setupBaseUI
{
    self.view.backgroundColor = [UIColor colorWithRed:50 / 255.0 green:28 / 255.0 blue:0 alpha:0.85];
}

- (void)buildActionSheet
{
    [self buildAlertView];
    
    CGRect frame = self.container.frame;
    frame.origin.y = ScreenHeight - CGRectGetHeight(frame);
    self.container.frame = frame;
}

- (void)buildAlertView
{
    CGFloat containerHeight = DefaultSpacing;
    CGFloat containerWidth = ScreenWidth * self.widthMultiplier;
    
    UILabel *titleLabel = [self labelWithText:self.controllerTitle];
    containerHeight += CGRectGetHeight(titleLabel.frame);
    containerHeight += DefaultSpacing;
    
    UILabel *messageLabel = [self labelWithText:self.message];
    containerHeight += CGRectGetHeight(messageLabel.frame);
    containerHeight += DefaultSpacing;

    for (SoundButton *button in self.otherButtons) {
        button.frame = CGRectMake(0, 0, ScreenWidth * self.widthMultiplier - 0.1, ButtonHeight);
        button.titleLabel.font = self.textFont;
        
        int imageNumber = arc4random_uniform(2) + 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"button%i", imageNumber]];
        NSParameterAssert(image);
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitleColor:[UIColor appButtonTextColor] forState:UIControlStateNormal];

        containerHeight += ButtonHeight + DefaultSpacing;
    }
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerWidth, containerHeight)];
    container.backgroundColor = [UIColor clearColor];
    container.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    
    CGFloat lastControlMaxY = DefaultSpacing;
    CGFloat containerCenterX = CGRectGetMidX(container.bounds);
    if (titleLabel) {
        CGRect frame = titleLabel.frame;
        frame.origin.y = lastControlMaxY;
        frame.origin.x = containerCenterX - CGRectGetWidth(frame) / 2;
        titleLabel.frame = frame;
        
        [container addSubview:titleLabel];
        lastControlMaxY = CGRectGetMaxY(titleLabel.frame);
    }
    
    if (messageLabel) {
        CGRect frame = messageLabel.frame;
        frame.origin.y = DefaultSpacing + lastControlMaxY;
        frame.origin.x = containerCenterX - CGRectGetWidth(frame) / 2;
        messageLabel.frame = frame;
        
        [container addSubview:messageLabel];
        lastControlMaxY = CGRectGetMaxY(messageLabel.frame);
    }
    
    lastControlMaxY += DefaultSpacing;
    for (SoundButton *button in self.otherButtons) {
        CGRect frame = button.frame;
        frame.origin.y = lastControlMaxY;
        frame.origin.x = containerCenterX - CGRectGetWidth(frame) / 2;
        button.frame = frame;
        
        [container addSubview:button];
        lastControlMaxY = CGRectGetMaxY(button.frame);
    }
    self.container = container;
    [self.view addSubview:container];
}

- (UILabel *)labelWithText:(nullable NSString *)text
{
    UILabel *label;
    if (text.length) {
        label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textColor = [UIColor appNavigationBarTextColor];
        
        BOOL isTitle = [text isEqualToString:self.controllerTitle];
        label.font = isTitle ? self.titleFont : self.textFont;

        CGSize labelSize = [label sizeThatFits:CGSizeMake(ScreenWidth * (isTitle ? self.widthMultiplier - 0.1 : self.widthMultiplier), CGFLOAT_MAX)];
        label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    }
    return label;
}

#pragma mark - Customize

- (UIFont *)titleFont
{
    UIFont *font = [UIFont adigianaFontWithSize:28.0];
    NSParameterAssert(font);
    return font;
}

- (UIFont *)textFont
{
    UIFont *font = [UIFont adigianaFontWithSize:24.0];
    NSParameterAssert(font);
    return font;
}

- (CGFloat)widthMultiplier
{
    return self.style == AlertControllerStyleAlertView ? AlertViewWidthMultiplier : ActionSheetWidthMultiplier;
}

#pragma mark - Animation

- (void)animateAlertPresent
{
    CABasicAnimation *positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnim.fromValue = [NSValue valueWithCGPoint:self.container.center];
    CGPoint toPoint = self.container.center;
    toPoint.y -= CGRectGetHeight(self.container.frame);
    positionAnim.toValue = [NSValue valueWithCGPoint:toPoint];
    positionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    positionAnim.duration = ActionSheetAnimationTime;
    [self.container.layer addAnimation:positionAnim forKey:@"present"];
    self.container.layer.position = toPoint;
}

- (void)animateAlertDismiss
{
    CABasicAnimation *positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnim.fromValue = [NSValue valueWithCGPoint:self.container.center];
    CGPoint toPoint = self.container.center;
    toPoint.y += CGRectGetHeight(self.container.frame);
    positionAnim.toValue = [NSValue valueWithCGPoint:toPoint];
    positionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    positionAnim.duration = ActionSheetAnimationTime;
    positionAnim.delegate = self;
    positionAnim.removedOnCompletion = NO;
    [self.container.layer addAnimation:positionAnim forKey:@"dismiss"];
    self.container.layer.position = toPoint;
    
    CABasicAnimation *fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = @1;
    fadeAnim.toValue = @0;
    fadeAnim.duration = ActionSheetAnimationTime;
    [self.view.layer addAnimation:fadeAnim forKey:nil];
    self.view.layer.opacity = 0;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.container.layer animationForKey:@"dismiss"]) {
        if (self.closedButton) {
            if (self.closedButton.target && self.closedButton.selector) {
                [self.closedButton.target performSelectorOnMainThread:self.closedButton.selector withObject:self.closedButton waitUntilDone:NO];
            } else {
                [self callHandlerForButton:self.closedButton];
            }
            [self dismissViewControllerAnimated:NO completion:nil];
        } else if (self.closedByCancelButton) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        [self.container.layer removeAnimationForKey:@"dismiss"];
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.otherButtons.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
