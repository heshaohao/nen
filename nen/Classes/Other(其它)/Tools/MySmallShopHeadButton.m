//
//  MySmallShopHeadButton.m
//  nen
//
//  Created by nenios101 on 2017/6/16.
//  Copyright © 2017年 nen. All rights reserved.
// 微信顶部四个

#import "MySmallShopHeadButton.h"

@implementation MySmallShopHeadButton
- (void)awakeFromNib
{
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.sh_y = 10;
    self.imageView.sh_centerX = self.sh_width * 0.5;
    
    self.titleLabel.sh_x = 0;
    self.titleLabel.sh_y = self.imageView.sh_bottom  + 5;
    self.titleLabel.sh_height = (self.sh_height - self.titleLabel.sh_y) + 5;
    self.titleLabel.sh_width = self.sh_width;
    
}


@end
