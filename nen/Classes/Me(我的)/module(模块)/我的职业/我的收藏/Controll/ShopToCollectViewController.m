//
//  ShopToCollectViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
//店铺收藏

#import "ShopToCollectViewController.h"
#import "ShopFavoritesModel.h"
#import "ShopToCollectCell.h"
#import "MyShopController.h"

@interface ShopToCollectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray<ShopFavoritesModel *> *shoptDataArray;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSString *page;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *signal;

@end

@implementation ShopToCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UITableView *tablev = [[UITableView alloc] init];
    self.tableView = tablev;
    tablev.dataSource = self;
    tablev.delegate = self;
    tablev.frame = CGRectMake(0,99,ScreenWidth,ScreenHeight - 99);
    tablev.rowHeight = 80;
    tablev.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tablev];
    
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
    
    
    [ShopFavoritesModel ShopFavoritesModelsuccess:^(NSMutableArray<ShopFavoritesModel *> *ShopFavoritesArray) {
        
        self.shoptDataArray = ShopFavoritesArray;

        if (self.shoptDataArray.count >0)
        {   [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
        }else
        {
            weakself.signal = @"1";
            [weakself removeBackgroundView];
            if (weakself.shoptDataArray.count > 0)
            {
                [weakself.shoptDataArray removeAllObjects];
            }
            [weakself.tableView reloadData];
            [weakself setEmptyView];
            [weakself.tableView.mj_header endRefreshing];
        }
        
    } error:^{
        weakself.signal = @"0";
        [weakself removeBackgroundView];
        if (weakself.shoptDataArray.count > 0)
        {
            [weakself.shoptDataArray removeAllObjects];
        }
        [weakself.tableView reloadData];
        [weakself setEmptyView];
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
        NSMutableArray <ShopFavoritesModel*> *array = [ShopFavoritesModel mj_objectArrayWithKeyValuesArray:dataArray];\
        
        [weakself.shoptDataArray addObjectsFromArray:array];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.signal = @"0";
        [weakself removeBackgroundView];
        if (weakself.shoptDataArray.count > 0)
        {
            [weakself.shoptDataArray removeAllObjects];
        }
        [weakself.tableView reloadData];
        [weakself setEmptyView];
        [weakself.tableView.mj_footer endRefreshing];
    
    }];
}

#pragma mark 没有数据时显示
-(void)setEmptyView
{
    NSString * showTextStr;
    if ([self.signal isEqualToString:@"1"])
    {
        showTextStr = @"您没有收藏店铺!";
    }else
    {
        showTextStr = @"您的网络信号不好!";
        
    }

    
    //默认视图背景
    //默认视图背景
    _backgroundView = [[ThereIsNoDataBackgroundView alloc] initWithThereIsNoDataBackgroundViewImageIcon:KNoDataBackgroundImage ImageX:ScreenWidth*0.25 ImageY:ScreenHeight *0.25 ImageW:ScreenWidth *0.5 imageH:ScreenWidth *0.5 ShowBottomText:showTextStr];
    [self.tableView addSubview:_backgroundView];
    
}
#pragma mark 移除backgroundView
- (void)removeBackgroundView
{
    [_backgroundView removeFromSuperview];
}




#pragma -------------tableViewDelegate----------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyShopController *shopVc = [[MyShopController alloc] init];
    shopVc.shopDetailed_Id = self.shoptDataArray[indexPath.row].id;
    [self.navigationController pushViewController:shopVc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shoptDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"shopToCollectCell";

    ShopToCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell = [[ShopToCollectCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Id];
    }

    cell.shopModel  = self.shoptDataArray[indexPath.row];
    
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

@end
