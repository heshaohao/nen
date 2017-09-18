//
//  ToEvaluateViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/13.
//  Copyright © 2017年 nen. All rights reserved.
//待评价


#import "MYToEvaluateViewController.h"
#import "MYToEvaluateCell.h"
#import "AllOrderOtherModel.h"
#import "AllOrderModel.h"
#import "MJRefresh.h"
#import "OrderToEvaluateViewController.h"
#import "ShoppingViewController.h"

@interface MYToEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray<AllOrderModel *> *allOrderArray;

@property(nonatomic,strong) NSMutableArray<AllOrderOtherModel *> *otherArray;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,copy) NSString *page;

@property(nonatomic,strong) UIAlertController *alertController;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *signal;

@end

@implementation MYToEvaluateViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableVc = [[UITableView alloc] init];
    self.tableView = tableVc;
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35 , 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    tableVc.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    tableVc.delegate = self;
    tableVc.tableFooterView = [[UIView alloc] init];
    tableVc.rowHeight = 160;
    tableVc.dataSource = self;
    [self.view addSubview:tableVc];
    
    [self pulldownNews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ToEvaluateRightBtnClick:) name:@"toEvaluateRightBtn"object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ToEvaluateLeftBtnClick:) name:@"toEvaluateLeftBtn"object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(poporederVc:) name:@"popOrderVc" object:nil];
    
}

- (void)poporederVc:(NSNotification *)notification
{
    NSString *orderId = notification.userInfo[@"orderId"];
    [self.allOrderArray enumerateObjectsUsingBlock:^(AllOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.Id isEqualToString:orderId])
        {
            [self.allOrderArray removeObjectAtIndex:idx];
            [self.tableView reloadData];
            [self pulldownNews];
        }
        
    }];
    
}


#pragma mark 订单右边按钮点击事件
- (void)ToEvaluateRightBtnClick:(NSNotification *)notification
{
    NSInteger state = [notification.userInfo[@"state"] integerValue];

    // 去评论
    NSString *goodsId = notification.userInfo[@"goodsId"];

    NSString *orderId = notification.userInfo[@"orderId"];
    NSString *shopId = notification.userInfo[@"shopId"];

    
    
    switch (state) {
        case 4:
            [self toViewEvaluationGoodsId:goodsId OrderId:orderId ShopId:shopId];
            break;
        default:
            break;
    }
    
    
}


#pragma mark 去评价
- (void)toViewEvaluationGoodsId:(NSString *)goodsId OrderId:(NSString *)orderId ShopId:(NSString *)shopId
{
    OrderToEvaluateViewController *orederVc = [[OrderToEvaluateViewController alloc] init];
    orederVc.goodsId = goodsId;
    orederVc.orderId = orderId;
    orederVc.shopId = shopId;
    
    [self.navigationController pushViewController:orederVc animated:YES];
    
}


#pragma mark 订单左边按钮点击事件
- (void)ToEvaluateLeftBtnClick:(NSNotification *)notification
{
    NSInteger state = [notification.userInfo[@"state"] integerValue];
    NSString *deleteId = notification.userInfo[@"deleteId"];
    
    
    if (state == 4)
    {
        // 标题
        self.alertController = [UIAlertController alertControllerWithTitle:@"是否删除订单!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        // 暂不
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [self.alertController addAction:cancelAction];
        [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        
        // 删除
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteGoodsOrderAndreminderTheDeliveryOrderid:deleteId Type:@"1"];
            
        }];
        
        [defaultAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        
        [self.alertController addAction:defaultAction];
        
        [self presentViewController:self.alertController animated:NO completion:nil];
        
    }
    
}

#pragma mark 删除订单 和提醒订单数据请求
- (void)deleteGoodsOrderAndreminderTheDeliveryOrderid:(NSString *)orderid Type:(NSString *)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    __weak typeof(self)weakself = self;
    
    // 删除订单
    NSString *splitCompleteStr =  [NSString stringEncryptedAddress:@"/order/deleteorder"];
    NSDictionary *dict = @{@"order_id":orderid,@"type":type};

//    if (type.length > 0)
//    {
//    }
//    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
      
        [weakself.allOrderArray enumerateObjectsUsingBlock:^(AllOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 判断数组中的订单ID 和 删除ID 是否相同
            if ([obj.Id isEqualToString:orderid]) {
                
                [weakself.allOrderArray removeObjectAtIndex:idx];
                [weakself.tableView reloadData];
                [JKAlert alertText:@"删除成功"];
                //[self pulldownNews];
            }
        }];
        
        if (weakself.allOrderArray.count == 0)
        {
            [weakself setEmptyView];
            weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}





#pragma mark 数组赖加载

- (NSMutableArray *)otherArray
{
    if (!_otherArray)
    {
        
        _otherArray = [NSMutableArray array];
    }
    return _otherArray;
}

- (NSMutableArray *)allOrderArray
{
    if (!_allOrderArray)
    {
        
        _allOrderArray= [NSMutableArray array];
    }
    return _allOrderArray;
}

