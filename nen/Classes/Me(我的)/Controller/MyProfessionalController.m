//
//  MyProfessionalController.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyProfessionalController.h"
#import "ProfessView.h"
#import "DrivingSchoolController.h"
@interface MyProfessionalController ()


@end

@implementation MyProfessionalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drivingBtn) name:@"driving" object:nil];
    
    [self addPRofessinalView];
}

#pragma mark 驾校通知
-(void)drivingBtn
{
    [self.navigationController pushViewController:[DrivingSchoolController new] animated:YES];
}


- (void)addPRofessinalView
{
    ProfessView *view = [[[NSBundle mainBundle] loadNibNamed:@"ProfessView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 64, ScreenWidth,180);
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, view.sh_bottom + 20,ScreenWidth *0.9 , 50);
    label.textColor = [UIColor orangeColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"您是否想在工作之余做更多有意义的事情,赚更多的钱呢？还在犹豫什么,赶紧加入我们吧 !";
    [self.view addSubview:label];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}



@end
