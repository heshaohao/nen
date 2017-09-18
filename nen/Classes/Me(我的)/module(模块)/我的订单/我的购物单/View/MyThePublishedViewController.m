//
//  MyThePublishedViewController.m
//  nen
//
//  Created by nenios101 on 2017/5/25.
//  Copyright © 2017年 nen. All rights reserved.
// 我的发表帖子 

#import "MyThePublishedViewController.h"
#import "MyThePostModel.h"
#import "MyThePublishedViewCell.h"
#import "PostCommentsViewController.h"
@interface MyThePublishedViewController ()

@property(nonatomic,strong) NSMutableArray <MyThePostModel *> *PostArray;

@property(nonatomic,strong) MyThePublishedViewCell *cells;

@property(nonatomic,strong) UIAlertController *alertController;

// 加载更多页码
@property(nonatomic,copy) NSString * page;
@end

@implementation MyThePublishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self.tableView reloadData];
    self.page = @"1";
    
    [self pulldownNews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPostViewControll:) name:@"pushCommentPostVc" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePost:) name:@"deleteIdPost" object:nil];
}


#pragma mark 跳转评论控制器

- (void)pushPostViewControll:(NSNotification *)notification
{
    NSString *postId = notification.userInfo[@"postId"];
    
    [self pushCommentPostVcPostId:postId];
}


-(void)pushCommentPostVcPostId:(NSString *)postId
{
    PostCommentsViewController*postVc = [[PostCommentsViewController alloc] init];
    postVc.postId = postId;
    
    [self.navigationController pushViewController:postVc animated:YES];

    
}

#pragma mark 删除帖子

- (void)deletePost:(NSNotification *)notification
{
    NSString *postId = notification.userInfo[@"postDeleteId"];
    
    __weak __typeof(self)weakSelf = self;
    __weak UITableView *tableView = self.tableView;
    
    // 标题
    self.alertController = [UIAlertController alertControllerWithTitle:@"是否删除订单!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 暂不
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self.alertController addAction:cancelAction];
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    // 删除
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 每次下拉页数加1
        weakSelf.page = [NSString stringWithFormat:@"%d",[weakSelf.page integerValue] + 1];
        
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/delete"];
        
        NSDictionary *dict = @{@"id":postId};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"%@",responseObject);
            
            for (int i =0 ; i< weakSelf.PostArray.count;i++)
            {
                if ([postId isEqualToString:weakSelf.PostArray[i].id])
                {
                    [weakSelf.PostArray removeObjectAtIndex:i];
                }
                
            }
            
            [tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            
        }];

        
    }];
    
    [defaultAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    [self.alertController addAction:defaultAction];
    
    [self presentViewController:self.alertController animated:NO completion:nil];
    
    

   
    
    
}



#pragma mark 下拉刷新
- (void)pulldownNews
{
    [self pullUpNews];
    
    __weak __typeof(self)weakSelf = self;
    
    // 点击进入立即刷新
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingBlock:^{
        __weak UITableView *tableView = self.tableView;
        
        [MyThePostModel myThePostModelPageSize:@"12" Page:@"1" success:^(NSMutableArray<MyThePostModel *> *PostArray) {
            weakSelf.PostArray = PostArray;
            [weakSelf.tableView reloadData];
            [tableView.mj_header endRefreshing];

        } error:^{
             NSLog(@"失败");
        }];
        
    // 马上进入刷新状态
    }];
    
    [weakSelf.tableView.mj_header beginRefreshing];
}

                                
                                
#pragma mark 上啦刷新
- (void)pullUpNews
{
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_footer = [SHRefreshFooter footerWithRefreshingBlock:^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 每次下拉页数加1
        weakSelf.page = [NSString stringWithFormat:@"%d",[weakSelf.page integerValue] + 1];
        
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/mypost"];
        
        NSDictionary *dict = @{@"page":weakSelf.page,@"pagesize":@"12"};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        __weak UITableView *tableView = self.tableView;
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *temporaryPage = responseObject[@"result"][@"request_args"][@"page"];
            
            
            if (![weakSelf.page isEqualToString:temporaryPage])
            {
                weakSelf.page = temporaryPage;
                
                NSArray *dataArray = responseObject[@"list"];
                
                NSArray *array = [NSArray array];
                
                array = [MyThePostModel mj_objectArrayWithKeyValuesArray:dataArray];
                
                [weakSelf.PostArray addObjectsFromArray:array];
            }
            else
                
            {
                tableView.mj_footer.state = MJRefreshStateNoMoreData;
                
            }
            
            [tableView.mj_footer endRefreshing];
            [tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }];
    
    
}


#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyThePostModel *model = self.PostArray[indexPath.row];
    
    [self pushCommentPostVcPostId:model.id];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.PostArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.确定重用标示:
    static NSString *ID = @"cell";
    
    MyThePublishedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    MyThePostModel *postModel = self.PostArray[indexPath.row];
    
    if (!cell) {
        
        cell = [[MyThePublishedViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }else
    {
        NSLog(@"%@",cell.subviews.firstObject.subviews);
    }
    
    self.cells = cell;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.model = postModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self.cells rowHeight];
    
}


@end
