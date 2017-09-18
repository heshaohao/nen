//
//  ProcessedViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/9.
//  Copyright © 2017年 nen. All rights reserved.
//待处理

#import "ProcessedViewController.h"
#import "MerchantsOrdersModel.h"
#import "ShoppingForDetailsModel.h"
#import "MerchantsToBeProcessedCell.h"
#import "SendTheCourierViewController.h"
@interface ProcessedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy) NSString *page;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray <MerchantsOrdersModel *> *merchantsArray;
@property(nonatomic,strong) NSMutableArray <ShoppingForDetailsModel *> *shoppingForDetailsArray;

@property(nonatomic,strong) NSArray *suppliersArray;
@property(nonatomic,strong) UITableView *supplierstabelView;

@property(nonatomic,strong) UIButton *hudBtn;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *signal;

@end

@implementation ProcessedViewController

- (NSArray *)suppliersArray
{
    if (!_suppliersArray)
    {
        _suppliersArray = [NSArray array];
    }
    return _suppliersArray;
}

- (NSMutableArray *)merchantsArray
{
    if (!_merchantsArray) {
        _merchantsArray = [NSMutableArray array];
    }
    
    return _merchantsArray;
}

- (NSMutableArray *)shoppingForDetailsArray
{
    if (!_shoppingForDetailsArray) {
        _shoppingForDetailsArray = [NSMutableArray array];
    }
    
    return _shoppingForDetailsArray;
}

// 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView= [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,99,ScreenWidth,ScreenHeight - 99);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 270;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self pulldownNews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clcikCallSuppliersBtn) name:@"callSuppliers" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popSendGoodsVc:) name:@"sendVcPop" object:nil];
    
}



#pragma mark 从发货控制器删除已发货的订单
- (void)popSendGoodsVc:(NSNotification *)notification
{
    __weak typeof(self) weakself = self;
    NSString *orderId = notification.userInfo[@"orderId"];
    
    if (orderId.length !=0)
    {
        
        [self.merchantsArray enumerateObjectsUsingBlock:^(MerchantsOrdersModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([orderId isEqualToString:obj.id])
            {
                [weakself.merchantsArray removeObjectAtIndex:idx];
                [weakself.tableView reloadData];
                [weakself pulldownNews];
            }
        }];
        
    }
    
    
}


