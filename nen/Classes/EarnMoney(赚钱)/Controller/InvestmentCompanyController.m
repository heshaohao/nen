//
//  LookHousekeepingController.m
//  nen
//
//  Created by nenios101 on 2017/3/1.
//  Copyright © 2017年 nen. All rights reserved.
//招商公司
#import "InvestmentCompanyController.h"

#import "YFRollingLabel.h"
#import "CurrencyView.h"
#import "FindGoodCell.h"
#import "ForumPostModel.h"
#import "PostCommentsViewController.h"
#import "ReleaseViewController.h"
#import "InfoturnModel.h"

@interface InvestmentCompanyController ()<SDCycleScrollViewDelegate>


// 跑马灯文本
@property (nonatomic,strong) YFRollingLabel *horseRaceLampLabel;

@property(nonatomic,strong) NSArray *shuffingMoldelArray;

@property(nonatomic,strong) NSMutableArray <ForumPostModel *> *forumPostArray;

@property(nonatomic,strong) FindGoodCell *cells;

// 加载更多页码
@property(nonatomic,copy) NSString * page;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,assign)CGFloat headViewBottmH;

@property(nonatomic,strong) NSArray <InfoturnModel *> *InfoturnArray;

@end

@implementation InvestmentCompanyController
#pragma mark 图片轮播器数组
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [self.tableView reloadData];
    
    // 加载数据
    [ShufflingFigureModel shufflingFigureLocation:@"1" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        self.shuffingMoldelArray = shufflingFigure;
        [self loadData];
    } error:^{
     //   NSLog(@"失败");
    }];
    
    // 点赞按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(investmentThumbBtnClick) name:@"investmentThumbBtn" object:nil];
    // 评论按钮
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(investmentCommentBtnClick:) name:@"investmentCommentBtn" object:nil];
    
}

#pragma mark 跑马灯数据
- (void)loadData
{
    
    [InfoturnModel InfoturnModelLocation:@2 Success:^(NSArray<InfoturnModel *> *InfoturnArray) {
        
        self.InfoturnArray = InfoturnArray;
        
        self.tableView.tableHeaderView = [self headView];
        
        [self pulldownNews];
        
    } error:^{
      //  NSLog(@"失败");
    }];
    
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //[self.tableView reloadData];
}



#pragma mark -----------刷新控件-------------

#pragma mark 下拉刷新
- (void)pulldownNews
{
    [self pullUpNews];
    // 点击进入立即刷新
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingBlock:^{
        self.page = @"1";
        __weak typeof(self)weakself = self;
        
        [ForumPostModel forumPostModelType:@"3" PageSize:@"12" Page:self.page success:^(NSMutableArray<ForumPostModel *> *forumPosArray) {
            
            weakself.forumPostArray = forumPosArray;
            if (weakself.forumPostArray.count > 0)
            {
                [weakself removeBackgroundView];
                [weakself.tableView reloadData];
                [weakself.tableView.mj_header endRefreshing];
                
            }else
            {
                [weakself removeBackgroundView];
                [weakself setEmptyView];
                [weakself.tableView reloadData];
                [weakself.tableView.mj_header endRefreshing];
            }
        } error:^{
            
           // NSLog(@"失败");
             [weakself.tableView.mj_header endRefreshing];
        }];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark 上啦刷新
- (void)pullUpNews
{
    
    __weak typeof(self)weakself = self;
    self.tableView.mj_footer = [SHRefreshFooter footerWithRefreshingBlock:^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 每次下拉页数加1
        weakself.page = [NSString stringWithFormat:@"%ld",[weakself.page integerValue] + 1];
        
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/list"];
        
        NSDictionary *dict = @{@"page":weakself.page,@"pagesize":@"12",@"type":@"3"};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *temporaryPage = responseObject[@"result"][@"request_args"][@"page"];
            
            
            if (![weakself.page isEqualToString:temporaryPage])
            {
                weakself.page = temporaryPage;
                
                NSArray *dataArray = responseObject[@"list"];
                
                NSArray *array = [NSArray array];
                
                array = [ForumPostModel mj_objectArrayWithKeyValuesArray:dataArray];
                
                [weakself.forumPostArray addObjectsFromArray:array];
            }
            else
                
            {
                weakself.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                
            }
            
            [weakself.tableView reloadData];
            weakself.tableView.mj_footer.hidden = NO;
            [weakself.tableView.mj_footer endRefreshing];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakself.tableView.mj_footer endRefreshing];
        }];
        
    }];
}

