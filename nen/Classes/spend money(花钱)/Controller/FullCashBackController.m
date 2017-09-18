//
//  AdviserController.m
//  nen
//
//  Created by nenios101 on 2017/3/1.
//  Copyright © 2017年 nen. All rights reserved.
// 全额返现

#import "FullCashBackController.h"

#import "YFRollingLabel.h"
#import "CurrencyView.h"
#import "subscrpitCell.h"
#import "ShoppingViewController.h"
#import "GoodsModel.h"
#import "TheOrderViewController.h"
#import "ShoppingViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>


@interface FullCashBackController ()<UITableViewDelegate,SDCycleScrollViewDelegate>
// 图片轮播器
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

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

@end

@implementation FullCashBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35 , 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.tableHeaderView = nil;
    self.tableView.rowHeight = 180;
    self.page = @"0";
    // 加载数据
    [ShufflingFigureModel shufflingFigureLocation:@"1" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        
        self.shuffingMoldelArray = shufflingFigure;
        
        self.tableView.tableHeaderView = [self headView];
        
        [self.tableView reloadData];
        
    } error:^{
        
        
    }];
    
    [self pulldownNews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareBtnClick:) name:@"share" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyBtnClick:) name:@"buyBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullReturnBtnClick:) name:@"fullReturn" object:nil];
}
//#pragma mark 跳转搜索控制器
//-(void)pushSearchViewControll
//{
//    [self.navigationController pushViewController:[[SearGoodsViewController alloc] init] animated:YES];
//}


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
    NSString *goodsId = notification.userInfo[@"goodsId"];
    TheOrderViewController *theVc = [[TheOrderViewController alloc] init];
    theVc.goodsId = goodsId;
    theVc.goods_num = @"1";
    [self.navigationController pushViewController:theVc animated:NO];
    
}


#pragma mark 点击分享按钮
- (void)shareBtnClick:(NSNotification *)notification
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"user_Id"];
    
    if (recordStr != nil)
    {
        self.shaerUrl = notification.userInfo[@"shareUrl"];
        self.shaerName = notification.userInfo[@"shareName"];
        self.shaerImage = notification.userInfo[@"shareImage"];
        self.shareGoods = notification.userInfo[@"shareGoods"];
        
        // 调用分享方法
        [self shareFullClick];

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
- (void)shareFullClick {
    
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
    __weak UITableView *tableView = self.tableView;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shop/goodslist"];
    
    NSDictionary *dict= @{@"goods_id":@0,@"way":@1};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *dataArray = responseObject[@"list"];
        
        self.goodsArray = [GoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        
        [self.tableView reloadData];
        
        [tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
      //  NSLog(@"%@",error);
        
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%ld",[self.page integerValue] + 1];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shop/goodslist"];
    
    NSDictionary *dict= @{@"goods_id":@0,@"way":@1,@"page":self.page};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        self.page = responseObject[@"result"][@"request_args"][@"page"];
        
     //   NSLog(@"%@",self.page);
        
        NSArray *dataArray = responseObject[@"list"];
        
        NSArray *array = [NSArray array];
        
        array = [GoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        [self.goodsArray addObjectsFromArray:array];
        
        [tableView reloadData];
        [tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
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
    
    
    
    //    // 跑马灯
    UIView *horseRaceLamp = [[UIView  alloc] initWithFrame:CGRectMake(0,200,ScreenWidth , 25)];
    
    //添加文字内容
    NSArray *textArray = @[@"THIS IS THE FIRST TEXT",
                           @"THIS IS THE FIRST TEXTYY"
                           ];
    
    self.horseRaceLampLabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(0,200, self.view.frame.size.width, 25)  textArray:textArray font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    [horseRaceLamp addSubview:self.horseRaceLampLabel];
    self.horseRaceLampLabel.backgroundColor = [UIColor orangeColor];
    self.horseRaceLampLabel.speed = 2;
    [self.horseRaceLampLabel setOrientation:RollingOrientationLeft];
    [self.horseRaceLampLabel setInternalWidth:self.horseRaceLampLabel.frame.size.width / 3];;
    
    // 获取文字点击文字点击
    self.horseRaceLampLabel.labelClickBlock = ^(NSInteger index){
        NSString *text = [textArray objectAtIndex:index];
       // NSLog(@"You Tapped item:%li , and the text is %@",(long)index,text);
    };
    [headerView addSubview:self.horseRaceLampLabel];
    
    
    // 底部图片
    UIView *buttonImage = [[UIView alloc] initWithFrame:CGRectMake(0,self.horseRaceLampLabel.sh_bottom,[UIScreen mainScreen].bounds.size.width,80)];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.sh_x = 10;
    leftImageView.sh_height = buttonImage.sh_height;
    leftImageView.sh_y = 0;
    leftImageView.sh_width = ScreenWidth *0.4;
    leftImageView.image = [UIImage imageNamed:@"car1"];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.sh_width = ScreenWidth * 0.5;
    rightImageView.sh_x = (ScreenWidth * 0.5) - 10;
    rightImageView.sh_height = buttonImage.sh_height;
    rightImageView.image = [UIImage imageNamed:@"car1"];
    
    [buttonImage addSubview:leftImageView];
    [buttonImage addSubview:rightImageView];
    
    [headerView addSubview:buttonImage];
    
    CurrencyView *currency = [CurrencyView currencyViewWithYvalue:buttonImage.sh_bottom LeftTitle:@"精品推荐" andRightTitle:@""];
    
    [headerView addSubview:currency];
    
    headerView.sh_height = 325;
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
    shop.goodsIdItem = goodsModel.id;
    [self.navigationController pushViewController:shop animated:YES];
    
}



//-(void)returnGoodsId:(goodsBlock)block
//{
//    self.rentunGoodsId = block;
//}

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
    
    cell.goodsModel = goods;
    
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
