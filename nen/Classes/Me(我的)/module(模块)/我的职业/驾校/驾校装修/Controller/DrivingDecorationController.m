//
//  DrivingDecorationController.m
//  nen
//
//  Created by apple on 17/3/13.
//  Copyright © 2017年 nen. All rights reserved.
//驾校装修

#import "DrivingDecorationController.h"
#import "DrivingDecorationView.h"
@interface DrivingDecorationController ()

@property(nonatomic,strong) DrivingDecorationView *drivingView;

@end

@implementation DrivingDecorationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _drivingView = [[[NSBundle mainBundle] loadNibNamed:@"DrivingDecorationView" owner:nil options:nil] lastObject];
    _drivingView.frame = CGRectMake(0, 64,ScreenWidth, ScreenHeight);
    
    [self.view addSubview:_drivingView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
