//
//  ProgressViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/17.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ProgressViewController.h"

@interface ProgressViewController ()

@property(nonatomic,strong) UIView *orderView;

@end

@implementation ProgressViewController

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
    orderLabel.frame = CGRectMake(0, 0,ScreenWidth *0.5,20);
    [orderView addSubview:orderLabel];
    
    UILabel *waitingReceivingLabel = [[UILabel alloc] init];
    waitingReceivingLabel.font = [UIFont systemFontOfSize:13];
    waitingReceivingLabel.textColor = [UIColor orangeColor];
    waitingReceivingLabel.frame = CGRectMake(ScreenWidth *0.8,0,80,20);
    waitingReceivingLabel.text =@"已完成";
    [orderView addSubview:waitingReceivingLabel];
    
    UILabel *serviceLabel = [[UILabel alloc] init];
    serviceLabel.text = @"您的服务单256952554网一网平台操作已完成,若有疑问请留言板反馈。谢谢";
    serviceLabel.font = [UIFont systemFontOfSize:13];
    serviceLabel.numberOfLines = 0;
    serviceLabel.frame = CGRectMake(0, orderLabel.sh_bottom ,ScreenWidth,40);
    [orderView addSubview:serviceLabel];
    
    
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
    [btn setTitle:@"售后进度" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setBackgroundColor:[UIColor orangeColor]];
    
    [goodsView addSubview:btn];
    
}

@end
