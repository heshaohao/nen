//
//  AppointmentsViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/17.
//  Copyright © 2017年 nen. All rights reserved.
// 预约

#import "AppointmentsViewController.h"

@interface AppointmentsViewController ()

@end

@implementation AppointmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor ];
    
    [self addView];
}


- (void)addView
{
    
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0,109,ScreenWidth,150);
    [self.view addSubview:view];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.frame = CGRectMake(10, 0,ScreenWidth *0.8,25);
    topLabel.text = @"互联网+移动医用时长股份的过户是";
    topLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:topLabel];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"tabBar_publish_icon"];
    imageView.frame = CGRectMake(0,topLabel.sh_bottom + 20,60,60);
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(imageView.sh_right+ 10,imageView.sh_y,ScreenWidth - 125,35);
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"互联网+移动医用时长股份的过户都是";
    [view addSubview:titleLabel];
    
    UILabel *rightBottomLabel = [[UILabel alloc] init];
    rightBottomLabel.frame = CGRectMake(titleLabel.sh_right,titleLabel.sh_bottom,80,30);
    rightBottomLabel.font = [UIFont systemFontOfSize:13];
    rightBottomLabel.numberOfLines = 0;
    rightBottomLabel.text = @"¥299";
    [view addSubview:rightBottomLabel];
    
    UIButton *makeBtn = [[UIButton alloc] init];
    makeBtn.frame = CGRectMake(ScreenWidth *0.5,rightBottomLabel.sh_bottom + 10,ScreenWidth *0.2,25);
    [makeBtn setTitle:@"已预约" forState:UIControlStateNormal];
    [makeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    makeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    makeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    makeBtn.layer.borderWidth = 1.0f;
    [view addSubview:makeBtn];
    
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    confirmBtn.frame = CGRectMake(makeBtn.sh_right + 20 ,rightBottomLabel.sh_bottom + 10,ScreenWidth *0.2,25);
    [confirmBtn setTitle:@"提醒确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    confirmBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    confirmBtn.layer.borderWidth = 1.0f;
    [view addSubview:confirmBtn];
    
}

@end
