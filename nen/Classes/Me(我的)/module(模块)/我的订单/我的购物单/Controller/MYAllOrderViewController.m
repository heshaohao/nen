 //
//  AllOrderViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/13.
//  Copyright © 2017年 nen. All rights reserved.
//全部订单


#import "MYAllOrderViewController.h"
#import "AllOrderCell.h"
#import "AllOrderModel.h"
#import "AllOrderOtherModel.h"
#import "MJRefresh.h"
#import "CheckTheLogisticsViewController.h"
#import "OrderToEvaluateViewController.h"
#import "PaymentCenterViewController.h"
#import "ShoppingViewController.h"


@interface MYAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray<AllOrderModel *> *allOrderArray;

@property(nonatomic,strong) NSMutableArray<AllOrderOtherModel *> *otherArray;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIAlertController *alertController;

@property(nonatomic,copy) NSString *page;

@property(nonatomic,copy) NSString *rigthGoodsId;

@property(nonatomic,copy) NSString *leftGoodsId;

@property(nonatomic,assign) NSInteger index;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *signal;


@end

@implementation MYAllOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableVc = [[UITableView alloc] init];
    self.tableView = tableVc;
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35 , 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    tableVc.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    tableVc.delegate = self;
    tableVc.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableVc.rowHeight = 160;
    tableVc.dataSource = self;
    [self.view addSubview:tableVc];
    
    [self pulldownNews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightBtnClick:) name:@"rightBtn"object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftBtnClick:) name:@"leftBtn"object:nil];
    
}

#pragma mark 订单右边按钮点击事件
- (void)rightBtnClick:(NSNotification *)notification
{
    NSInteger state = [notification.userInfo[@"state"] integerValue];
    // 去评论
    NSString *goodsId = notification.userInfo[@"goodsId"];
    // 去付款
    NSString *goodsId1 = notification.userInfo[@"goodsId1"];
    NSString *goodsPrice = notification.userInfo[@"goodsPrice"];
    
    NSString *orderId = notification.userInfo[@"orderId"];
    NSString *shopId = notification.userInfo[@"shopId"];
    
    
    
    
   // NSLog(@"%ld",(long)state);
    
    switch (state) {
        case 1:
            [self paymentGoodsId:goodsId1 Price:goodsPrice];
            break;
        case 2:
            [self deleteGoodsOrderAndreminderTheDeliveryOrderid:orderId Type:nil];
            break;
        case 3:
            break;
        case 4:
            [self toViewEvaluationGoodsId:goodsId OrderId:orderId ShopId:shopId];

            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
            break;
        case 8:
            break;
        case 9:
            break;

            
        default:
            break;
    }
    
    
}


#pragma mark 订单左边按钮点击事件
- (void)leftBtnClick:(NSNotification *)notification
{
    NSInteger state = [notification.userInfo[@"state"] integerValue];
    self.leftGoodsId = notification.userInfo[@"goodsId"];
    NSString *deleteId = notification.userInfo[@"orderId"];
 
    __weak __typeof(self)weakSelf = self;
    
  //  NSLog(@"%@",self.leftGoodsId);
   
    if (state == 2 || state == 3)
    {
         [self toViewLogisticsGoodsId:notification.userInfo[@"orderId"]GoodsImage:notification.userInfo[@"goodsImage"]];
    }
    
    if (state == 1 || state == 4 || state  == 5 || state  == 6 || state  == 7 || state  == 8)
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
            
            [weakSelf deleteGoodsOrderAndreminderTheDeliveryOrderid:deleteId Type:@"1"];
            
        }];
        
        [defaultAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        
        [self.alertController addAction:defaultAction];
        
        [self presentViewController:self.alertController animated:NO completion:nil];
        
    }
    
}

