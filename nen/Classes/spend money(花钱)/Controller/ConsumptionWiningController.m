//
//  SubscriptionController.m
//  nen
//
//  Created by nenios101 on 2017/3/1.
//  Copyright © 2017年 nen. All rights reserved.
// 消费中奖区

#import "ConsumptionWiningController.h"
#import "YFRollingLabel.h"
#import "CurrencyView.h"
#import "subscrpitCell.h"
#import "ShoppingViewController.h"
#import "GoodsModel.h"
#import "TheOrderViewController.h"
#import "ShoppingViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "InfoturnModel.h"


@interface ConsumptionWiningController ()<UITableViewDelegate,SDCycleScrollViewDelegate>
// 图片轮播器
//@property (nonatomic, strong) JZLCycleView *headPictureCarouselView;

// 跑马灯文本
@property (nonatomic, strong) YFRollingLabel *horseRaceLampLabel;

@property(nonatomic,strong) NSArray *shuffingMoldelArray;
// 商品数据
@property(nonatomic,strong) NSMutableArray<GoodsModel*> *goodsArray;

@property(nonatomic,weak) UIImageView *imageView;

@property(nonatomic,copy) NSString *goodsId;
// 加载更多页码
@property(nonatomic,copy) NSString * page;
// 分享商品url
@property(nonatomic,copy) NSString *shaerUrl;
@property(nonatomic,copy) NSString *shaerImage;
@property(nonatomic,copy) NSString *shaerName;
@property(nonatomic,copy) NSString *shareGoods;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;
@property(nonatomic,copy) NSString *signal;

@property(nonatomic,strong) NSArray <InfoturnModel *> *InfoturnArray;

@end

@implementation ConsumptionWiningController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,113, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = 180;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 加载数据
    [ShufflingFigureModel shufflingFigureLocation:@"1" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        
        self.shuffingMoldelArray = shufflingFigure;
        
        [self loadData];
        
        [self pulldownNews];
        
    } error:^{
        self.signal = @"0";
        [self removeBackgroundView];
        [self setEmptyView];
    }];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareBtnClick:) name:@"share" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyBtnClick:) name:@"buyBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullReturnBtnClick:) name:@"fullReturn" object:nil];
}

#pragma mark 跑马灯数据
- (void)loadData
{
    
    [InfoturnModel InfoturnModelLocation:@1 Success:^(NSArray<InfoturnModel *> *InfoturnArray) {
        
        self.InfoturnArray = InfoturnArray;
        
        self.tableView.tableHeaderView = [self headView];
        
        [self.tableView reloadData];
        
    } error:^{
     //   NSLog(@"失败");
    }];
    
}



#pragma mark 全额返现按钮
- (void)fullReturnBtnClick:(NSNotification *)notification
{
    NSString *goodsId = notification.userInfo[@"goodsId"];
    ShoppingViewController *shoppingVc = [[ShoppingViewController alloc] init];
    shoppingVc.goodsIdItem = goodsId;
    [self.navigationController pushViewController:shoppingVc animated:NO];
}


#pragma mark 立即购买按钮
- (void)buyBtnClick:(NSNotification *)notification
{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        NSString *goodsId = notification.userInfo[@"goodsId"];
        TheOrderViewController *theVc = [[TheOrderViewController alloc] init];
        theVc.goodsId = goodsId;
        theVc.goods_num = @"1";
        [self.navigationController pushViewController:theVc animated:NO];
    }
    else
    {
        HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"需要登录后" andMessage:nil];
        [alertView addButtonWithTitle:@"登录" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
        [self.navigationController pushViewController:[LoginAndRegisterViewController sharedManager] animated:YES];
            
        }];
        
        [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
        }];
        
        [alertView show];
        
    }

}


#pragma mark 点击分享按钮
- (void)shareBtnClick:(NSNotification *)notification
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        self.shaerUrl = notification.userInfo[@"shareUrl"];
        self.shaerName = notification.userInfo[@"shareName"];
        self.shaerImage = notification.userInfo[@"shareImage"];
        self.shareGoods = notification.userInfo[@"shareGoods"];
        
        // 调用分享方法
        [self shareClick];
        
    }
    else
    {
        HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"需要登录后" andMessage:nil];
        [alertView addButtonWithTitle:@"登录" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
            [self.navigationController pushViewController:[LoginAndRegisterViewController sharedManager] animated:YES];
            
        }];
        
        [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
        }];
        
        [alertView show];
        
    }
}


#pragma mark - UMSocialUIDelegate

/**
 * 分享
 */
