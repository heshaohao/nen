//
//  DrivingTheDetailsController.m
//  nen
//
//  Created by nenios101 on 2017/3/8.
//  Copyright © 2017年 nen. All rights reserved.
//驾校订单


#import "DrivingTheDetailsController.h"

#import "DrivingTheDetailsView.h"
#import "DrivingBottomView.h"
#import "CourseViewController.h"

@interface DrivingTheDetailsController ()<SDCycleScrollViewDelegate>
// 图片轮播器
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) DrivingTheDetailsView *drivingTheView;

@property(nonatomic,strong) DrivingBottomView *bottomView;

@end

@implementation DrivingTheDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addScrollview];
    [self addConten];
    [self addBottomView];
    [self addhead];
    self.view.backgroundColor = [UIColor blueColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appointmentBtn) name:@"appointment" object:nil];
    
    
}


- (void)appointmentBtn
{
    [self.navigationController pushViewController:[[CourseViewController alloc] init] animated:YES];
}

-(void)addScrollview
{
    // 创建底部scrollView
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight - 50)];
    scrView.backgroundColor = [UIColor whiteColor];
    scrView.bounces = NO;
    self.scrollView = scrView;
    [self.view addSubview:scrView];

}

- (void)addhead
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

- (void)addConten
{
    _drivingTheView = [[[NSBundle mainBundle] loadNibNamed:@"DrivingTheDetailsView" owner:nil options:nil]lastObject];
    
    _drivingTheView.frame = CGRectMake(0,200 ,ScreenWidth,600);
    
    [self.scrollView addSubview:_drivingTheView];
    
    self.scrollView.contentSize =CGSizeMake(0, _drivingTheView.sh_bottom);
    
}

- (void)addBottomView
{
    _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"DrivingBottomView" owner:nil options:nil]lastObject];
    _bottomView.frame = CGRectMake(0,ScreenHeight - 50 ,ScreenWidth,50);
    
    [self.view addSubview:_bottomView];

}




- (void)selectItemAtIndex: (NSInteger)index
{
    
}


@end
