//
//  DrivingIncomeController.m
//  nen
//
//  Created by apple on 17/3/13.
//  Copyright © 2017年 nen. All rights reserved.
//驾校收入


#import "DrivingIncomeController.h"
#import "DrivingIncomeView.h"

@interface DrivingIncomeController ()

@property(nonatomic,strong) DrivingIncomeView *icomeView;

@end

@implementation DrivingIncomeController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _icomeView = [[[NSBundle mainBundle] loadNibNamed:@"DrivingIncomeView" owner:nil options:nil] lastObject];
    _icomeView.frame = CGRectMake(0, 64, ScreenWidth,ScreenHeight);
    
    [self.view addSubview:_icomeView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