- (void)shareClick {
    
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
    NSString* thumbURL =  self.shaerImage;
   // NSLog(@"%@",thumbURL);
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareGoods descr:self.shaerName thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.shaerUrl;
    
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
    __weak typeof(self)weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shop/goodslist"];
    
    NSDictionary *dict= @{@"page":self.page,@"pagesize":@"8",@"is_boutique":@"1",@"back_type":@"1"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *coder = responseObject[@"result"][@"resultCode"];
        
        
        if ([coder isEqualToString:@"0"])
        {
            NSArray *dataArray = responseObject[@"list"];
            
            if (dataArray == nil)
            {
                [JKAlert alertText:@"花钱页面数据错误"];
                return;
            }
            
            
            self.goodsArray = [GoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            
            if (self.goodsArray.count >0)
            {
                
                [weakself removeBackgroundView];
                [weakself.tableView reloadData];
                weakself.tableView.tableHeaderView = [self headView];
                weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                [weakself.tableView.mj_header endRefreshing];
                
                
            }else
            {
                weakself.signal = @"1";
                if (weakself.goodsArray.count >0)
                {
                    [weakself.goodsArray removeAllObjects];
                    
                }
                [weakself.tableView reloadData];
                [weakself removeBackgroundView];
                [weakself setEmptyView];
                weakself.tableView.tableHeaderView = nil;
                weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                [weakself.tableView.mj_header endRefreshing];
            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.signal = @"0";
        if (weakself.goodsArray.count >0)
        {
            [weakself.goodsArray removeAllObjects];
            
        }
        [weakself.tableView reloadData];
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        weakself.tableView.tableHeaderView = nil;
        weakself.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    __weak typeof(self)weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shop/goodslist"];
    
    NSDictionary *dict= @{@"page":self.page,@"pagesize":@"8",@"is_boutique":@"1",@"back_type":@"1"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *coder = responseObject[@"result"][@"resultCode"];
        if ([coder isEqualToString:@"0"])
        {
           // self.page = responseObject[@"result"][@"request_args"][@"page"];
            
            //   NSLog(@"%@",self.page);
            
            NSArray *dataArray = responseObject[@"list"];
            
            if (dataArray == nil)
            {
                [JKAlert alertText:@"花钱页面上拉刷新数据错误"];
                return ;
            }
            
            NSArray *array = [NSArray array];
            
            array = [GoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            [self.goodsArray addObjectsFromArray:array];
            
            [tableView reloadData];
            [tableView.mj_footer endRefreshing];
        }


    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        weakself.signal = @"0";
        if (weakself.goodsArray.count >0)
        {
            [weakself.goodsArray removeAllObjects];
            
        }
        [weakself.tableView reloadData];
        [weakself removeBackgroundView];
        [weakself setEmptyView];
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



#pragma mark 图片轮播器数组
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}



// 返回tableView头部

- (UIView *)headView
{
    UIView *headerView = [[UIView alloc] init];
    // 图片轮播器
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    NSMutableArray *arrTemp = [NSMutableArray array];
    
    [self.shuffingMoldelArray enumerateObjectsUsingBlock:^(ShufflingFigureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrTemp addObject:obj.img_url];
    }];
    
    cycleScrollView.imageURLStringsGroup = arrTemp;
    
    [headerView addSubview:cycleScrollView];
    
    
    
//    //    // 跑马灯
//    UIView *horseRaceLamp = [[UIView  alloc] initWithFrame:CGRectMake(0,200,ScreenWidth , 35)];
    
    //添加文字内容
    
    NSMutableArray *textArray = [NSMutableArray array];
    
    
    for (int i = 0;i < self.InfoturnArray.count; i++)
    {
        
        [textArray addObject:self.InfoturnArray[i].content];
        
    }
    
    self.horseRaceLampLabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(0,cycleScrollView.sh_bottom + 5, self.view.frame.size.width, 35)  textArray:textArray font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor]];
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
//    
    
    
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
#pragma mark 图片轮播器代理方法

- (void)selectItemAtIndex:(NSInteger)index
{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel *goodsModel = self.goodsArray[indexPath.row];
    self.goodsId = goodsModel.id;
  
    ShoppingViewController *shop = [[ShoppingViewController alloc] init];
    shop.goodsIdItem = [NSString stringWithFormat:@"%@",goodsModel.id];
    shop.page = @"1";
    [self.navigationController pushViewController:shop animated:YES];
    
}

-(void)returnGoodsId:(goodsBlock)block
{
    self.rentunGoodsId = block;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.确定重用标示:
    static NSString *ID = @"cell";
    
    subscrpitCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"subscrpitCell" owner:nil options:nil] lastObject];
        
    }
    
    GoodsModel *goods = self.goodsArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodsModel = goods;
    
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _imageView.image = [UIImage imageNamed:@"placeholderImage"];
    _imageView.frame = CGRectMake(0, 0, ScreenWidth,200);
    self.navigationController.navigationBarHidden = NO;
    
    
    [self.tableView reloadData];
    
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
