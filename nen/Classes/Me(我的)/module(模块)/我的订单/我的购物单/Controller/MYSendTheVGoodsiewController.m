//
//  SendTheVGoodsiewController.m
//  nen
//
//  Created by nenios101 on 2017/4/13.
//  Copyright © 2017年 nen. All rights reserved.
//待发货

#import "MYSendTheVGoodsiewController.h"
#import "MYSendTheViewCell.h"
#import "AllOrderModel.h"
#import "AllOrderOtherModel.h"
#import "MJRefresh.h"
#import "CheckTheLogisticsViewController.h"
#import "ShoppingViewController.h"


@interface MYSendTheVGoodsiewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray<AllOrderModel *> *allOrderArray;

@property(nonatomic,strong) NSMutableArray<AllOrderOtherModel *> *otherArray;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,copy) NSString *page;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *signal;

@end

@implementation MYSendTheVGoodsiewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableVc = [[UITableView alloc] init];
    self.tableView = tableVc;
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35 , 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    tableVc.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    tableVc.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableVc.delegate = self;
    tableVc.rowHeight = 160;
    tableVc.dataSource = self;
    [self.view addSubview:tableVc];
    
    
    [self pulldownNews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendTheRightBtnClick:) name:@"SendTheRightBtn"object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendTheLeftBtnClick:) name:@"SendTheLeftBtn"object:nil];
}

#pragma mark 订单左边按钮点击事件
- (void)SendTheLeftBtnClick:(NSNotification *)notification
{
    NSInteger state = [notification.userInfo[@"state"] integerValue];
   
    if (state == 2)
    {
        [self toViewLogisticsGoodsId:notification.userInfo[@"orderId"] GoodsImage:notification.userInfo[@"goodsImage"]];
    }
    
    
}

#pragma mark 订单右边按钮点击事件
- (void)SendTheRightBtnClick:(NSNotification *)notification
{
    NSInteger state = [notification.userInfo[@"state"] integerValue];
    // 去评论
    
    NSString *orderId = notification.userInfo[@"orderId"];
    
    switch (state) {
        case 2:
            [self deleteGoodsOrderAndreminderTheDeliveryOrderid:orderId];
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark 查看物流
- (void)toViewLogisticsGoodsId:(NSString *)goodsId GoodsImage:(NSString *)goodsImage
{
    
    CheckTheLogisticsViewController *checkVc = [[CheckTheLogisticsViewController alloc] init];
    checkVc.goodsImage = goodsImage;
    checkVc.Id = goodsId;
    
    [self.navigationController pushViewController:checkVc animated:YES];
}


#pragma mark 提醒发货
- (void)deleteGoodsOrderAndreminderTheDeliveryOrderid:(NSString *)orderId
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 提醒发货
    NSDictionary *dict = @{@"order_id":orderId};
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/rushorder"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSString *success = responseObject[@"result"][@"resultMessage"];
        
        if ([success isEqualToString:@"SUCCESS"])
        {
            [JKAlert alertText:@"提醒发货成功"];
            [self pulldownNews];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}


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
    __weak typeof(self) weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    self.page = @"1";
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/list"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    NSDictionary *dict = @{@"order_state":@"2",@"page":self.page,@"pagesize":@"8"};
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
     //   NSLog(@"%@",responseObject);
        
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

        
        weakself.otherArray =  [AllOrderOtherModel mj_objectArrayWithKeyValuesArray:detailArray];
        
        weakself.allOrderArray = [AllOrderModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (weakself.allOrderArray.count > 0)
        {
            [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            
        }
        else
        {   weakself.signal = @"1";
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
    
   NSDictionary *dict= @{@"order_state":@"2",@"pagesize":@"8",@"page":self.page};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    __weak typeof(self)weakself = self;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allOrderArray.count;
}



#pragma mark tabelViewDelegate

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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    
    AllOrderOtherModel * otherModel = self.otherArray[indexPath.row];
    
    AllOrderModel *model = self.allOrderArray[indexPath.row];
    
    MYSendTheViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell = [[MYSendTheViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    cell.otherModel =otherModel;
    
    return cell;
}

@end
