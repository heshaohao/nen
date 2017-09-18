//
//  DoConsultantController.m
//  nen
//
//  Created by nenios101 on 2017/3/14.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "DoConsultantController.h"
#import "ConsultantbottomView.h"
#import "TopicManagementController.h"
#import "AdviserOrderManagementController.h"
#import "ConsultantWordController.h"
#import "ConsultantIncomeController.h"
#import "ConsultantHomeController.h"
#import "ConsultantHomeSetController.h"
@interface DoConsultantController ()<SDCycleScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

// 图片轮播器
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property(nonatomic,strong) ConsultantbottomView *consultanBottomView;

@property(nonatomic,strong) UIView *middView;

@property(nonatomic,strong) UIButton *btn;
@end

@implementation DoConsultantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addScrollView];
    [self addheadView];
    [self addMiddleView];
    [self addContenView];
    [self addBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicNotice) name:@"consultanTopic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderNotice) name:@"consultanOrder" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordNotice) name:@"consultanWord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomeNotice) name:@"consultanincome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeNotice) name:@"consultanhome" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHomeNotice) name:@"consultanSetHome" object:nil];
    
}

#pragma mark 换题管理
- (void)topicNotice
{
    [self.navigationController pushViewController:[[TopicManagementController alloc] init] animated:YES];
}
#pragma mark 订单管理
- (void)orderNotice
{
    [self.navigationController pushViewController:[[AdviserOrderManagementController alloc] init] animated:YES];
}
#pragma mark 消息查看
- (void)wordNotice
{
    [self.navigationController pushViewController:[[ConsultantWordController alloc] init] animated:YES];
}

#pragma mark 顾问收入
- (void)incomeNotice
{
    [self.navigationController pushViewController:[[ConsultantIncomeController alloc] init] animated:YES];
}

#pragma mark 我的主页
- (void)homeNotice
{
    [self.navigationController pushViewController:[[ConsultantHomeController alloc] init] animated:YES];
}

#pragma mark 设置我的主页
- (void)setHomeNotice
{
    [self.navigationController pushViewController:[[ConsultantHomeSetController alloc] init] animated:YES];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)addScrollView
{
    // 创建底部scrollView
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight)];
    self.scrollView = scrView;
    [self.view addSubview:scrView];

}
// 图片轮播器
- (void)addheadView
{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:cycleScrollView];
    //延迟模拟网络加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *arrTemp = [NSMutableArray array];
        [arrTemp addObject:@"http://pic2.cxtuku.com/00/01/30/b5898506ee44.jpg"];
        [arrTemp addObject:@"http://img4.duitang.com/uploads/blog/201306/08/20130608100514_HfKmk.thumb.600_0.jpeg"];
        [arrTemp addObject:@"http://my.isself.com/upimg/user/30/20131117/13846939809150.jpg"];
        [arrTemp addObject:@"http://img2.duitang.com/uploads/item/201208/07/20120807210311_ztEEM.thumb.600_0.jpeg"];
        
        cycleScrollView.imageURLStringsGroup = arrTemp;
    });
    
    [self.scrollView addSubview:cycleScrollView];
    
}


- (void)addMiddleView
{
    _middView = [[UIView alloc] init];
    _middView.frame = CGRectMake(0,_cycleScrollView.sh_bottom,ScreenWidth,80);
    [self.scrollView addSubview:_middView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor greenColor];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 30;
    imageView.frame = CGRectMake(10, 10,60,60);
    imageView.image = [UIImage imageNamed:@"3"];
    [_middView addSubview:imageView];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.frame = CGRectMake(ScreenWidth *0.4,10,ScreenWidth * 0.5,20);
    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.text = @"新手入门视频 时长 : 4分12秒";
    [_middView addSubview:rightLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.textAlignment = NSTextAlignmentLeft;
    bottomLabel.frame = CGRectMake(imageView.sh_right + 10,rightLabel.sh_bottom + 5,ScreenWidth * 0.7,44);
    bottomLabel.numberOfLines = 3;
    bottomLabel.textColor = [UIColor grayColor];
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.text = @"您擅长的话题有哪些 ? 如何分享给大家 ? 如何设置顾问主页让您的话题更有吸引力?";

    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    bottomLine.frame = CGRectMake(0, bottomLabel.sh_bottom,ScreenWidth, 1);
    [_middView addSubview:bottomLine];
    [_middView addSubview:bottomLabel];
    
  }

// 选项区
- (void)addContenView
{
    _consultanBottomView = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantbottomView" owner:nil options:nil] lastObject];
    _consultanBottomView.frame = CGRectMake(0, _middView.sh_bottom, ScreenWidth, 180);
    [self.scrollView addSubview:_consultanBottomView];
}


- (void)addBtn
{
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(ScreenWidth * 0.1,_consultanBottomView.sh_bottom + 50,ScreenWidth * 0.8,30);
    [_btn setBackgroundColor:[UIColor orangeColor]];
    [_btn setTitle:@"发布话题" forState:UIControlStateNormal];
    _btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn.clipsToBounds = YES;
    _btn.layer.cornerRadius=5;
    [self.scrollView addSubview:_btn];
}




//代理跳转
- (void)selectItemAtIndex:(NSInteger)index {
   // NSLog(@"%ld",index);
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
