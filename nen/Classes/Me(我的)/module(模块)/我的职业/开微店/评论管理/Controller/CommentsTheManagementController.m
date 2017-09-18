//
//  CommentsTheManagementController.m
//  nen
//
//  Created by nenios101 on 2017/6/14.
//  Copyright © 2017年 nen. All rights reserved.
// 微店评论管理 

#import "CommentsTheManagementController.h"
#import "ShopGoodsCommentsModel.h"
#import "CommentsTheManagementCell.h"
#import "ReplyTheBuyerViewController.h"
@interface CommentsTheManagementController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) CommentsTheManagementCell *commentCell;

@property(nonatomic,strong) NSMutableArray<ShopGoodsCommentsModel *> *shopGoodsCommentsModelArray;


@property(nonatomic,strong) UIView *backgroundView;

@property(nonatomic,copy) NSString *signal;

@property(nonatomic,copy) NSString *page;

@end

@implementation CommentsTheManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    UITableView *tableV = [[UITableView alloc] init];
    self.tableView = tableV;
    tableV.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tableFooterView = [[UIView alloc] init];
    tableV.rowHeight = UITableViewAutomaticDimension;
    tableV.estimatedRowHeight = 1000;
    [self.view addSubview:tableV];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self setNavBar];
    [self pulldownNews];
    self.navigationController.navigationBarHidden = NO;
    
}
#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"评论管理";
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0,KNavBarBackBtnW, KNavBarBackBtnH);
    [leftButton setBackgroundImage:KNavBarBackIcon forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    nagetiveSpacer.width = KNavBarSpacing;   //这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,leftBarButtonItems];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:KNavBarTittleFont],
       
       NSForegroundColorAttributeName:KNavBarTitleColor }];
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintColor;
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----------------刷新控件--------------------------
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
    self.page = @"1";
    __weak typeof(self)weakself = self;
    [ShopGoodsCommentsModel ShopGoodsCommentsModelType:@"0" PageSize:@"8" Page:self.page success:^(NSMutableArray<ShopGoodsCommentsModel *> *ShopGoodsListArray) {
        
        weakself.shopGoodsCommentsModelArray = ShopGoodsListArray;
        if (weakself.shopGoodsCommentsModelArray.count > 0)
        {
            [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            
        }else
        {
            weakself.signal = @"1";
            if (weakself.shopGoodsCommentsModelArray.count >0)
            {
                [weakself.shopGoodsCommentsModelArray removeAllObjects];
            }
            [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself setEmptyView];
            [weakself.tableView.mj_header endRefreshing];

        }
        
    } error:^{
        
        weakself.signal = @"0";
        if (weakself.shopGoodsCommentsModelArray.count >0)
        {
            [weakself.shopGoodsCommentsModelArray removeAllObjects];
        }
        [weakself removeBackgroundView];
        [weakself.tableView reloadData];
        [weakself setEmptyView];
        [weakself.tableView.mj_header endRefreshing];
    }];
}


- (void)setEmptyView
{
    NSString * showTextStr;
    if ([self.signal isEqualToString:@"1"])
    {
        showTextStr = @"暂无评价";
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
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/getexvalall"];
    
    NSDictionary *dict = @{@"page":self.page,@"pagesize":@"8",@"type":@"0"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        weakself.page = responseObject[@"result"][@"request_args"][@"page"];
        
        NSArray *dataArray = responseObject[@"list"];
        
        NSArray *array = [NSArray array];
        
        array = [ShopGoodsCommentsModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        [weakself.shopGoodsCommentsModelArray addObjectsFromArray:array];
        
        [tableView reloadData];
        
        [tableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.signal = @"0";
        if (weakself.shopGoodsCommentsModelArray.count >0)
        {
            [weakself.shopGoodsCommentsModelArray removeAllObjects];
        }
        [weakself removeBackgroundView];
        [weakself.tableView reloadData];
        [weakself setEmptyView];
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}





#pragma mark ---------------- tabelViewDetegate ----------------------


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReplyTheBuyerViewController *replyVc = [[ReplyTheBuyerViewController alloc] init];
    replyVc.model = self.shopGoodsCommentsModelArray[indexPath.row];
    NSString *relpStr  =  self.shopGoodsCommentsModelArray[indexPath.row].reply;
    
    if (relpStr.length == 0)
    {
        [self.navigationController pushViewController:replyVc animated:YES];
        
    }else
    {
        [JKAlert alertText:@"已回复了"];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopGoodsCommentsModelArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"shopGoodsComtnetCell";
    
    CommentsTheManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell  = [[CommentsTheManagementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    self.commentCell = cell;
    
    cell.model = self.shopGoodsCommentsModelArray[indexPath.row];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return [self.commentCell returnCommentsHeight];
}



@end