#pragma mark 点击联系供应商按钮
- (void)clcikCallSuppliersBtn
{
   
    _hudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hudBtn.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    [_hudBtn setBackgroundColor:[UIColor blackColor]];
    [_hudBtn setAlpha:0.6];
    [_hudBtn addTarget:self action:@selector(deleteHudBtn) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    [wind addSubview:_hudBtn];
    
    self.suppliersArray = @[@"在线咨询",@"拨打电话",@"取消"];
    _supplierstabelView = [[UITableView alloc] init];
    _supplierstabelView.frame = CGRectMake(10,ScreenHeight*0.5 - 75 ,ScreenWidth - 20,150);
    _supplierstabelView.delegate = self;
    _supplierstabelView.rowHeight = 50;
    _supplierstabelView.dataSource= self;
    _supplierstabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [wind addSubview:_supplierstabelView];
    
    
    
}


#pragma mark 移除遮挡View

- (void)deleteHudBtn
{
    [_hudBtn removeFromSuperview];
    [_supplierstabelView removeFromSuperview];
    self.suppliersArray =nil;
    
}

#pragma mark 下拉刷新
- (void)pulldownNews
{
    
    // 点击进入立即刷新
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}
#pragma mark 下来刷新
- (void)loadNewData
{
 
    self.page = @"1";
    [self pullUpNews];
    __weak UITableView *tableView = self.tableView;
    __weak typeof(self) weakself = self;
    
    [MerchantsOrdersModel merchantsOrdersModelState:@"1" PageSize:@"8" Page:self.page success:^(NSMutableArray<MerchantsOrdersModel *> *merchantsOrdersArray) {
        
        weakself.merchantsArray = merchantsOrdersArray;
        
        for (int i = 0;i<weakself.merchantsArray.count;i++)
        {
            NSArray <ShoppingForDetailsModel*> *array = [NSArray array];
            array  =  [ShoppingForDetailsModel mj_objectArrayWithKeyValuesArray:weakself.merchantsArray[i].detail];
            [weakself.shoppingForDetailsArray addObjectsFromArray:array];
        }
        
        if (self.merchantsArray.count >0)
        {
            [weakself removeBackgroundView];
            [tableView reloadData];
            [tableView.mj_header endRefreshing];
            
        }else
        {
            weakself.signal = @"1";
            if (self.merchantsArray.count > 0)
            {
                [weakself.merchantsArray removeAllObjects];
                
            }
            [weakself.tableView reloadData];
            [weakself removeBackgroundView];
            [weakself setEmptyView];
            [weakself.tableView.mj_header endRefreshing];
        }
        
    } error:^{
        weakself.signal = @"0";
        if (self.merchantsArray.count > 0)
        {
            [weakself.merchantsArray removeAllObjects];
            
        }
        [weakself.tableView reloadData];
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        [weakself.tableView.mj_header endRefreshing];
    }];

}


#pragma mark 没有数据时显示
- (void)setEmptyView
{
    NSString * showTextStr;
    if ([self.signal isEqualToString:@"1"])
    {
        showTextStr = @"您还没有出售物品!";
    }else
    {
        showTextStr = @"您的网络信号不好!";
        
    }
    
    
    //默认视图背景
    _backgroundView = [[ThereIsNoDataBackgroundView alloc] initWithThereIsNoDataBackgroundViewImageIcon:KNoDataBackgroundImage ImageX:ScreenWidth*0.25 ImageY:ScreenHeight *0.25 ImageW:ScreenWidth *0.5 imageH:ScreenWidth *0.5 ShowBottomText:showTextStr];
    [self.tableView addSubview:_backgroundView];
    
}

#pragma mark 移除backgroundView
- (void)removeBackgroundView
{
    [_backgroundView removeFromSuperview];
}



#pragma mark 上啦刷新
- (void)pullUpNews
{
    // 设置回调
    self.tableView.mj_footer = [SHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark 上啦刷新
- (void)loadMoreData
{
    
    __weak typeof(self) weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/order"];
    
    NSDictionary *dict = @{@"page":self.page,@"pagesize":@"8",@"state":@"1"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        weakself.page = responseObject[@"result"][@"request_args"][@"page"];
        
        NSArray *dataArray = responseObject[@"list"];
        
        NSArray *array = [NSArray array];
        
        array = [MerchantsOrdersModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        [weakself.merchantsArray addObjectsFromArray:array];
        
        
        
        for (int i = 0;i<weakself.merchantsArray.count;i++)
        {
            NSArray <ShoppingForDetailsModel*> *array = [NSArray array];
            array  =  [ShoppingForDetailsModel mj_objectArrayWithKeyValuesArray:weakself.merchantsArray[i].detail];
            [weakself.shoppingForDetailsArray addObjectsFromArray:array];
        }
        
        [tableView reloadData];
        [tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        weakself.signal = @"0";
        if (self.merchantsArray.count > 0)
        {
            [weakself.merchantsArray removeAllObjects];
            
        }
        [weakself.tableView reloadData];
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        [weakself.tableView.mj_footer endRefreshing];


    }];
}


#pragma mark tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.suppliersArray.count == 0)
    {
        
        SendTheCourierViewController *sendVc = [[SendTheCourierViewController alloc] init];
        sendVc.orderId = self.merchantsArray[indexPath.row].id;
        [self.navigationController pushViewController:sendVc animated:YES];
        
        
    }else
    {
        
        [self deleteHudBtn];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.suppliersArray.count > 0)
    {
        return self.suppliersArray.count;
    }else
    {
        return self.merchantsArray.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.suppliersArray.count > 0)
    {
        NSString *Id = @"suppCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Id];
        }
        
        cell.textLabel.text = self.suppliersArray[indexPath.row];
        
        return cell;
        
    }else
    {
        NSString *Id = @"cell";
        MerchantsToBeProcessedCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
        if (!cell) {
            cell = [[MerchantsToBeProcessedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        }
        cell.mecchantsModel = self.merchantsArray[indexPath.row];
        cell.shopModel = self.shoppingForDetailsArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
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
