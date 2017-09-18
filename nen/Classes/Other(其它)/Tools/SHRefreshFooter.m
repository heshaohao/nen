//
//  ShRefreshFooter.m
//  nen
//
//  Created by nenios101 on 2017/4/11.
//  Copyright © 2017年 nen. All rights reserved.
//上拉控件

#import "SHRefreshFooter.h"

@implementation SHRefreshFooter

- (void)prepare
{
    [super prepare];
    
    //self.triggerAutomaticallyRefreshPercent = 0;
   
    [self setTitle:@"加载更多" forState:MJRefreshStateRefreshing];

}
@end
