//
//  NetCashViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/25.
//  Copyright © 2017年 nen. All rights reserved.
//网币

#import "NetCashViewController.h"

@interface NetCashViewController ()

@end

@implementation NetCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *sumLabel = [[UILabel alloc] init];
    sumLabel.frame = CGRectMake(30,100,50,30);
    sumLabel.text = @"总额";
    sumLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:sumLabel];
    
    UILabel *remainingLabel = [[UILabel alloc] init];
    remainingLabel.frame = CGRectMake(ScreenWidth *0.8,sumLabel.sh_y,50,30);
    remainingLabel.text = @"余额";
    remainingLabel.textAlignment = NSTextAlignmentRight;
    remainingLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:remainingLabel];
    
    UILabel *netCashLabel1 = [[UILabel alloc] init];
    netCashLabel1.frame = CGRectMake(sumLabel.sh_x,sumLabel.sh_bottom + 30,50,30);
    netCashLabel1.text = @"0";
    [self.view addSubview:netCashLabel1];
    
    UILabel *netCashLabel2 = [[UILabel alloc] init];
    netCashLabel2.frame = CGRectMake(ScreenWidth *0.8,sumLabel.sh_bottom + 30,50,30);
    netCashLabel2.textAlignment = NSTextAlignmentRight;
    netCashLabel2.text = @"0";
    [self.view addSubview:netCashLabel2];
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0,netCashLabel2.sh_bottom + 20,ScreenWidth,1);
    topView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topView];
    
    UILabel *centerlabel1 = [[UILabel alloc] init];
    centerlabel1.frame = CGRectMake(sumLabel.sh_x,topView.sh_bottom +5 ,100,20);
    centerlabel1.textColor = [UIColor lightGrayColor];
    centerlabel1.font = [UIFont systemFontOfSize:15];
    centerlabel1.text = @"本月可用余额";
    [self.view addSubview:centerlabel1];
    
    UILabel *centerlabel2 = [[UILabel alloc] init];
    centerlabel2.frame = CGRectMake(ScreenWidth *0.8,topView.sh_bottom + 10 ,50,15);
    centerlabel2.textAlignment = NSTextAlignmentRight;
    centerlabel2.textColor = [UIColor lightGrayColor];
    centerlabel2.font = [UIFont systemFontOfSize:14];
    centerlabel2.text = @"0";
    [self.view addSubview:centerlabel2];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0,centerlabel2.sh_bottom + 5,ScreenWidth,1);
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth *0.1,ScreenHeight *0.8,ScreenWidth *0.8,40);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"立即使用" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    [self.view addSubview:btn];

    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
