//
//  KeychainStorageService.h
//  XO
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

@interface KeychainStorageService : NSObject

+ (void)saveScore:(nonnull NSString *)score forAIMode:(nonnull NSString *)aiMode;
+ (nullable NSString *)scoreForAIMode:(nonnull NSString *)aiMode;

@end