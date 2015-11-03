//
//  KeychainStorageService.m
//  XO
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "KeychainStorageService.h"
#import <Security/Security.h>

@implementation KeychainStorageService

#pragma mark - Public

+ (void)saveScore:(nonnull NSString *)score forAIMode:(nonnull NSString *)aiMode;
{
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    keychainItem[(__bridge id)kSecAttrService] = aiMode;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecAttrLabel] = score;
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
        if (status) {
            DLog(@"Score update error. Code: %d", (int)status);
        }
    } else {
        keychainItem[(__bridge id)kSecAttrLabel] = score;
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        if (status) {
            DLog(@"Score save error. Code: %d", (int)status);
        }
    }
}

+ (nullable NSString *)scoreForAIMode:(nonnull NSString *)aiMode
{
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    keychainItem[(__bridge id)kSecAttrService] = aiMode;
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    NSString *score;
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    if (status) {
        DLog(@"Score get error. Code: %d", (int)status);
    } else {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        score = resultDict[(__bridge id)kSecAttrLabel];
    }
    return score;
}

@end