#pragma mark 没有数据时显示
- (void)setEmptyView
{
    //默认视图背景
    _backgroundView = [[ThereIsNoDataBackgroundView alloc] initWithThereIsNoDataBackgroundViewImageIcon:KNoDataBackgroundImage ImageX:ScreenWidth *0.5 - 40 ImageY:20 ImageW:80 imageH:80 ShowBottomText:@"暂无数据"];
    
    _backgroundView.frame = CGRectMake(0,self.headViewBottmH + 100,ScreenWidth,ScreenHeight - (self.headViewBottmH + 200));
    
    [self.tableView addSubview:_backgroundView];
    
    
}

#pragma mark 移除backgroundView
- (void)removeBackgroundView
{
    [_backgroundView removeFromSuperview];
}


// 轮播器跳转
- (void)selectItemAtIndex:(NSInteger)index
{
    
    
}

#pragma mark --------------tableView头部-------------------

- (UIView *)headView
{
    UIView *headerView = [[UIView alloc] init];
    
  
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    
    [self.shuffingMoldelArray enumerateObjectsUsingBlock:^(ShufflingFigureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrTemp addObject:obj.img_url];
    }];
    cycleScrollView.imageURLStringsGroup = arrTemp;
    
    [headerView addSubview:cycleScrollView];
    
    //    // 跑马灯
    
    //添加文字内容
    
    NSMutableArray *textArray = [NSMutableArray array];
    
    
    for (int i = 0;i < self.InfoturnArray.count; i++)
    {
        
        [textArray addObject:self.InfoturnArray[i].content];
        
    }
    
    self.horseRaceLampLabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(0,155, self.view.frame.size.width, 35)  textArray:textArray font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor]];
    self.horseRaceLampLabel.backgroundColor = [UIColor colorWithHexString:@"#EA4717"];
    self.horseRaceLampLabel.speed = 1;
    [self.horseRaceLampLabel setOrientation:RollingOrientationLeft];
    [self.horseRaceLampLabel setInternalWidth:self.horseRaceLampLabel.frame.size.width / 3];
    
    // 获取文字点击文字点击
    self.horseRaceLampLabel.labelClickBlock = ^(NSInteger index){
        NSString *text = [textArray objectAtIndex:index];
       // NSLog(@"You Tapped item:%li , and the text is %@",(long)index,text);
    };
    
    [headerView addSubview:self.horseRaceLampLabel];
    
    
    UIView *publishView = [[UIView alloc] init];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishClick:)];
    
    [publishView addGestureRecognizer:tapGesture];
    publishView.frame = CGRectMake(0,self.horseRaceLampLabel.sh_bottom,ScreenWidth,70);
    publishView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [headerView addSubview:publishView];
    
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.frame = CGRectMake(10,publishView.sh_height *0.25,50,50);
    if ([self.iconImageStr isEqualToString:@"postIcon"])
    {
        iconImageV.image = [UIImage imageNamed:@"postIcon"];
    }else
    {
        [iconImageV sd_setImageWithURL:[NSURL URLWithString:self.iconImageStr]];
    }
    iconImageV.layer.cornerRadius = 25;
    iconImageV.clipsToBounds = YES;
    [publishView addSubview:iconImageV];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(iconImageV.sh_right + 5,publishView.sh_height *0.5 ,80,16);
    titleLabel.text = @"说点什么吧...";
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [publishView addSubview:titleLabel];
    
    
    UIImageView *rightIconImageV = [[UIImageView alloc] init];
    rightIconImageV.frame = CGRectMake(ScreenWidth - 35,titleLabel.sh_y,20,20);
    rightIconImageV.image = [UIImage imageNamed:@"fenxiangxiangji"];
    rightIconImageV.clipsToBounds = YES;
    [publishView addSubview:rightIconImageV];
    
    UIView *titleBottomLine = [[UIView alloc] init];
    titleBottomLine.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    titleBottomLine.frame = CGRectMake(0,publishView.sh_bottom,ScreenWidth, 5);
    [headerView addSubview:titleBottomLine];
    
    headerView.sh_x = 0;
    headerView.sh_y = - 99;
    headerView.sh_width = ScreenWidth;
    headerView.sh_height = publishView.sh_bottom + 5;
    self.headViewBottmH = headerView.sh_bottom;
    
    
    //    CGFloat titleWidth = ScreenWidth / 3;
    //
    //    UIView *postsTitleView = [[UIView alloc] init];
    //    postsTitleView.backgroundColor = [UIColor whiteColor];
    //    postsTitleView.frame = CGRectMake(0,titleBottomLine.sh_bottom + 3,ScreenWidth,20);
    //    [headerView addSubview:postsTitleView];
    
    //    UILabel *themeLabel = [[UILabel alloc] init];
    //    themeLabel.frame = CGRectMake(0,0,titleWidth, 20);
    //    themeLabel.font = [UIFont systemFontOfSize:13];
    //    themeLabel.text = @"主题: 122";
    //    themeLabel.textAlignment = NSTextAlignmentCenter;
    //    [postsTitleView addSubview:themeLabel];
    //
    //
    //    UILabel *topPostsLabel = [[UILabel alloc] init];
    //    topPostsLabel.frame = CGRectMake(themeLabel.sh_right,0,titleWidth, 20);
    //    topPostsLabel.font = [UIFont systemFontOfSize:13];
    //    topPostsLabel.text = @"热帖: 124";
    //    topPostsLabel.textAlignment = NSTextAlignmentCenter;
    //    [postsTitleView addSubview:topPostsLabel];
    //
    //    UILabel *essenceLabel = [[UILabel alloc] init];
    //    essenceLabel.frame = CGRectMake(topPostsLabel.sh_right,0,titleWidth, 20);
    //    essenceLabel.font = [UIFont systemFontOfSize:13];
    //    essenceLabel.text = @"精华: 122";
    //    essenceLabel.textAlignment = NSTextAlignmentCenter;
    //    [postsTitleView addSubview:essenceLabel];
    //
    
    return headerView;
    
}