#pragma mark 查看物流
- (void)toViewLogisticsGoodsId:(NSString *)GoodsId GoodsImage:(NSString *)goodsImage
{
    
    CheckTheLogisticsViewController *checkVc = [[CheckTheLogisticsViewController alloc] init];
    checkVc.Id = GoodsId;
    checkVc.goodsImage = goodsImage;
    [self.navigationController pushViewController:checkVc animated:YES];
    
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



#pragma mark 去付款
- (void)paymentGoodsId:(NSString *)GoodsId Price:(NSString *)price
{
    PaymentCenterViewController *paymentVc = [[PaymentCenterViewController alloc] init];
    paymentVc.goodsId = GoodsId;
    paymentVc.goods_num = @"1";
    paymentVc.singleTotalPrice = [price doubleValue];
    [self.navigationController pushViewController:paymentVc animated:YES];
    
}


#pragma mark 删除订单 和提醒订单数据请求
- (void)deleteGoodsOrderAndreminderTheDeliveryOrderid:(NSString *)orderid Type:(NSString *)type
{
    __weak __typeof(self)weakSelf = self;
  
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict;
    NSString *splitCompleteStr;
    
    if (type.length > 0)
    {
        // 删除订单
        splitCompleteStr = [NSString stringEncryptedAddress:@"/order/deleteorder"];
        dict = @{@"order_id":orderid,@"type":type};
    }else
    {
        // 提醒发货
        splitCompleteStr = [NSString stringEncryptedAddress:@"/order/rushorder"];
        dict = @{@"order_id":orderid};
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    

    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       

        if (type.length != 0)
        {
            for (int index = 0;index<weakSelf.allOrderArray.count;index ++)
            {
                
                AllOrderModel *obj = weakSelf.allOrderArray[index];
                
                // 判断数组中的订单ID 和 删除ID 是否相同
                if ([orderid isEqualToString:obj.Id])
                {
                    
                    weakSelf.index = index;
                    [weakSelf.allOrderArray removeObjectAtIndex:weakSelf.index];
                }
            }
            
        }
            NSString *success = responseObject[@"result"][@"resultMessage"];
        
           NSString *resultCode  = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
                
                if ([resultCode isEqualToString:@"0"])
                {
                    if (type.length == 0)
                    {
                        [JKAlert alertText:@"提醒发货成功"];
                        [weakSelf.tableView reloadData];
                       // [weakSelf pulldownNews];
                        
                    }else if([type isEqualToString:@"1"])
                    {
                      [JKAlert alertText:@"删除成功"];
                      [weakSelf.tableView reloadData];
                       // [weakSelf pulldownNews];
                        
                    }
                    
                }else
                {
                    [JKAlert alertText:success];
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
    
    self.page = @"1";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/list"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSLog(@"%@",responseObject);
     
        
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

        
        weakself.allOrderArray = [AllOrderModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        weakself.otherArray =  [AllOrderOtherModel mj_objectArrayWithKeyValuesArray:detailArray];
        
        
        
        if (weakself.allOrderArray.count > 0)
        {
            [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            
        }
       else
        { // 没有数据
            self.signal = @"1";
            if (weakself.allOrderArray.count > 0)
            {
                [weakself.allOrderArray removeAllObjects];
                
            }
            [weakself.tableView reloadData];
            [weakself removeBackgroundView];
            [weakself setEmptyView];
            [weakself.tableView.mj_header endRefreshing];
        
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        self.signal = @"0";
        if (weakself.allOrderArray.count > 0)
        {
            [weakself.allOrderArray removeAllObjects];
            
        }
        [weakself.tableView reloadData];
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/list"];
    
    NSDictionary *dict= @{@"page":self.page};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak typeof(self)weakself = self;
    __weak UITableView *tableView = self.tableView;
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
        
        self.signal = @"0";
        if (weakself.allOrderArray.count > 0)
        {
            [weakself.allOrderArray removeAllObjects];
            
        }
        [weakself.tableView reloadData];
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        [weakself.tableView.mj_footer endRefreshing];
        
    }];
}

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


#pragma mark tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.allOrderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    
    AllOrderOtherModel * otherModel = self.otherArray[indexPath.row];
    
    AllOrderModel *model = self.allOrderArray[indexPath.row];
    
    AllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
   if (!cell)
    {
        cell = [[AllOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = model;
    
    cell.otherModel =otherModel;
    
    return cell;
}

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
