//
//  TeacherBottomView.m
//  nen
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "TeacherBottomView.h"

@implementation TeacherBottomView

// 话题管理

- (IBAction)topicBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"teacherTopic" object:self];
}


// 订单管理
- (IBAction)orderBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"teacherOrder" object:self];
}
// 查看消息
- (IBAction)wordBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"teacherWord" object:self];
}
// 顾问收入
- (IBAction)incomeBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"teacherincome" object:self];
    
}
// 我的主页
- (IBAction)homeBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"teacherhome" object:self];
}
// 设置主页
- (IBAction)setHomeBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"teacherSetHome" object:self];
}

@end
