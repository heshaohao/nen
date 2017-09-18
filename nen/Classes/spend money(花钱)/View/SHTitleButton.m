//
//  SHTitleButton.m
//  百思不得姐demo
//
//  Created by macbook pro on 16/10/15.
//  Copyright © 2016年 itcsas. All rights reserved.
//

#import "SHTitleButton.h"

@implementation SHTitleButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置按钮颜色
        // self.selected = NO;
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        // self.selected = YES;
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
 
        
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted
{
    
}


@end
