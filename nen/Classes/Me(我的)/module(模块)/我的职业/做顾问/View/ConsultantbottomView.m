//
//  ConsultantbottomView.m
//  nen
//
//  Created by nenios101 on 2017/3/14.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ConsultantbottomView.h"

@implementation ConsultantbottomView

// 话题管理
- (IBAction)topicBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"consultanTopic" object:self];
}
// 订单管理
- (IBAction)orderBtn:(UIButton *)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"consultanOrder" object:self];
}
// 查看消息
- (IBAction)wordBtn:(UIButton *)sender
{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"consultanWord" object:self];
}
// 顾问收入
- (IBAction)incomeBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"consultanincome" object:self];
    
}
// 我的主页
- (IBAction)homeBtn:(UIButton *)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"consultanhome" object:self];
}
// 设置主页
- (IBAction)setHomeBtn:(UIButton *)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"consultanSetHome" object:self];
}

@end
