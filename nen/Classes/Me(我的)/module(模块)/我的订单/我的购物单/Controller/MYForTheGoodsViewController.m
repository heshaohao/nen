//
//  ForTheGoodsViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/13.
//  Copyright © 2017年 nen. All rights reserved.
//待收货

#import "MYForTheGoodsViewController.h"
#import "AllOrderModel.h"
#import "AllOrderOtherModel.h"
#import "MJRefresh.h"
#import "MYForTheViewCell.h"
#import "ShoppingViewController.h"
#import "CheckTheLogisticsViewController.h"
#import "OrderToEvaluateViewController.h"


@interface MYForTheGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray<AllOrderModel *> *allOrderArray;

@property(nonatomic,strong) NSMutableArray<AllOrderOtherModel *> *otherArray;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,copy) NSString *page;
@property(nonatomic,strong) UIAlertController *alertController;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *signal;

@end

@implementation MYForTheGoodsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableVc = [[UITableView alloc] init];
    self.tableView = tableVc;
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35 , 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    tableVc.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    tableVc.delegate = self;
    tableVc.rowHeight = 160;
    tableVc.dataSource = self;
    tableVc.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableVc];
   
    
    [self pulldownNews];
    
    //右边按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forTheRightBtnClick:) name:@"forTheRightBtn"object:nil];
    //左边按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forTheLeftBtnClick:) name:@"forTheLeftBtn"object:nil];
    
    
}

#pragma mark 订单右边按钮点击事件
- (void)forTheRightBtnClick:(NSNotification *)notification
{
    NSInteger state = [notification.userInfo[@"state"] integerValue];
    // 去评论
    // 去付款
    NSString *orderId = [NSString stringWithFormat:@"%@",notification.userInfo[@"orderId"]];
    
    
    switch (state) {
        case 3:
        {
            [self confirmOrederId:orderId];
        }
            break;
        default:
            break;
    }
}
#pragma mark 确认收货
- (void)confirmOrederId:(NSString *)orderId
{
    __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 提醒发货
    NSDictionary *dict = @{@"order_id":orderId};
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/qianshou"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
 
        
        NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        NSString *resultMessage = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultMessage"]];
        
        if ([coder isEqualToString:@"0"])
        {
            [self.allOrderArray enumerateObjectsUsingBlock:^(AllOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj.Id isEqualToString:orderId])
                {
                    [weakself.allOrderArray removeObjectAtIndex:idx];
                    [weakself.tableView reloadData];
                    [weakself pulldownNews];
                }
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定收货!" preferredStyle:1];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"马上去评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    OrderToEvaluateViewController *orderVc = [[OrderToEvaluateViewController alloc] init];
                    orderVc.orderId = orderId;
                    
                    [weakself.navigationController pushViewController:orderVc animated:YES];
                    
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:okAction];
                [alert addAction:cancel];
                [weakself presentViewController:alert animated:YES completion:nil];
            });
        }else
        {
            [JKAlert alertText:resultMessage];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark 订单左边按钮点击事件
- (void)forTheLeftBtnClick:(NSNotification *)notification
{
    NSString *orderId = [NSString stringWithFormat:@"%@",notification.userInfo[@"orderId"]];
   
    CheckTheLogisticsViewController *checkVc = [[CheckTheLogisticsViewController alloc] init];
    checkVc.Id = orderId;
    checkVc.goodsImage = notification.userInfo[@"goodsImage"];
    [self.navigationController pushViewController:checkVc animated:YES];
}


#pragma mark 删除订单 和提醒订单数据请求
- (void)deleteGoodsOrderAndreminderTheDeliveryOrderid:(NSString *)orderid Type:(NSString *)type
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dict;
    NSString *splitCompleteStr;
    
    if (type.length > 0)
    {
        // 删除订单
        splitCompleteStr = [NSString stringEncryptedAddress:@"/order/deleteorder"];
        dict = @{@"order_id":orderid,@"type":type};
    }
    __block typeof(self)bself = self;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
    
     //   NSLog(@"%@",responseObject);
        
        for (int index = 0;index< bself.allOrderArray.count;index ++)
        {
            
            AllOrderModel *obj = self.allOrderArray[index];
            
            // 判断数组中的订单ID 和 删除ID 是否相同
            if ([orderid isEqualToString:obj.Id])
            {
                
                [bself.allOrderArray removeObjectAtIndex:index];
                
            }
            
        }
        NSString *success = responseObject[@"result"][@"resultMessage"];
        
        if ([success isEqualToString:@"SUCCESS"])
        {
            if([type isEqualToString:@"1"])
            {
                [JKAlert alertText:@"删除成功"];
                [self pulldownNews];
            }
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
     self.page = @"1";
    
    [self pullUpNews];
    
    __weak typeof(self) weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/list"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    NSDictionary *dict = @{@"order_state":@"3",@"page":self.page,@"pagesize":@"8"};
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

        
        self.otherArray =  [AllOrderOtherModel mj_objectArrayWithKeyValuesArray:detailArray];
        
        self.allOrderArray = [AllOrderModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (self.allOrderArray.count > 0)
        {
            weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            weakself.tableView.tableFooterView = [[UIView alloc] init];
            [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            
        }
        else
        { // 没有数据
            weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            weakself.signal = @"1";
            [weakself removeBackgroundView];
            if (self.allOrderArray.count >0)
            {
                [self.allOrderArray removeAllObjects];
            }
            [weakself.tableView reloadData];
            [weakself setEmptyView];
            [weakself.tableView.mj_header endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.signal = @"0";
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    
}

- (void)pullUpNews
{
    self.tableView.mj_footer = [SHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark 上啦刷新
- (void)loadMoreData
{
    
    __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%ld",[self.page integerValue] + 1];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/list"];
    
    NSDictionary *dict= @{@"order_state":@"3",@"pagesize":@"8",@"page":self.page};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];

    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 记录第几页
        weakself.page = [NSString stringWithFormat:@"%ld",[weakself.page integerValue] + 1];
        
        NSArray *dataArray = responseObject[@"list"];
        
        NSMutableArray * detailArray = [NSMutableArray array];
        
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dict = obj;
            
            NSArray *arr = dict[@"detail"];
            
            [detailArray addObjectsFromArray:arr];
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSArray *array = [NSArray array];
            array = [AllOrderModel mj_objectArrayWithKeyValuesArray:dataArray];
            [weakself.allOrderArray addObjectsFromArray:array];
            
            NSArray *arr = [AllOrderOtherModel mj_objectArrayWithKeyValuesArray:detailArray];
            
            [weakself.otherArray addObjectsFromArray:arr];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_footer endRefreshing];
            
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
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
    
    MYForTheViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell = [[MYForTheViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
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


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
