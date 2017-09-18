//
//  NSString+Encryption.m
//  nen
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 nen. All rights reserved.
//翻回加密后的网络请求地址

#import "NSString+Encryption.h"

@implementation NSString (Encryption)

+(instancetype)stringEncryptedAddress:(NSString *)address
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *keyStr =[defaults objectForKey:@"key"];
    
    
    NSString *secretStr = [defaults objectForKey:@"secret"];
    
    NSDate * today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:today];
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    
    NSString *sign = [NSString stringWithFormat:@"%@?key=%@&ts=%@&secret=%@",address,keyStr,timeSp,secretStr];
    
  
    
    // MD5加密
    sign = [sign md5String];
    
    NSString *splitCompleteStr = [NSString stringWithFormat:@"key=%@&ts=%@&sign=%@",keyStr,timeSp,sign];
    
    
    NSString *str = [NSString stringWithFormat:@"http://api.neno2o.com%@?",address];
    splitCompleteStr = [str stringByAppendingString:splitCompleteStr];
    
    return splitCompleteStr;
    
}


+(instancetype)stringGETEncryptedAddress:(NSString *)address index:(NSString *)index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger indexs = [index integerValue];
    
    NSNumber *indexss = @(indexs);
    
    NSString *keyStr =[defaults objectForKey:@"key"];
    
    
    NSString *secretStr = [defaults objectForKey:@"secret"];
    
    NSDate * today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:today];
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    
    // Key 时间戳
    NSString *sign = [NSString stringWithFormat:@"%@?parent_id=%@&key=%@&ts=%@&secret=%@",address,indexss,keyStr,timeSp,secretStr];
    
    
    // MD5加密
    sign = [sign md5String];
    
    NSString *splitCompleteStr = [NSString stringWithFormat:@"&key=%@&ts=%@&sign=%@",keyStr,timeSp,sign];
    
    
    NSString *str = [NSString stringWithFormat:@"http://api.neno2o.com%@?parent_id=%@",address,indexss];
    splitCompleteStr = [str stringByAppendingString:splitCompleteStr];
    
    return splitCompleteStr;

}

@end
