//
//  MyTheCommentViewController.m
//  nen
//
//  Created by nenios101 on 2017/5/25.
//  Copyright © 2017年 nen. All rights reserved.
// 我的评论

#import "MyTheCommentViewController.h"
#import "PostCommentsModel.h"
#import "MyTheCommentCell.h"
#import "PostCommentsViewController.h"

@interface MyTheCommentViewController ()

@property(nonatomic,strong) NSMutableArray <PostCommentsModel *> *PostArray;

@property(nonatomic,strong) MyTheCommentCell *cells;

// 加载更多页码
@property(nonatomic,copy) NSString * page;
@end

@implementation MyTheCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self.tableView reloadData];
    self.page = @"1";
  
    [self pulldownNews];
    
}

#pragma mark 下拉刷新
- (void)pulldownNews
{
    [self pullUpNews];
    
    __weak __typeof(self)weakSelf = self;
    
    // 点击进入立即刷新
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingBlock:^{
        __weak UITableView *tableView = self.tableView;
        
        [PostCommentsModel postCommentsModelPageSize:@"8" Page:@"1" success:^(NSMutableArray<PostCommentsModel *> *PostArray) {
            
            weakSelf.PostArray = PostArray;
            [weakSelf.tableView reloadData];
            [tableView.mj_header endRefreshing];
            

        } error:^{
            
            NSLog(@"失败");

        }];
    }];
    
    // 马上进入刷新状态
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
                
                array = [PostCommentsModel mj_objectArrayWithKeyValuesArray:dataArray];
                
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
    PostCommentsModel *model = self.PostArray[indexPath.row];
    
    PostCommentsViewController*postVc = [[PostCommentsViewController alloc] init];
    postVc.postId = model.id;
    
    [self.navigationController pushViewController:postVc animated:YES];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.PostArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.确定重用标示:
    static NSString *ID = @"cell";
    
    MyTheCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    PostCommentsModel *postModel = self.PostArray[indexPath.row];
    
    if (!cell) {
        
        cell = [[MyTheCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