#pragma mark 跳转搜索控制器
-(void)pushSearchViewControll
{
    [self.navigationController pushViewController:[[SearGoodsViewController alloc] init] animated:YES];
}


#pragma mark 发布帖子
- (void)publishClick:(UITapGestureRecognizer *)tap
{
    
    ReleaseViewController *releaseVc = [[ReleaseViewController alloc] init];
    releaseVc.type = @"3";
    
    [self.navigationController pushViewController:releaseVc animated:YES];
}

#pragma mark 点赞按钮
- (void)investmentThumbBtnClick
{
    //    [self.tableView reloadData];
}

#pragma mark 评论按钮
- (void)investmentCommentBtnClick:(NSNotification *)notification
{
 
    [self investmentPushCommentsViewControllerPostId:[NSString stringWithFormat:@"%@",notification.userInfo[@"id"]]];
    
}

// 跳转评论控制器
- (void)investmentPushCommentsViewControllerPostId:(NSString *)postId
{
    
    PostCommentsViewController*postVc = [[PostCommentsViewController alloc] init];
    postVc.postId = postId;
    [self.navigationController pushViewController:postVc animated:YES];
}


#pragma mark -----------tableViewDelegate-------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self investmentPushCommentsViewControllerPostId:[NSString stringWithFormat:@"%@",self.forumPostArray[indexPath.row].id]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.forumPostArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.确定重用标示:
    static NSString *ID = @"InvestmentCell";
    
    FindGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ForumPostModel *forModel = self.forumPostArray[indexPath.row];
    
    if (!cell) {
        
        cell = [[FindGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    self.cells = cell;
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    cell.model = forModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self.cells rowHeight];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
