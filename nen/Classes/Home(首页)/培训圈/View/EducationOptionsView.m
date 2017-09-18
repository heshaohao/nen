//
//  EducationOptionsView.m
//  nen
//
//  Created by nenios101 on 2017/3/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "EducationOptionsView.h"
#import "EducationOptionModel.h"


@interface EducationOptionsView ()

@property(nonatomic,assign) NSInteger indexCount;

@property(nonatomic,strong) UIButton *btn;

@end

@implementation EducationOptionsView

- (instancetype)initWithFrame:(CGRect)frame Model:(EducationOptionModel *)model Index:(NSInteger)index
{
    
    _model = model;
    
    self.indexCount = index;
    
    self = [super initWithFrame:frame];
    if (self)
    {
       _btn= [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonX = 5;
        CGFloat buttonY = 5;
        CGFloat buttonW = 50;
        CGFloat buttonH = 50;
        [_btn setBackgroundImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
        _btn.titleLabel.font = [UIFont systemFontOfSize:13];
        _btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        _btn.backgroundColor = [UIColor orangeColor];
        
        
        [self addSubview:_btn];
        
        UILabel *namelable = [[UILabel alloc] init];
        namelable.font = [UIFont systemFontOfSize:12];
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
 
}


@end
