//
//  ProfessionalView.m
//  nen
//
//  Created by nenios101 on 2017/3/2.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ProfessionalView.h"

@interface ProfessionalView ()


@end

@implementation ProfessionalView

// 商品管理 ||开微店
- (IBAction)SmallShop:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weidian" object:self];
}
// 订单管理 ||开驾校
- (IBAction)consultant:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"consultant" object:self];
}
// 评论
- (IBAction)teacher:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doTeacher" object:self];
}
// 更多
- (IBAction)master:(UIButton *)sender {
    
   [[NSNotificationCenter defaultCenter] postNotificationName:@"profess" object:self];
}

// 钱包
- (IBAction)myMoneyWrapBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moneyWrap"object:self];
}

// 我的职业

- (IBAction)professionalBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profess" object:self];
}

// 我的收藏
- (IBAction)myCollection:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myCollection" object:self];
}

- (IBAction)shoppingCar:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushShoopingCatVc" object:self];
}


@end
