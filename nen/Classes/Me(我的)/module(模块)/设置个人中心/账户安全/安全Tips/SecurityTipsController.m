//
//  SecurityTipsController.m
//  nen
//
//  Created by nenios101 on 2017/6/16.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SecurityTipsController.h"

@interface SecurityTipsController ()

@end

@implementation SecurityTipsController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.text = @"一 设置密码";
    leftLabel.frame = CGRectMake(10,80,200,30);
    [self.view addSubview:leftLabel];
    
    UILabel *bootomLable = [[UILabel alloc] init];
    bootomLable.frame = CGRectMake(10,leftLabel.sh_bottom + 10,ScreenWidth - 20,40);
    bootomLable.font = [UIFont systemFontOfSize:13];
    bootomLable.text = @"设置密码设置密码设置密码设置密码设置密码设置密码设置密码设置密码设置密码设置密码设置密码设置密码";
    bootomLable.numberOfLines = 0;
    [self.view addSubview:bootomLable];
    
    
    UIButton *customerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customerBtn.frame = CGRectMake(20 ,bootomLable.sh_bottom + 40,ScreenWidth - 40,40);
    [customerBtn setTitle:@"客服电话: 400 - 800 - 2004" forState:UIControlStateNormal];
    customerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    customerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [customerBtn setBackgroundColor:[UIColor orangeColor]];
    customerBtn.layer.cornerRadius = 5;
    customerBtn.clipsToBounds = YES;
    [self.view addSubview:customerBtn];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"安全Tips";
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
