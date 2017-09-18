//
//  HousekeepingController.m
//  nen
//
//  Created by nenios101 on 2017/3/1.
//  Copyright © 2017年 nen. All rights reserved.
//团购

#import "GroupBuyingController.h"

#import "YFRollingLabel.h"
#import "CurrencyView.h"
#import "subscrpitCell.h"
#import "ShoppingViewController.h"
#import "GoodsModel.h"
#import "TheOrderViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "GroupBuyingModel.h"
#import "GroupBuyingTableViewCell.h"
#import "ShoppingViewController.h"
#import "ShoppingCarController.h"
#import "InfoturnModel.h"

@interface GroupBuyingController ()<UITableViewDelegate,SDCycleScrollViewDelegate>
// 图片轮播器
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

// 跑马灯文本
@property (nonatomic, strong) YFRollingLabel *horseRaceLampLabel;

@property(nonatomic,strong) NSArray *shuffingMoldelArray;

@property(nonatomic,strong) NSMutableArray<GroupBuyingModel *> *groupBuyingArray;

@property(nonatomic,copy )NSString *page;
@property(nonatomic,copy) NSString *goodsName;

@property(nonatomic,copy) NSString *shopName;

@property(nonatomic,copy) NSString *iconImageStr;

@property(nonatomic,copy) NSString *shareStr;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;
@property(nonatomic,copy) NSString *signal;

@property(nonatomic,strong) NSArray <InfoturnModel *> *InfoturnArray;

@end

@implementation GroupBuyingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 150;
 
    // 加载数据
    [ShufflingFigureModel shufflingFigureLocation:@"1" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        
        self.shuffingMoldelArray = shufflingFigure;
        
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self loadData];
        
        [self pulldownNews];
        
        
    } error:^{
        self.signal = @"0";
        [self removeBackgroundView];
        [self setEmptyView];
    }];
    
    

}

#pragma mark 跑马灯数据
- (void)loadData
{
    
    [InfoturnModel InfoturnModelLocation:@1 Success:^(NSArray<InfoturnModel *> *InfoturnArray) {
        
        self.InfoturnArray = InfoturnArray;
        
        self.tableView.tableHeaderView = [self headView];
        
        [self.tableView reloadData];
        
        
    } error:^{
      //  NSLog(@"失败");
    }];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareClick:) name:@"shareBtns" object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(pushShopViewControll:) name:@"pushShopVc" object:nil];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark 跳转购物车
- (void)PushShoppingCarVc
{
    [self.navigationController pushViewController:[[ShoppingCarController alloc] init] animated:YES];
}


#pragma mark 图片轮播器数组赖加载
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}
#pragma mark 图片轮播器代理方法

- (void)selectItemAtIndex:(NSInteger)index
{
    
}



#pragma mark 跳转选购窍门
- (void)pushShopViewControll:(NSNotification *)notification
{
    ShoppingViewController *shoppingVc = [[ShoppingViewController alloc] init];
    shoppingVc.groupGoodsId = notification.userInfo[@"groupGoodsId"];
   // NSLog(@"%@",notification.userInfo[@"groupGoodsId"]);
    // 判断 跳转选购窍门 | 还是商品详情
    NSString *pageStr = notification.userInfo[@"page"];
    shoppingVc.page = pageStr;
   [self.navigationController pushViewController:shoppingVc animated:YES];
}

// 返回tableView头部

#pragma mark 返回头部
- (UIView *)headView
{
    UIView *headerView = [[UIView alloc] init];
    // 图片轮播器
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.cycleScrollView =cycleScrollView;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    
    [self.shuffingMoldelArray enumerateObjectsUsingBlock:^(ShufflingFigureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrTemp addObject:obj.img_url];
    }];
    
    cycleScrollView.imageURLStringsGroup = arrTemp;
    
    [headerView addSubview:cycleScrollView];
    
    NSMutableArray *textArray = [NSMutableArray array];
    
    
    for (int i = 0;i < self.InfoturnArray.count; i++)
    {
        
        [textArray addObject:self.InfoturnArray[i].content];
        
    }
    
    self.horseRaceLampLabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(0,_cycleScrollView.sh_bottom + 5, self.view.frame.size.width, 35)  textArray:textArray font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor]];
    self.horseRaceLampLabel.backgroundColor = [UIColor colorWithHexString:@"#EA4717"];
    self.horseRaceLampLabel.speed = 1;
    [self.horseRaceLampLabel setOrientation:RollingOrientationLeft];
    [self.horseRaceLampLabel setInternalWidth:self.horseRaceLampLabel.frame.size.width / 3];
    
    // 获取文字点击文字点击
    self.horseRaceLampLabel.labelClickBlock = ^(NSInteger index){
        NSString *text = [textArray objectAtIndex:index];
      //  NSLog(@"You Tapped item:%li , and the text is %@",(long)index,text);
    };
    
    [headerView addSubview:self.horseRaceLampLabel];
    
    
