//
//  WarehouseViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/9.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "WarehouseViewController.h"
#import "CommodityManagementModel.h"
#import "WarehouseCentreCell.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

#import "ReleaseGoodsViewController.h"
@interface WarehouseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray<CommodityManagementModel *> *goodsArray;

@property(nonatomic,copy) NSString *page;

@property(nonatomic,strong) CommodityManagementModel *sharCommodModel;

@property(nonatomic,copy) NSString *signal;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@end

@implementation WarehouseViewController

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
    self.page = @"1";
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upFrameBntClcik:) name:@"upFrame" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upFrameShareBtnClcick:) name:@"upFrameShare" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClcick:) name:@"delete" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editorGoodsBtnClcick:) name:@"editorGoods" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self pulldownNews];
    
    
}

#pragma mark 编辑
- (void)editorGoodsBtnClcick:(NSNotification *)notification
{
    NSString * goodsId = notification.userInfo[@"goodsId"];
    
    ReleaseGoodsViewController *releaseVc = [[ReleaseGoodsViewController alloc] init];
    
    releaseVc.goodsId = goodsId;
    
    [self.navigationController pushViewController: releaseVc animated:YES];
    
}

#pragma mark 上架
- (void)upFrameBntClcik:(NSNotification *)notification
{
    __weak typeof(self) weakself = self;
    NSString * goodsId = notification.userInfo[@"goodsId"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/shelf"];
    
    NSDictionary *dict = @{@"goods_id":goodsId,@"is_shelf":@"1"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        

        
        for (int i = 0;i < weakself.goodsArray.count;i++ )
        {
            if ([goodsId isEqualToString:weakself.goodsArray[i].id])
            {
              [weakself.goodsArray removeObjectAtIndex:i];
              [weakself.tableView reloadData];
            }
        }
     
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}
#pragma mark 删除
- (void)deleteBtnClcick:(NSNotification *)notification
{
    NSString *goodsId = notification.userInfo[@"goodsId"];
    
    // 标题
   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除商品!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 暂不
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //NSLog(@"暂不");
    }];
    [alert addAction:cancelAction];
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    // 删除
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self deleteApiGoodsId:goodsId];
    }];
    
    [defaultAction setValue:[UIColor orangeColor] forKey:@"_titleTextColor"];
    [alert addAction:defaultAction];
    
    
    [self presentViewController:alert animated:NO completion:nil];
}




#pragma mark 删除商品
- (void)deleteApiGoodsId:(NSString *)goodsId
{
 
    __weak typeof(self) weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/deletegoods"];
    
    NSDictionary *dict = @{@"id":goodsId};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        for (int i = 0;i < weakself.goodsArray.count;i++ )
        {
            if ([goodsId isEqualToString:weakself.goodsArray[i].id])
            {
                [weakself.goodsArray removeObjectAtIndex:i];
                [weakself.tableView reloadData];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [JKAlert alertText:@"删除商品出错"];
        
    }];

    
}





#pragma mark 分享
- (void)upFrameShareBtnClcick:(NSNotification *)notification
{
    self.sharCommodModel = notification.userInfo[@"goodsModel"];
    
    [self wareShareClick];
    
}

/**
 * 分享
 */
- (void)wareShareClick {
    
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.sharCommodModel.goods_name descr:nil thumImage:thumbURL];
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
    __weak typeof(self) weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/goodsmanage"];
    
    NSDictionary *dict = @{@"page":@"1",@"pagesize":@"8",@"is_shelf":@"0"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //NSLog(@"%@",responseObject);
        
        NSArray *dataArray = responseObject[@"list"];
        
        NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        if ([coder isEqualToString:@"0"])
        {
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
    
    NSDictionary *dict = @{@"page":self.page,@"pagesize":@"8",@"is_shelf":@"0"};
    
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

#pragma mark tableViewDetegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    WarehouseCentreCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell)
    {
        cell = [[WarehouseCentreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
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
