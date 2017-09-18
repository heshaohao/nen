//
//  DrivingSchoolController.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
// 驾校管理

#import "DrivingSchoolController.h"
#import "DrivingView.h"
#import "DrivingHeadView.h"
#import "CurriculumController.h"
#import "DrivingIncomeController.h"
#import "DrivingDecorationController.h"
#import "SyllabusIssueController.h"
#import "DrivingOrderManageController.h"
#import "DrivingWordController.h"

@interface DrivingSchoolController ()

@property(nonatomic,strong) DrivingHeadView *headView;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) DrivingView *drivingView;

@property(nonatomic,strong) UIButton *btn;

@end

@implementation DrivingSchoolController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addScrollview];
    
    [self addHeadView];
    
    [self addContenView];
    
    [self addBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icomeBtn) name:@"icome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drivingBtn) name:@"dri" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseBtn) name:@"course" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderBtn) name:@"order" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordrBtn) name:@"word" object:nil];
    
}

#pragma mark 驾校收入通知
- (void)icomeBtn
{
    [self.navigationController pushViewController:[[DrivingIncomeController alloc] init] animated:YES];
}

#pragma mark 驾校维修通知
- (void)drivingBtn
{
    [self.navigationController pushViewController:[[DrivingDecorationController alloc] init] animated:YES];
}

#pragma mark 驾校课程管理
- (void)courseBtn
{
    [self.navigationController pushViewController:[[SyllabusIssueController alloc] init] animated:YES];
}
#pragma mark 驾校订单管理
- (void)orderBtn
{
    [self.navigationController pushViewController:[[DrivingOrderManageController alloc] init] animated:YES];
}

#pragma mark 驾校查看消息
- (void)wordrBtn
{
    [self.navigationController pushViewController:[[DrivingWordController alloc] init] animated:YES];
}


- (void)addScrollview
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    self.scrollView = scrVc;
    scrVc.backgroundColor = [UIColor greenColor];
    scrVc.frame = self.view.frame;
    [self.view addSubview:scrVc];
}



- (void)addHeadView
{
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"DrivingHeadView" owner:nil options:nil] lastObject];
    _headView.frame = CGRectMake(0, 0, ScreenWidth, 230);
    [self.scrollView addSubview:_headView];
}

- (void)addContenView
{
    
    _drivingView = [[[NSBundle mainBundle] loadNibNamed:@"DrivingView" owner:nil options:nil] lastObject];
    _drivingView.frame = CGRectMake(0, _headView.sh_bottom + 10, ScreenWidth, 180);
    [self.scrollView addSubview:_drivingView];
}

- (void)addBtn
{
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(ScreenWidth * 0.1,_drivingView.sh_bottom + 50,ScreenWidth * 0.8,30);
    [_btn setBackgroundColor:[UIColor orangeColor]];
    [_btn setTitle:@"发布话题" forState:UIControlStateNormal];
    _btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btn addTarget:self action:@selector(pushBtn) forControlEvents:UIControlEventTouchUpInside];
    _btn.clipsToBounds = YES;
    _btn.layer.cornerRadius=5;
    [self.scrollView addSubview:_btn];
}


- (void)pushBtn
{
    [self.navigationController pushViewController:[CurriculumController new] animated:YES];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