//    // 底部图片
//    UIView *buttonImage = [[UIView alloc] initWithFrame:CGRectMake(0,self.horseRaceLampLabel.sh_bottom,[UIScreen mainScreen].bounds.size.width,80)];
//    
//    UIImageView *leftImageView = [[UIImageView alloc] init];
//    leftImageView.sh_x = 10;
//    leftImageView.sh_height = buttonImage.sh_height;
//    leftImageView.sh_y = 0;
//    leftImageView.sh_width = ScreenWidth *0.4;
//    leftImageView.image = [UIImage imageNamed:@"car1"];
//    
//    UIImageView *rightImageView = [[UIImageView alloc] init];
//    rightImageView.sh_width = ScreenWidth * 0.5;
//    rightImageView.sh_x = (ScreenWidth * 0.5) - 10;
//    rightImageView.sh_height = buttonImage.sh_height;
//    rightImageView.image = [UIImage imageNamed:@"car1"];
//    
//    [buttonImage addSubview:leftImageView];
//    [buttonImage addSubview:rightImageView];
//    
//    [headerView addSubview:buttonImage];
    
    UIView *breaksLine = [[UIView alloc] init];
    breaksLine.frame = CGRectMake(0,self.horseRaceLampLabel.sh_bottom + 5,ScreenWidth,1);
    breaksLine.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [headerView addSubview:breaksLine];
    CurrencyView *currency = [CurrencyView currencyViewWithYvalue:breaksLine.sh_bottom +5 LeftTitle:@"精品推荐" andRightTitle:@""];
    [headerView addSubview:currency];
    
    
    headerView.sh_height = currency.sh_bottom;
    headerView.sh_x = 0;
    headerView.sh_y = - 99;
    headerView.sh_width = ScreenWidth;
    return headerView;
    
}

#pragma mark - 分享

/**
 * 分享
 */
- (void)shareClick:(NSNotification  *)notification
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"user_Id"];

    if (recordStr != nil)
    {
        self.iconImageStr = notification.userInfo[@"iconImage"];
        self.shopName = notification.userInfo[@"shopName"];
        self.shareStr = notification.userInfo[@"shareStr"];
        self.goodsName = notification.userInfo[@"goodsName"];
        
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine)]];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            
            [self shareWebPageToPlatformType:platformType];
            
        }];
        
    }else
    {
        
        
        
    }
    
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  self.iconImageStr;
  //(@"%@",thumbURL);
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.goodsName descr:self.shopName thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.shareStr;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                
                UMSocialLogInfo(@"response message is %@",resp.message);
                
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}


- (void)alertWithError:(NSError *)error {
    
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"取消分享"];
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
        // result = [NSString stringWithFormat:@"分享失败"];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark 下拉刷新

- (void)pulldownNews
{
    // 点击进入立即刷新
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}



#pragma mark 下来刷新数据
- (void)loadNewData
{
    __weak typeof(self)weakself = self;
    
    self.page = @"1";
    
    [GroupBuyingModel groupBuyingModelsuccess:^(NSMutableArray<GroupBuyingModel *> *groupArray) {
        weakself.groupBuyingArray = groupArray;
    
        
        if (weakself.groupBuyingArray.count >0)
        {
            [weakself removeBackgroundView];
            [weakself.tableView reloadData];
            weakself.tableView.tableHeaderView = [self headView];
            weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [weakself.tableView.mj_header endRefreshing];

            
        }else
        {
            weakself.signal = @"1";
            if (weakself.groupBuyingArray.count >0)
            {
                [weakself.groupBuyingArray removeAllObjects];
                
            }
            [weakself removeBackgroundView];
            [weakself setEmptyView];
            [weakself.tableView reloadData];
            weakself.tableView.tableHeaderView = nil;
            weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [weakself.tableView.mj_header endRefreshing];

    }
        
        
    } error:^{
        
        weakself.signal = @"0";
        if (weakself.groupBuyingArray.count >0)
        {
            [weakself.groupBuyingArray removeAllObjects];
            
        }
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        [weakself.tableView reloadData];
        weakself.tableView.tableHeaderView = nil;
        weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [weakself.tableView.mj_header endRefreshing];

    }];
    
    [self pullUpNews];
    
}

#pragma mark 上啦刷新
- (void)pullUpNews
{
    
    // 设置回调
    self.tableView.mj_footer = [SHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark 上啦刷新加载更多数据
- (void)loadMoreData
{
    
    __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/shop/goodslist"];
    
    
    NSDictionary *dict = @{@"page":self.page};
    
    
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
     //   NSLog(@"%@",responseObject);
        
        NSArray *array = responseObject[@"list"];
        
        
        NSMutableArray *modelArray = [GroupBuyingModel mj_objectArrayWithKeyValuesArray:array];
        
        [self.groupBuyingArray arrayByAddingObjectsFromArray:modelArray];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.signal = @"0";
        if (weakself.groupBuyingArray.count >0)
        {
            [weakself.groupBuyingArray removeAllObjects];
            
        }
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        [weakself.tableView reloadData];
        weakself.tableView.tableHeaderView = nil;
        weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [weakself.tableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)setEmptyView
{
    NSString * showTextStr;
    if ([self.signal isEqualToString:@"1"])
    {
        showTextStr = @"暂无数据!";
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


#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShoppingViewController *shopVc = [[ShoppingViewController alloc] init];
    shopVc.groupGoodsId = self.groupBuyingArray[indexPath.row].id;
    shopVc.page = @"0";
    [self.navigationController pushViewController:shopVc animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groupBuyingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.确定重用标示:
    static NSString *ID = @"cell";
    
    // 2.从缓存池中取
    GroupBuyingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果空就手动创建
    if (!cell) {
        cell = [[GroupBuyingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GroupBuyingModel *model = self.groupBuyingArray[indexPath.row];
    cell.model = model;
    
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

@end
