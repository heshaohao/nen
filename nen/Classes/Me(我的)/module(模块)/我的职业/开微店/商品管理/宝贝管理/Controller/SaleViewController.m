//
//  SaleViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/9.
//  Copyright © 2017年 nen. All rights reserved.
//出售中


#import "SaleViewController.h"
#import "CommodityManagementModel.h"
#import "CommodityManagementCell.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@interface SaleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray<CommodityManagementModel *> *goodsArray;

@property(nonatomic,copy) NSString *page;


@property(nonatomic,strong) CommodityManagementModel *sharCommodModel;

@property(nonatomic,copy) NSString *signal;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;
@end

@implementation SaleViewController

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
    
    
    [self setNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tabelV = [[UITableView alloc] init];
    self.tableView = tabelV;
    tabelV.frame = CGRectMake(0,104, ScreenWidth, ScreenHeight - 143);
    tabelV.delegate = self;
    tabelV.dataSource = self;
    tabelV.showsVerticalScrollIndicator = NO;
    tabelV.showsHorizontalScrollIndicator = NO;
    tabelV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabelV.rowHeight = 150;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shelvesBtnClcick:) name:@"shelves" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sellShareBtnClcick:) name:@"sellShare" object:nil];
    
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"出售中";
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



#pragma mark 商品下架
- (void)shelvesBtnClcick:(NSNotification *)notification
{
    __weak typeof(self) weakself = self;
    NSString * goodsId = notification.userInfo[@"goodsId"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/shelf"];
    
    NSDictionary *dict = @{@"goods_id":goodsId,@"is_shelf":@"0"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        if ([coder isEqualToString:@"0"])
        {
            for (int i = 0;i < weakself.goodsArray.count;i++ )
            {
                if ([goodsId isEqualToString:weakself.goodsArray[i].id])
                {
                    [weakself.goodsArray removeObjectAtIndex:i];
                    [weakself.tableView reloadData];
                }
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [JKAlert alertText:@"商品下出错"];
        
    }];
}


#pragma mark 分享
- (void)sellShareBtnClcick:(NSNotification *)notification
{
    self.sharCommodModel = notification.userInfo[@"goodsModel"];
    
    [self sellShareClick];
    

}

/**
 * 分享
 */
- (void)sellShareClick {
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        [self shareWebPageToPlatformType:platformType];
    }];
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  self.sharCommodModel.goods_img;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.sharCommodModel.goods_name descr:@"sdd" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.sharCommodModel.share_url;
    
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

#pragma mark 下来刷新
- (void)loadNewData
{
    [self pullUpNews];
    self.page = @"1";
    __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/goodsmanage"];
    
    NSDictionary *dict = @{@"page":@"1",@"pagesize":@"8",@"is_shelf":@"1"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
              
        NSArray *dataArray = responseObject[@"list"];
        
        self.goodsArray = [CommodityManagementModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (weakself.goodsArray.count >0)
        {
            [weakself removeBackgroundView];
            [weakself.tableView reloadData];
           
            [weakself.tableView.mj_header endRefreshing];
        }else
        {
     
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
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/goodsmanage"];
    
    NSDictionary *dict = @{@"page":self.page,@"pagesize":@"8",@"is_shelf":@"1"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        weakself.page = responseObject[@"result"][@"request_args"][@"page"];
        
        NSArray *dataArray = responseObject[@"list"];
        
        NSArray *array = [NSArray array];
        
        array = [CommodityManagementModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        [weakself.goodsArray addObjectsFromArray:array];
        
        [tableView reloadData];
        
        [tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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

#pragma mark 没有数据提示图

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
    _backgroundView = [[ThereIsNoDataBackgroundView alloc] initWithThereIsNoDataBackgroundViewImageIcon:KNoDataBackgroundImage ImageX:ScreenWidth*0.25 ImageY:ScreenHeight *0.25 ImageW:ScreenWidth *0.5 imageH:ScreenWidth *0.5 ShowBottomText:showTextStr];
    [self.tableView addSubview:_backgroundView];
    
}


#pragma mark 移除backgroundView
- (void)removeBackgroundView
{
    [_backgroundView removeFromSuperview];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    CommodityManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell)
    {
        cell = [[CommodityManagementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    cell.model = self.goodsArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

