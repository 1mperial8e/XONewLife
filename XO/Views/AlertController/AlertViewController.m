//
//  AlertViewController.m
//  XO
//
//  Created by Stas Volskyi on 10/29/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AlertViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface AlertViewController ()

@property (strong, nonatomic, nonnull) NSMutableArray<NSObject *> *otherButtons;
@property (strong, nonatomic, nonnull) NSMutableDictionary *buttonsHanlers;

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
        
        [self setupBaseUI];
    }
    return self;
}

#pragma mark - Configure

- (void)addButtonWithTitle:(nonnull NSString *)title
                    target:(nonnull id)target
                  selector:(nonnull SEL)seletor
{
    NSParameterAssert(title);
    NSParameterAssert(target);
    NSParameterAssert(seletor);
    
    if (title.length && target && seletor) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:target action:seletor forControlEvents:UIControlEventTouchUpInside];
        [self.otherButtons addObject:button];
    }
}

- (void)addButtonWithTitle:(nonnull NSString *)title completionHandler:(void (^ _Nonnull)())completionHadler
{
    NSParameterAssert(title);
    if (title && completionHadler) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(customButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        void (^handlerCopy)() = [completionHadler copy];
        NSParameterAssert(handlerCopy);
        [self.buttonsHanlers setObject:handlerCopy forKey:[NSString stringWithFormat: @"%p", button]];
    }
}

#pragma mark - Handler

- (void)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)customButtonAction:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        void (^handler)() = weakSelf.buttonsHanlers[[NSString stringWithFormat: @"%p", sender]];
        if (handler) {
            handler();
        }
    }];
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCancelButton];
    
    if (self.style == AlertControllerStyleActionSheet) {
        [self buildActionSheet];
    } else {
        [self buildAlertView];
    }
}

#pragma mark - Private

- (void)addCancelButton
{
    if (self.cancelButtonTitle.length) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.otherButtons addObject:button];
    }
}

#pragma mark - Build UI

- (void)setupBaseUI
{
    self.view.backgroundColor = [UIColor colorWithRed:68 / 255.0 green:28 / 255.0 blue:0 alpha:0.7];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

- (void)buildActionSheet
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
}

- (void)buildAlertView
{
    UILabel *titleLabel = [self titleLabel];
}

- (UILabel *)titleLabel
{
    NSDictionary *textAttributes = @{NSFontAttributeName : self.textFont,
                                     NSParagraphStyleAttributeName : self.paragraphStyle};
    
    UILabel *titleLabel;
    if (self.controllerTitle.length) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.controllerTitle;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        CGSize labelSize = [self.controllerTitle sizeWithAttributes:textAttributes];
        titleLabel.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    }
    return titleLabel;
}

#pragma mark - Customize

- (UIFont *)textFont
{
    UIFont *font;
    NSParameterAssert(font);
    return font;
}

- (NSParagraphStyle *)paragraphStyle
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    return paragraph;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.otherButtons.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
