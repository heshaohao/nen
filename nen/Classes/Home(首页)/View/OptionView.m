//
//  OptionView.m
//  nen
//
//  Created by nenios101 on 2017/2/28.
//  Copyright © 2017年 nen. All rights reserved.
//九宫格

#import "OptionView.h"
#import "OptionModel.h"

@interface OptionView ()

@property (nonatomic, strong) UIButton *button;

@property(nonatomic,assign) NSInteger indexCount;

@end


@implementation OptionView


- (instancetype)initWithFrame:(CGRect)frame Model:(OptionModel *)model Index:(NSInteger)index
{
    
    _model = model;
    
    self.indexCount = index;
    
    self = [super initWithFrame:frame];
    if (self)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonW = 50;
        CGFloat buttonY = 0;
        CGFloat buttonH = 50;
        CGFloat buttonX = (((ScreenWidth - 15) / 4)*0.5) - 25;
        [_button setBackgroundImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button sizeToFit];
        
        
        
        _button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [self addSubview:_button];
        
        UILabel *namelable = [[UILabel alloc] init];
        namelable.font = [UIFont systemFontOfSize:13];
        namelable.frame = CGRectMake(0, (buttonY + buttonH)+ 5,self.frame.size.width,15);
        namelable.textColor = [UIColor blackColor];
        namelable.textAlignment = NSTextAlignmentCenter;
        namelable.text = model.name;
        [self addSubview:namelable];
        
        
        
    }
    return self;
}

- (void)tapButton
{
    
   // NSDictionary *dict = @{@"name":@"lisi",@"age":@(30), @"isMarryed":@(YES)}
    
    NSDictionary *dict = @{@"index":@(self.indexCount)};
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"optionClick" object:self userInfo:dict];
}

@end