- (void)pulldownNews
{
    
    // 点击进入立即刷新
    self.tableView.mj_header = [SHRefreshHeader  headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}
#pragma mark 下来刷新
- (void)loadNewData
{
    [self pullUpNews];
    
    self.page = @"1";
    __weak typeof(self) weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/list"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    NSDictionary *dict = @{@"order_state":@"4",@"page":self.page,@"pagesize":@"8"};
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSArray *dataArray = responseObject[@"list"];
        
        NSMutableArray * detailArray = [NSMutableArray array];
        
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dict = obj;
            
            NSArray *arr = dict[@"detail"];
            
            [detailArray addObjectsFromArray:arr];
            
        }];
        
        [AllOrderModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"Id" : @"id"
                     };
        }];

        
        
        
        self.otherArray =  [AllOrderOtherModel mj_objectArrayWithKeyValuesArray:detailArray];
        
        self.allOrderArray = [AllOrderModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (self.allOrderArray.count > 0)
        {
            [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [weakself.tableView.mj_header endRefreshing];
            
        }
        else
        { // 没有数据
            weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            weakself.signal = @"1";
            [weakself removeBackgroundView];
            if (weakself.allOrderArray.count > 0)
            {
                [weakself.allOrderArray removeAllObjects];
            }
            [weakself.tableView reloadData];
            [weakself setEmptyView];
            [weakself.tableView.mj_header endRefreshing];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        weakself.signal = @"0";
        [weakself removeBackgroundView];
        if (weakself.allOrderArray.count > 0)
        {
            [weakself.allOrderArray removeAllObjects];
        }
        [weakself.tableView reloadData];
        [weakself setEmptyView];
        [weakself.tableView.mj_header endRefreshing];
    }];
    
}

- (void)pullUpNews
{
    NSLog(@"%p",self.tableView);
    self.tableView.mj_footer = [SHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark 上啦刷新
- (void)loadMoreData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/list"];
    
    NSDictionary *dict= @{@"order_state":@"4",@"pagesize":@"8",@"page":self.page};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    __weak typeof(self) weakself = self;
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 记录第几页
        self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
        
        NSArray *dataArray = responseObject[@"list"];
        
        NSMutableArray * detailArray = [NSMutableArray array];
        
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dict = obj;
            
            NSArray *arr = dict[@"detail"];
            
            [detailArray addObjectsFromArray:arr];
            
        }];
        
        NSArray *array = [NSArray array];
        array = [AllOrderModel mj_objectArrayWithKeyValuesArray:dataArray];
        [self.allOrderArray addObjectsFromArray:array];
        
        
        NSArray *arr = [AllOrderOtherModel mj_objectArrayWithKeyValuesArray:detailArray];
        
        [self.otherArray addObjectsFromArray:arr];
        
        [tableView reloadData];
        [tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        weakself.signal = @"0";
        [weakself removeBackgroundView];
        if (weakself.allOrderArray.count > 0)
        {
            [weakself.allOrderArray removeAllObjects];
        }
        [weakself.tableView reloadData];
        [weakself setEmptyView];
        [weakself.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark 没有数据时加载
- (void)setEmptyView
{
    NSString * showTextStr;
    if ([self.signal isEqualToString:@"1"])
    {
        showTextStr = @"您还没有购买物品!";
    }else
    {
        showTextStr = @"您的网络信号不好!";
        
    }
    
    //默认视图背景
    _backgroundView = [[ThereIsNoDataBackgroundView  alloc]initWithThereIsNoDataBackgroundViewImageIcon:KNoDataBackgroundImage ImageX:ScreenWidth *0.25 ImageY:ScreenHeight *0.25 ImageW:ScreenWidth *0.5 imageH:ScreenWidth *0.5 ShowBottomText:showTextStr];
    [self.tableView addSubview:_backgroundView];
    
}

#pragma mark 移除backgroundView
- (void)removeBackgroundView
{
    [_backgroundView removeFromSuperview];
}

#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShoppingViewController *shopVc = [[ShoppingViewController alloc] init];
    shopVc.page = @"1";
    
    NSString *goodsId = [NSString stringWithFormat:@"%@",self.allOrderArray[indexPath.row].detail[0][@"goods_id"]];
    NSString *groupId = [NSString stringWithFormat:@"%@",self.allOrderArray[indexPath.row].group_id];
    
    if ([groupId isEqualToString:@"0"])
    {
        //  消费中奖
        shopVc.goodsIdItem = goodsId;
    }else
    {
        // 团购
        shopVc.groupGoodsId = goodsId;
    }
    
    [self.navigationController pushViewController:shopVc animated:YES];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allOrderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    
    AllOrderOtherModel * otherModel = self.otherArray[indexPath.row];
    
    AllOrderModel *model = self.allOrderArray[indexPath.row];
    
    MYToEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell = [[MYToEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    cell.otherModel =otherModel;
    
    return cell;
}

#pragma mark cell 分割线 两端封头
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


//cell 分割线 两端封头 实现这个两个方法 1
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



@end
