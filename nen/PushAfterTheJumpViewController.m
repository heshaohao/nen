//
//  PushAfterTheJumpViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/13.
//  Copyright © 2017年 nen. All rights reserved.
// 极光推送

#import "PushAfterTheJumpViewController.h"

@interface PushAfterTheJumpViewController ()

@end

@implementation PushAfterTheJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UILabel *pushLabel = [[UILabel alloc] init];
    pushLabel.frame = CGRectMake(10,- 50,ScreenWidth -20,150);
    pushLabel.font = [UIFont systemFontOfSize:15];
    pushLabel.numberOfLines = 0;
    [self.view addSubview:pushLabel];
    
    pushLabel.text = self.alertStr;
    
    self.view.backgroundColor= [UIColor whiteColor];
    // 点击推送后去除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
