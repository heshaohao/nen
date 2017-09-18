//
//  ShRefreshHeader.m
//  nen
//
//  Created by nenios101 on 2017/4/11.
//  Copyright © 2017年 nen. All rights reserved.
//下拉控件

#import "SHRefreshHeader.h"

@implementation SHRefreshHeader

- (void)prepare
{
    [super prepare];
    
    [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [self setTitle:@"刷新最新数据" forState:MJRefreshStatePulling];
    
}

@end
