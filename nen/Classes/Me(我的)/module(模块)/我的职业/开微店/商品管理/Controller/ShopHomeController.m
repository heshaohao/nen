//
//  ShopHomeController.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
// 店铺首页

#import "ShopHomeController.h"
#import "BottomView.h"
#import "MyShopGoodsModel.h"
#import "ShopHomeGoodsCell.h"
#import "ShoppingViewController.h"

@interface ShopHomeController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray<MyShopGoodsModel *> *goodsArray;

@property(nonatomic,copy) NSString *page;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *signal;

@end

@implementation ShopHomeController

- (NSMutableArray *)goodsArray
{
    if (!_goodsArray)
    {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tabelV = [[UITableView alloc] init];
    self.tableView = tabelV;
    tabelV.frame = CGRectMake(0,199,ScreenWidth,ScreenHeight - 249);
    tabelV.delegate = self;
    tabelV.dataSource = self;
    tabelV.showsVerticalScrollIndicator = NO;
    tabelV.showsHorizontalScrollIndicator = NO;
    tabelV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabelV.rowHeight = 150;
    tabelV.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tabelV];
    
    [self pulldownNews];
    
//    
//    [MyShopGoodsModel shopGoodsListModelShopId:self.shopId Type:@"home" PageSize:@"8" Page:@"1" success:^(NSMutableArray<MyShopGoodsModel *> *ShopGoodsListArray) {
//        
////        self.goodsArray = ShopGoodsListArray;
////        [self.tableView reloadData];
//        
//        
//
//        
//        NSLog(@"%d",self.goodsArray.count);
//        
//    } error:^{
//        
//        NSLog(@"失败");
//    }];
    
    
}


#pragma mark 下拉刷新
- (void)pulldownNews
{
    // 点击进入立即刷新
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷状态
    [self.tableView.mj_header beginRefreshing];
    
}
#pragma mark 下来刷新
- (void)loadNewData
{
    [self pullUpNews];
    __weak UITableView *tableView = self.tableView;
    __weak typeof(self) weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/storegoodslist"];
    
     NSDictionary *dict = @{@"page":@"1",@"pagesize":@"8",@"type":@"home",@"shop_id":self.shopId};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // NSLog(@"%@",responseObject);
        
        NSString *coderStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        if ([coderStr isEqualToString:@"0"])
        {
            NSArray *dataArray = responseObject[@"list"];
            
            self.goodsArray = [MyShopGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            
            if (weakself.goodsArray.count >0)
            {
                [weakself removeBackgroundView];
                [weakself.tableView reloadData];
                weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                [tableView.mj_header endRefreshing];
            }else
            {
                weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                weakself.signal = @"1";
                [weakself removeBackgroundView];
                if (weakself.goodsArray.count > 0)
                {
                    [weakself.goodsArray removeAllObjects];
                }
                [weakself.tableView reloadData];
                [weakself setEmptyView];
                [weakself.tableView.mj_header endRefreshing];
                
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        weakself.signal = @"0";
        [weakself removeBackgroundView];
        if (weakself.goodsArray.count > 0)
        {
            [weakself.goodsArray removeAllObjects];
        }
        [weakself.tableView reloadData];
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
        showTextStr = @"暂无商品!";
    }else
    {
        showTextStr = @"您的网络信号不好!";
        
    }
    
    //默认视图背景
    _backgroundView = [[ThereIsNoDataBackgroundView alloc] initWithThereIsNoDataBackgroundViewImageIcon:KNoDataBackgroundImage ImageX:ScreenWidth *0.25 ImageY:self.tableView.sh_height *0.25 ImageW:ScreenWidth *0.5 imageH:ScreenWidth *0.5 ShowBottomText:showTextStr];
    _backgroundView.frame = CGRectMake(0,0,ScreenWidth,self.tableView.sh_height);
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
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/storegoodslist"];

     NSDictionary *dict = @{@"page":self.page,@"pagesize":@"8",@"type":@"home",@"shop_id":self.shopId};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *coder = responseObject[@"result"][@"resultCode"];
        
        if ([coder isEqualToString:@"0"])
        {
            weakself.page = responseObject[@"result"][@"request_args"][@"page"];
            
            NSArray *dataArray = responseObject[@"list"];
            
            NSArray *array = [NSArray array];
            
            array = [MyShopGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            [weakself.goodsArray addObjectsFromArray:array];
            
            [tableView reloadData];
            
            [tableView.mj_footer endRefreshing];
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        weakself.signal = @"0";
        [weakself removeBackgroundView];
        if (weakself.goodsArray.count > 0)
        {
            [weakself.goodsArray removeAllObjects];
        }
        [weakself.tableView reloadData];
        [weakself setEmptyView];
        [weakself.tableView.mj_footer endRefreshing];

    }];
   
}


#pragma mark tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyShopGoodsModel *model = self.goodsArray[indexPath.row];
    
    ShoppingViewController *shopVc = [[ShoppingViewController alloc] init];
    shopVc.goodsIdItem = model.id;
    shopVc.page =@"1";
    [self.navigationController pushViewController:shopVc animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    ShopHomeGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell)
    {
        cell = [[ShopHomeGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    cell.model = self.goodsArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
