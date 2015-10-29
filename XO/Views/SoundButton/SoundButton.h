//
//  SoundButton.h
//  XO
//
//  Created by Kirill Gorbushko on 26.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

@interface SoundButton : UIButton

@property (weak, nonatomic, nullable) id target;
@property (assign, nonatomic, nullable) SEL selector;

@end
