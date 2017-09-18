//
//  NotificationMessageViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "NotificationMessageViewController.h"
#import "PushMessageModel.h"
#import "NotificationMessageCell.h"

@interface NotificationMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray<PushMessageModel *> *pushMessageDataArray;

@property(nonatomic,copy) NSString *page;

@property(nonatomic,copy) UIView *backgroundView;

@end

@implementation NotificationMessageViewController

#pragma mark  数组赖加载
- (NSMutableArray *)pushMessageDataArray
{
    if (!_pushMessageDataArray)
    {
        _pushMessageDataArray = [NSMutableArray array];
    }
    
    return _pushMessageDataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tabVc = [[UITableView alloc] init];
    tabVc.delegate = self;
    tabVc.dataSource = self;
    tabVc.rowHeight = 100;
    self.tableView = tabVc;
    tabVc.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabVc.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    [self.view addSubview:tabVc];
    
    [self pulldownNews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"推送消息";
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
    
    [PushMessageModel pushMessageModelPage:@"1" PageSzie:@"8" Success:^(NSMutableArray<PushMessageModel *> *pushMessageArray) {
        
        weakself.pushMessageDataArray = pushMessageArray;
        
        if (weakself.pushMessageDataArray.count > 0)
        {
            [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
        }else
        {
            [weakself removeBackgroundView];
            [weakself setEmptyView];
            [weakself.tableView.mj_header endRefreshing];
        }
        
    } error:^{
        NSLog(@"失败");
        [weakself.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark 没有数据时显示
- (void)setEmptyView
{
    //默认视图背景
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight - 249)];
    _backgroundView.tag = 100;
    [self.tableView addSubview:_backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Snip"]];
    img.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [_backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.frame = CGRectMake(ScreenWidth *0.5 - 40 ,img.sh_bottom + 10,80,35);
    warnLabel.text = @"暂无数据!";
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = LZColorFromHex(0x706F6F);
    [_backgroundView addSubview:warnLabel];
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
    // 每次上拉页数加1
    self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/push/getinfo"];
    
    NSDictionary *dict = @{@"page":self.page,@"pagesize":@"8"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        weakself.page = responseObject[@"result"][@"request_args"][@"page"];
        
        NSArray *dataArray = responseObject[@"list"];
        
        
        if (dataArray.count == 0)
        {
            [tableView.mj_footer endRefreshing];
            return ;
        }
        
        NSArray *array = [NSArray array];
        
        array = [PushMessageModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        [weakself.pushMessageDataArray addObjectsFromArray:array];
        
        [tableView reloadData];
        
        [tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pushMessageDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    NotificationMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (!cell) {
        
        cell = [[NotificationMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.pushMessageDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}


@end
