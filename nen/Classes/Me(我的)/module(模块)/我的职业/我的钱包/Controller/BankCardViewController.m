//
//  BankCardViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/25.
//  Copyright © 2017年 nen. All rights reserved.
//银行卡

#import "BankCardViewController.h"

@interface BankCardViewController ()

@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor lightGrayColor];
    topView.frame = CGRectMake(0,ScreenHeight - 51,ScreenWidth,1);
    [self.view addSubview:topView];
    
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0,ScreenHeight - 50,(ScreenWidth *0.5) - 0.5,50);
    [leftBtn setBackgroundColor:[UIColor whiteColor]];
    [leftBtn setImage:[UIImage imageNamed:@"yhzh"] forState:UIControlStateNormal];
    [leftBtn horizontalCenterImageAndTitle:24];
    [leftBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:leftBtn];
    
    UIView *centerView = [[UIView alloc] init];
    centerView.frame = CGRectMake(leftBtn.sh_right,leftBtn.sh_y,1,50);
    centerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:centerView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(centerView.sh_right,leftBtn.sh_y,(ScreenWidth *0.5) - 0.5,50);
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    [rightBtn setTitle:@"创建提现账户" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"银行卡";
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0,KNavBarBackBtnW, KNavBarBackBtnH);
    [leftButton setBackgroundImage:KNavBarBackIcon forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    nagetiveSpacer.width = KNavBarSpacing;   //这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,leftBarButtonItems];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:KNavBarTittleFont],
       
       NSForegroundColorAttributeName:KNavBarTitleColor }];
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintColor;
    
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
