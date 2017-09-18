//
//  ShopIntroduceController.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopIntroduceController.h"
#import "ShopIntroduceView.h"
@interface ShopIntroduceController ()

@end

@implementation ShopIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    scrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollV];
    
    ShopIntroduceView *shopView = [[[NSBundle mainBundle] loadNibNamed:@"ShopIntroduceView" owner:nil options:nil] lastObject];
    shopView.shopIntroducedDict = self.shopDict;
    shopView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    shopView.sh_x = 0;
    shopView.sh_y = 0;
    shopView.sh_width = ScreenWidth;
    shopView.sh_height = [shopView returnShopIntroduceViewHeight];
    scrollV.contentSize = CGSizeMake(0,[shopView returnShopIntroduceViewHeight] + 5);
    
    [scrollV addSubview:shopView];
    
    
    //[self.view addSubview:shopView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
}
#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"店铺介绍";
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
