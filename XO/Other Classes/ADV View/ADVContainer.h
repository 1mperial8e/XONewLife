//
//  ADVContainer.h
//  XO
//
//  Created by Misha on 14.05.14.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADVContainer : UIView
@property (nonatomic) BOOL hidden;
@property (nonatomic) float size;
- (void)setHidden:(BOOL)hidden animate:(BOOL)animate;
@end
