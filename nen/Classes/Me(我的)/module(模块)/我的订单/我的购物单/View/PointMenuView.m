//
//  PointMenuView.m
//  nen
//
//  Created by nenios101 on 2017/4/13.
//  Copyright © 2017年 nen. All rights reserved.
// 我的点餐单

#import "PointMenuView.h"

@implementation PointMenuView

// 我的点餐单
- (IBAction)pushPoint:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"0"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ponitVc" object:self userInfo:dict];
}
// 待付款
- (IBAction)makeBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"1"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ponitVc" object:self userInfo:dict];
}

// 待确认
- (IBAction)sendOutBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"2"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ponitVc" object:self userInfo:dict];
}


// 待付款
- (IBAction)receivingBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"3"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ponitVc" object:self userInfo:dict];
}

// 待就餐
- (IBAction)repastBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"4"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ponitVc" object:self userInfo:dict];
}
// 评价
- (IBAction)appraiseBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"5"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ponitVc" object:self userInfo:dict];
}

@end
