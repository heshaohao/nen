//
//  CurrencyView.m
//  nen
//
//  Created by nenios101 on 2017/2/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#define Width [UIScreen mainScreen].bounds.size.width
#import "CurrencyView.h"

@implementation CurrencyView


+ (instancetype)currencyViewWithYvalue:(CGFloat)yvalue LeftTitle:(NSString *)leftTitle andRightTitle:(NSString*)rightTitle
{
    UIView *currencyView = [[UIView alloc] init];
    currencyView.frame = CGRectMake(0,yvalue,Width, 20);
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = leftTitle;
    leftLabel.font = [UIFont systemFontOfSize:12];
    leftLabel.textColor = [UIColor orangeColor];
    leftLabel.frame = CGRectMake(10,0,80,15);
    UIButton *rightLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightLabel setTitle:[NSString stringWithFormat:@"%@",rightTitle] forState:UIControlStateNormal];
    [rightLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rightLabel.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    rightLabel.frame = CGRectMake(Width - 100 ,0, 100,20);
    [currencyView addSubview:rightLabel];
    
    [currencyView addSubview:leftLabel];
    
    return currencyView;
}

@end
