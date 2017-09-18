//
//  GuidanceInstructionsViewController.m
//  nen
//
//  Created by apple on 17/5/29.
//  Copyright © 2017年 nen. All rights reserved.
// 指引说明
#import "GuidanceInstructionsViewController.h"

@interface GuidanceInstructionsViewController ()

@end

@implementation GuidanceInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat Y = 10;
    CGFloat titlleFont = 12;
    CGFloat W = ScreenWidth - 20;
    
   self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10,75,200,20);
    titleLabel.font = [UIFont systemFontOfSize:titlleFont];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = @"世袭传承规则办理步骤:";
    [self.view addSubview:titleLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.frame = CGRectMake(10,titleLabel.sh_bottom + Y,W,20);
    titleLabel1.font = [UIFont systemFontOfSize:titlleFont];
    titleLabel1.textColor = [UIColor lightGrayColor];
    titleLabel1.text = @"1、您决定传给谁, 确定人选;";
    [self.view addSubview:titleLabel1];
    
    
    UILabel *titleLabel2 = [[UILabel alloc] init];
    titleLabel2.frame = CGRectMake(10,titleLabel1.sh_bottom + Y,W,20);
    titleLabel2.font = [UIFont systemFontOfSize:titlleFont];
    titleLabel2.textColor = [UIColor lightGrayColor];
    titleLabel2.text = @"2、提供经办处公正的世袭传承协议书或授权书;";
    [self.view addSubview:titleLabel2];
    
    UILabel *titleLabel3 = [[UILabel alloc] init];
    titleLabel3.frame = CGRectMake(10,titleLabel2.sh_bottom + Y,W,20);
    titleLabel3.font = [UIFont systemFontOfSize:titlleFont];
    titleLabel3.textColor = [UIColor lightGrayColor];
    titleLabel3.text = @"3、携带授权人与接受人双方的有效证件;";
    [self.view addSubview:titleLabel3];
    
    UILabel *titleLabel4 = [[UILabel alloc] init];
    titleLabel4.frame = CGRectMake(10,titleLabel3.sh_bottom + Y,W,20);
    titleLabel4.font = [UIFont systemFontOfSize:titlleFont];
    titleLabel4.textColor = [UIColor lightGrayColor];
    titleLabel4.text = @"4、提供以上资料到网一网平台“我的管理”申请办理;";
    [self.view addSubview:titleLabel4];

    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self setNavBar];
    
}

- (void)setNavBar
{
    self.navigationItem.title = @"指引说明";
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
