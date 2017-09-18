//
//  PostBtn.m
//  nen
//
//  Created by nenios101 on 2017/6/23.
//  Copyright © 2017年 nen. All rights reserved.
// 帖子按钮

#import "PostBtn.h"

@implementation PostBtn
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.sh_y = 0;
    self.imageView.sh_x = 0;
    self.imageView.sh_width = self.sh_width *0.3;
    
    self.titleLabel.sh_x = self.imageView.sh_right;
    self.titleLabel.sh_y = 3;
    self.titleLabel.sh_height = self.sh_height - 3;
    self.titleLabel.sh_width = self.sh_width *0.7;
    
}

@end
