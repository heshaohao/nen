//
//  PostCollectionViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
// 帖子收藏

#import "PostCollectionViewController.h"
#import "PostCollectionModel.h"
#import "PostCollectionCell.h"
#import "PostCommentsViewController.h"
@interface PostCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray<PostCollectionModel *> *postDataCollectionArray;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSString *page;

@property(nonatomic,strong)ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *postId;

@property(nonatomic,copy) NSString *signal;

@end

@implementation PostCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor ghostWhite];
    
    UITableView *tablev = [[UITableView alloc] init];
    self.tableView = tablev;
    tablev.dataSource = self;
    tablev.delegate = self;
    tablev.frame = CGRectMake(0,99,ScreenWidth,ScreenHeight - 99);
    tablev.rowHeight = 80;
    tablev.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tablev];

    [self pulldownNews];
    
    // 评论按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionComment:) name:@"collectionCommentPushVc" object:nil];
    // 删除按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTheCollectionBtn:) name:@"cancelTheCollection" object:nil];
    
}



#pragma mark ------------评论按钮 和删除按钮 方法----------------

//  评论按钮
- (void)collectionComment:(NSNotification *)notification
{
    self.postId = notification.userInfo[@"postId"];
    
    [self pushPostCommentsVcPostId:self.postId];
}

#pragma mark 跳转评论控制器
- (void)pushPostCommentsVcPostId:(NSString *)postId
{
    
    PostCommentsViewController *commentVc = [[PostCommentsViewController alloc] init];
    commentVc.postId = postId;
    [self.navigationController pushViewController:commentVc animated:YES];
    
}



//  删除按钮
- (void)cancelTheCollectionBtn:(NSNotification *)notification
{
    self.postId = notification.userInfo[@"postDeleteId"];
    
    // 标题
    UIAlertController *aleart = [UIAlertController alertControllerWithTitle:@"是否删除帖子!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 暂不
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [aleart addAction:cancelAction];
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    // 删除
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self PostCancelPostId:self.postId];
    }];
    
    [defaultAction setValue:[UIColor orangeColor] forKey:@"_titleTextColor"];
    
    [aleart addAction:defaultAction];
    
    [self presentViewController:aleart animated:NO completion:nil];
    
}

#pragma mark 取消收藏帖子
- (void)PostCancelPostId:(NSString *)postId
{
    __weak typeof(self)weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    //  weakSelf.page = [NSString stringWithFormat:@"%d",[weakSelf.page integerValue] + 1];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/cancel"];
    
    NSDictionary *dict = @{@"id":postId};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        for (int i =0 ; i< weakself.postDataCollectionArray.count;i++)
        {
            if ([weakself.postId isEqualToString:weakself.postDataCollectionArray[i].id])
            {
                [weakself.postDataCollectionArray removeObjectAtIndex:i];
            }
        }
        
        [weakself.tableView reloadData];
        
        if (weakself.postDataCollectionArray.count == 0)
        {
            self.signal = @"1";
            [self setEmptyView];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
    }];

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
    
    [PostCollectionModel PostCollectionModelsuccess:^(NSMutableArray<PostCollectionModel *> *postCollectionArray) {
        self.postDataCollectionArray = postCollectionArray;
        if (self.postDataCollectionArray.count >0)
        {   [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            
        }else
        {
            weakself.signal = @"1";
            [weakself removeBackgroundView];
            if (weakself.postDataCollectionArray.count > 0)
            {
                [weakself.postDataCollectionArray removeAllObjects];
            }
            [weakself.tableView reloadData];
            [weakself setEmptyView];
            [weakself.tableView.mj_header endRefreshing];
        }
        
    } error:^{
        weakself.signal = @"0";
        [weakself removeBackgroundView];
        if (weakself.postDataCollectionArray.count > 0)
        {
            [weakself.postDataCollectionArray removeAllObjects];
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
        NSMutableArray <PostCollectionModel*> *array = [PostCollectionModel mj_objectArrayWithKeyValuesArray:dataArray];\
        
        [weakself.postDataCollectionArray addObjectsFromArray:array];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.signal = @"0";
        [weakself removeBackgroundView];
        if (weakself.postDataCollectionArray.count > 0)
        {
            [weakself.postDataCollectionArray removeAllObjects];
        }
        [weakself.tableView reloadData];
        [weakself setEmptyView];
        [weakself.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark 没有数据时显示
- (void)setEmptyView
{
    
    NSString * showTextStr;
    if ([self.signal isEqualToString:@"1"])
    {
        showTextStr = @"您没有收藏帖子!";
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



#pragma mark -------------tableViewDelegate----------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pushPostCommentsVcPostId:[NSString stringWithFormat:@"%@",self.postDataCollectionArray[indexPath.row].id]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postDataCollectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"postCollectCell";
    
    PostCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell = [[PostCollectionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Id];
    }
    
    cell.postModel  = self.postDataCollectionArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}


@end
