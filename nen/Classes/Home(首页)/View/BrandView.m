//
//  brandView.m
//  nen
//
//  Created by nenios101 on 2017/2/28.
//  Copyright © 2017年 nen. All rights reserved.
//品牌推荐

#import "BrandView.h"
#import "OptionModel.h"

@interface BrandView ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation BrandView

- (instancetype)initWithFrame:(CGRect)frame Model:(OptionModel *)model
{
    _model = model;
    
    self = [super initWithFrame:frame];
    if (self)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonX = 10;
        CGFloat buttonY = 5;
        CGFloat buttonW = 60;
        CGFloat buttonH = 50;
        [_button setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
        [_button sizeToFit];
        [_button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
        _button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self addSubview:_button];
    }
    return self;
}

- (void)tapButton
{
   // NSLog(@"按钮比点击");
}


@end
