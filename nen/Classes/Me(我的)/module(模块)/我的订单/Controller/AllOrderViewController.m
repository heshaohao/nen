//
//  AllOrderViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/13.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "AllOrderViewController.h"
#import "MyShoppView.h"
#import "DrivingOrderView.h"
#import "PointMenuView.h"
#import "ReservationListView.h"
#import "MYShoppingListViewController.h"
#import "DrivingOrderasViewController.h"
#import "ReservationsViewController.h"
#import "PointMenusViewController.h"
@interface AllOrderViewController ()

@property(nonatomic,strong)MyShoppView *shoppView;

@property(nonatomic,strong)DrivingOrderView *drivingView;

@property(nonatomic,strong) PointMenuView *pointView;
// 数量
@property(nonatomic,strong) NSArray *stateArray;

@end


@implementation AllOrderViewController

- (NSArray *)stateArray
{
    if (_stateArray)
    {
        _stateArray = [NSArray array];
    }
    return _stateArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/general"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];

    [manager GET:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.stateArray = responseObject[@"list"];
        
        [self addShoppingView];
        [self addDrivingView];
        [self addPointMenuView];
        [self addReservationListView];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
       // NSLog(@"%@",error);
        
    }];
  

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAllOrderVc:) name:@"allOderVc"object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDrivingVc:) name:@"drivingVc"object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMakeVc:) name:@"makeVc"object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPointVc:) name:@"ponitVc"object:nil];
    
}


#pragma mark 根据点击不同的按钮跳转点餐对应的控制器
- (void)pushPointVc:(NSNotification *)notification
{
    NSString *pageStr = notification.userInfo[@"page"];
    PointMenusViewController *pointVc = [[PointMenusViewController alloc] init];
    pointVc.page = pageStr ;
    
    [self.navigationController pushViewController:pointVc animated:YES];
}


#pragma mark 根据点击不同的按钮跳转预约对应的控制器
- (void)pushMakeVc:(NSNotification *)notification
{
    NSString *pageStr = notification.userInfo[@"page"];
    
    ReservationsViewController *reservationsVc = [[ReservationsViewController alloc] init];
    reservationsVc.page = pageStr ;
    
    [self.navigationController pushViewController:reservationsVc animated:YES];
    
}



#pragma mark 根据点击不同的按钮跳转购物单对应的控制器
- (void)pushAllOrderVc:(NSNotification *)notification
{
    NSString *pageStr = notification.userInfo[@"page"];
    
    MYShoppingListViewController *shoppingListVc = [[MYShoppingListViewController alloc] init];
    shoppingListVc.page = pageStr ;
    
    [self.navigationController pushViewController:shoppingListVc animated:YES];
}

#pragma mark 根据点击不同的按钮跳转驾校订单对应的控制器
- (void)pushDrivingVc:(NSNotification *)notification
{
    NSString *pageStr = notification.userInfo[@"page"];
    
    DrivingOrderasViewController *drivingListVc = [[DrivingOrderasViewController alloc] init];
    drivingListVc.page = pageStr ;
    
    [self.navigationController pushViewController:drivingListVc animated:YES];
    
}

#pragma mark 我的购物单

- (void)addShoppingView
{
    _shoppView = [[[NSBundle mainBundle] loadNibNamed:@"MyShoppView" owner:nil options:nil] lastObject];
    _shoppView.staeCountArray = self.stateArray;
    _shoppView.sh_width = ScreenWidth;
    _shoppView.sh_height = 120;
    _shoppView.sh_x = 0;
    _shoppView.sh_y = 64;
    [self.view addSubview:_shoppView];

  
}
#pragma mark 我的驾校单
- (void)addDrivingView
{
    _drivingView = [[[NSBundle mainBundle] loadNibNamed:@"DrivingOrderView" owner:nil options:nil] lastObject];
    
    _drivingView.sh_width = ScreenWidth;
    _drivingView.sh_height = 120;
    _drivingView.sh_x = 0;
    _drivingView.sh_y = _shoppView.sh_bottom  + 5;
    [self.view addSubview:_drivingView];
}

#pragma mark 我的点餐单
- (void)addPointMenuView
{
    _pointView = [[[NSBundle mainBundle] loadNibNamed:@"PointMenuView" owner:nil options:nil] lastObject];
    _pointView.sh_width = ScreenWidth;
    _pointView.sh_height = 120;
    _pointView.sh_x = 0;
    _pointView.sh_y = _drivingView.sh_bottom;
    [self.view addSubview:_pointView];
}

#pragma mark 我的预约单
- (void)addReservationListView
{
    ReservationListView *reservationView   = [[[NSBundle mainBundle] loadNibNamed:@"ReservationListView" owner:nil options:nil] lastObject];
    reservationView.sh_width = ScreenWidth;
    reservationView.sh_height = 120;
    reservationView.sh_x = 0;
    reservationView.sh_y = _pointView.sh_bottom + 5;
    [self.view addSubview:reservationView];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
