//
//  PointConfirmViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/17.
//  Copyright © 2017年 nen. All rights reserved.
//待确认

#import "PointConfirmViewController.h"

@interface PointConfirmViewController ()

@end

@implementation PointConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEmptyView];
}

- (void)setEmptyView
{
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 64,ScreenWidth,ScreenHeight - 64)];
    backgroundView.tag = 100;
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Snip"]];
    img.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.frame = CGRectMake(ScreenWidth *0.5 - 40 ,img.sh_bottom + 10,80,35);
    warnLabel.text = @"暂无数据!";
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = LZColorFromHex(0x706F6F);
    [backgroundView addSubview:warnLabel];
    
    
}


@end
