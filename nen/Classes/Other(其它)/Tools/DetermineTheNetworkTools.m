//
//  DetermineTheNetworkTools.m
//  nen
//
//  Created by nenios101 on 2017/6/30.
//  Copyright © 2017年 nen. All rights reserved.
//判断网络状态


#import "DetermineTheNetworkTools.h"


@implementation DetermineTheNetworkTools

 +(NSString *)isExistenceNetwork
{

// 状态栏是由当前app控制的，首先获取当前app
UIApplication *app = [UIApplication sharedApplication];

NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];

int type = 0;
for (id child in children) {
    if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
        type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
    }
}
    
switch (type) {
    case 1:
        
        return @"2G";
        
        break;
        
    case 2:
        
        return @"3G";
    case 3:
        
        return @"4G";
    case 5:
        
        return @"WIFI";
        
    default:
        
        return @"NO-WIFI";//代表未知网络
        
        break;
        
}
    
}

@end
