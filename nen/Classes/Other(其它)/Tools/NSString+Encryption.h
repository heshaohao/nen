//
//  NSString+Encryption.h
//  nen
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encryption)

/**
 *  POST返回加密后的地址
 */
+(instancetype)stringEncryptedAddress:(NSString *)address;

/**
 *  GET返回加密后的地址
 */
+(instancetype)stringGETEncryptedAddress:(NSString *)address index:(NSString *)index;


@end
