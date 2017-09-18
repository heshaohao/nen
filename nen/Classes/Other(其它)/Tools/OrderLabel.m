//
//  OrderLabel.m
//  nen
//
//  Created by nenios101 on 2017/4/13.
//  Copyright © 2017年 nen. All rights reserved.
// 显示购物车数量label

#import "OrderLabel.h"

@implementation OrderLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textAlignment = NSTextAlignmentCenter;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 7.5;
    self.layer.masksToBounds = YES;
    
}




@end
