//
//  ReservationListView.m
//  nen
//
//  Created by nenios101 on 2017/4/13.
//  Copyright © 2017年 nen. All rights reserved.
// 我的预约单

#import "ReservationListView.h"

@implementation ReservationListView

// 我的预约单
- (IBAction)pushMakeOrder:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"0"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"makeVc" object:self userInfo:dict];
}
// 预约
- (IBAction)makeBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"1"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"makeVc" object:self userInfo:dict];
}

// 待确认
- (IBAction)confirmBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"2"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"makeVc" object:self userInfo:dict];
}


// 待付款
- (IBAction)paymentBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"3"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"makeVc" object:self userInfo:dict];
}
// 待见面
- (IBAction)meetBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"4"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"makeVc" object:self userInfo:dict];
}



// 待评价
- (IBAction)evaluateBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"5"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"makeVc" object:self userInfo:dict];
}

@end
