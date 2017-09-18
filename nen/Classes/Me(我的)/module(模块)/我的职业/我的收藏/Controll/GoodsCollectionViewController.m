//
//  GoodsCollectionViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
//商品收藏

#import "GoodsCollectionViewController.h"
#import "CollectgoodsModel.h"
#import "GoodsCollectionListCell.h"
#import "ShoppingViewController.h"

@interface GoodsCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray<CollectgoodsModel *> *goodsDataArray;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,copy) NSString *page;
@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *signal;


@end

@implementation GoodsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor skyBlue];
    
    UITableView *tableV = [[UITableView alloc] init];
    self.tableView =tableV;
    tableV.frame = CGRectMake(0,99,ScreenWidth,ScreenHeight - 99);
    tableV.rowHeight = 100;
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableV];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self pulldownNews];
}


#pragma mark ------------刷新控件--------------

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
    [self pullUpNews];
    
    self.page =@"1";
    __weak typeof(self) weakself = self;
    
    [CollectgoodsModel collectgoodsModelsuccess:^(NSMutableArray<CollectgoodsModel *> *collectGoodsArray) {
        self.goodsDataArray = collectGoodsArray;
        
        
        if (self.goodsDataArray.count >0)
        {   [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            
        }else
        {
            weakself.signal = @"1";
            if (weakself.goodsDataArray.count >0)
            {
                [weakself.goodsDataArray removeAllObjects];
            }
            [weakself removeBackgroundView];
            [weakself setEmptyView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];

        }
        
    } error:^{
        
        weakself.signal = @"0";
        if (weakself.goodsDataArray.count >0)
        {
            [weakself.goodsDataArray removeAllObjects];
        }
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    
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
     // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%ld",[self.page integerValue] + 1];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/collect/collectgoodslist"];
    
    NSDictionary *dict = @{@"page":self.page,@"pagesize":@"8"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *dataArray = responseObject[@"list"];
        NSMutableArray <CollectgoodsModel*> *array = [CollectgoodsModel mj_objectArrayWithKeyValuesArray:dataArray];\
        
        [weakself.goodsDataArray addObjectsFromArray:array];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.signal = @"0";
        if (weakself.goodsDataArray.count >0)
        {
            [weakself.goodsDataArray removeAllObjects];
        }
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark 没有数据时显示
- (void)setEmptyView
{
    NSString * showTextStr;
    if ([self.signal isEqualToString:@"1"])
    {
        showTextStr = @"您没有收藏物品!";
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


#pragma mark -----------tableViewDelegate----------------


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingViewController *shopVc = [[ShoppingViewController alloc] init];
    
    // 1跳转团购页面 0是消费中奖
    NSString *is_group = self.goodsDataArray[indexPath.row].is_group;
    if ([is_group isEqualToString:@"1"])
    {
        shopVc.groupGoodsId = self.goodsDataArray[indexPath.row].id;
        
    }else if ([is_group isEqualToString:@"0"])
    {
        shopVc.goodsIdItem = self.goodsDataArray[indexPath.row].id;
    }
    
    shopVc.page = @"1";
    
    [self.navigationController pushViewController:shopVc animated:YES];
    
    //NSLog(@"%@",is_group);
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"goodsCollectionCell";

    GoodsCollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell){
        cell = [[GoodsCollectionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    cell.goodsModel = self.goodsDataArray[indexPath.row];
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
