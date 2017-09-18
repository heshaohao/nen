//
//  AftermarketViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/17.
//  Copyright © 2017年 nen. All rights reserved.
// 退款

#import "AftermarketViewController.h"

@interface AftermarketViewController ()

@property(nonatomic,strong) UIView *orderView;
@end

@implementation AftermarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];

    [self addoOrderView];
    
    [self addGoodsView];
    
}

- (void)addoOrderView
{
    UIView *orderView = [[UIView alloc] init];
    self.orderView = orderView;
    orderView.frame = CGRectMake(0,144,ScreenWidth,60);
    orderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderView];
    
    UILabel *orderLabel = [[UILabel alloc] init];
    orderLabel.text = @"订单编号: 256952554";
    orderLabel.font = [UIFont systemFontOfSize:13];
    orderLabel.frame = CGRectMake(0, 0,ScreenWidth *0.5,30);
    [orderView addSubview:orderLabel];
    
    UILabel *waitingReceivingLabel = [[UILabel alloc] init];
    waitingReceivingLabel.font = [UIFont systemFontOfSize:13];
    waitingReceivingLabel.textColor = [UIColor orangeColor];
    waitingReceivingLabel.frame = CGRectMake(ScreenWidth *0.8,0,80,30);
    waitingReceivingLabel.text =@"等待收货";
    [orderView addSubview:waitingReceivingLabel];
    
    UILabel *orderTimeLabel = [[UILabel alloc] init];
    orderTimeLabel.text = @"下单时间: 2016-9-1 18:32:21";
    orderTimeLabel.font = [UIFont systemFontOfSize:13];
    orderTimeLabel.frame = CGRectMake(0, orderLabel.sh_bottom ,ScreenWidth *0.7,30);
    [orderView addSubview:orderTimeLabel];

    
}

- (void)addGoodsView
{
    UIView *goodsView = [[UIView alloc] init];
    goodsView.frame = CGRectMake(0,self.orderView.sh_bottom + 30,ScreenWidth,120);
    goodsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:goodsView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"2"];
    imageView.frame = CGRectMake(10,10,100,100);
    [goodsView addSubview:imageView];
    
    UILabel *goodsTitle = [[UILabel alloc] init];
    goodsTitle.text = @"索DSFDSFSFDSF泰歌功颂德分GUDGFDGSD";
    goodsTitle.textAlignment = NSTextAlignmentLeft;
    goodsTitle.font = [UIFont systemFontOfSize:13];
    goodsTitle.frame = CGRectMake(imageView.sh_right + 10, imageView.sh_y,ScreenWidth * 0.55,40);
    goodsTitle.numberOfLines = 0;
    [goodsView addSubview:goodsTitle];

    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(ScreenWidth - 80,goodsView.sh_height - 35,60,25);
    [btn setTitle:@"售后申请" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setBackgroundColor:[UIColor orangeColor]];
    
    [goodsView addSubview:btn];
    
}





@end
