//
//  AlertViewController.h
//  XO
//
//  Created by Stas Volskyi on 10/29/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

typedef NS_ENUM(NSInteger, AlertControllerStyle) {
    AlertControllerStyleAlertView,
    AlertControllerStyleActionSheet
};

@interface AlertViewController : UIViewController

@property (copy, nonatomic, nullable) NSString *controllerTitle;
@property (copy, nonatomic, nullable) NSString *message;
@property (copy, nonatomic, nullable, readonly) NSString *cancelButtonTitle;

/**
 * Default style AlertControllerStyleActionSheet
 */
@property (assign, nonatomic) AlertControllerStyle style;

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message;

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                                style:(AlertControllerStyle)style
                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

// MARK: Configure
- (void)addButtonWithTitle:(nonnull NSString *)title
                    target:(nonnull id)target
                  selector:(nonnull SEL)seletor;

- (void)addButtonWithTitle:(nonnull NSString *)title completionHandler:(void (^ _Nonnull)())completionHadler;

@end
