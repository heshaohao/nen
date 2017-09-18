//
//  DrivingOrderView.m
//  nen
//
//  Created by nenios101 on 2017/4/13.
//  Copyright © 2017年 nen. All rights reserved.
// 我的驾校单


#import "DrivingOrderView.h"

@implementation DrivingOrderView
// 我的驾校订单
- (IBAction)pushAllOrder:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"0"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"drivingVc" object:self userInfo:dict];
}
// 待付款
- (IBAction)payBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"1"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"drivingVc" object:self userInfo:dict];
}

// 待确认
- (IBAction)confirmBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"2"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"drivingVc" object:self userInfo:dict];
}


// 待学习
- (IBAction)studyBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"3"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"drivingVc" object:self userInfo:dict];
}

// 待评价
- (IBAction)evaluateBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"4"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"drivingVc" object:self userInfo:dict];
}

@end
