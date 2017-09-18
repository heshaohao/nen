//
//  ClassificationOfMoreViewController.m
//  nen
//
//  Created by nenios101 on 2017/5/2.
//  Copyright © 2017年 nen. All rights reserved.
//首页更多商品分类控制器

#import "ClassificationOfMoreViewController.h"
#import "ClassificationOfMoreCell.h"
#import "ShopGoodsListModel.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "TheOrderViewController.h"
#import "ShoppingViewController.h"

@interface ClassificationOfMoreViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray <ShopGoodsListModel *> *shopModelArray;

@property(nonatomic,strong) UITableView *tableVc;

@property(nonatomic,copy) NSString *page;

@property(nonatomic,copy) NSString *goodsName;

@property(nonatomic,copy) NSString *shopName;

@property(nonatomic,copy) NSString *iconImageStr;

@property(nonatomic,copy) NSString *shareStr;

@property (nonatomic,strong) NSUserDefaults *defaluts;

@property (nonatomic,copy) NSString *recordStr;

@end

@implementation ClassificationOfMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor oldLace];
    
    _defaluts = [NSUserDefaults standardUserDefaults];
    
    UITableView *tableV = [[UITableView  alloc] init];
    self.tableVc = tableV;
    tableV.frame  =CGRectMake(0,0,ScreenWidth,ScreenHeight);
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.delegate = self;
    tableV.rowHeight = 150;
    tableV.dataSource = self;
    [self.view addSubview:tableV];
    
    self.page = @"1";
    
    
    if (!self.classGoodsId)
    {
        self.classGoodsId = @"0";
    }
    
    [self pulldownNews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cationShareClick:) name:@"shareBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyBtn:) name:@"pushBuyVc" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullBtn:) name:@"pushShopVc" object:nil];
}


#pragma mark - 全额返现
- (void)fullBtn:(NSNotification *)notification
{
    NSString *goodsId = notification.userInfo[@"goodsId"];
    
    [self pushShopViewControllGoodsId:goodsId AndPage:@"1"];
    
}


#pragma mark 跳转到商品详情页面
- (void)pushShopViewControllGoodsId:(NSString *)goodsId AndPage:(NSString *)page
{
    
    ShoppingViewController *shopVc = [[ShoppingViewController alloc] init];
    shopVc.goodsIdItem = goodsId;
    shopVc.page =page;
    [self.navigationController pushViewController:shopVc animated:YES];

}


#pragma mark - 立即购买
- (void)buyBtn:(NSNotification *)notification
{
    self.recordStr = [_defaluts objectForKey:@"is_login"];
    
    if ([self.recordStr isEqualToString:@"1"])
    {
        NSString *goodsId = notification.userInfo[@"goodsId"];
        
        TheOrderViewController *theOrderVc = [[TheOrderViewController alloc] init];
        theOrderVc.goodsId = goodsId;
        theOrderVc.goods_num = @"1";
        
        [self.navigationController pushViewController:theOrderVc animated:YES];
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

#pragma mark - 分享

/**
 * 分享
 */
- (void)cationShareClick:(NSNotification  *)notification
{
   
    self.recordStr = [_defaluts objectForKey:@"is_login"];
    
    if ([self.recordStr isEqualToString:@"1"])
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
        HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"需要登录账号才可以使用" andMessage:nil];
        [alertView addButtonWithTitle:@"登录" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
            [self.navigationController pushViewController:[LoginAndRegisterViewController sharedManager] animated:YES];
            
        }];
        
        [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
        }];
        
        [alertView show];
        
    }

}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  self.iconImageStr;
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
    self.tableVc.mj_header = [SHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableVc.mj_header beginRefreshing];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareClcik:) name:@"shareBtn" object:nil];
}

- (void)shareClcik:(NSNotification *)notification
{
    
}

#pragma mark 下来刷新数据
- (void)loadNewData
{
    [ShopGoodsListModel shopGoodsproductListGoodsId:self.classGoodsId Page:self.page GoodsName:nil success:^(NSMutableArray<ShopGoodsListModel *> *goodsList) {
        
        self.shopModelArray = goodsList;
        [self.tableVc reloadData];
        [self.tableVc.mj_header endRefreshing];
        
    } error:^{
       // NSLog(@"错误");
         [self.tableVc.mj_header endRefreshing];
    }];
    
    

 [self pullUpNews];
    
}

#pragma mark 上啦刷新
- (void)pullUpNews
{
    
    // 设置回调
    self.tableVc.mj_footer = [SHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark 上啦刷新加载更多数据
- (void)loadMoreData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%ld",[self.page integerValue] + 1];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/shop/goodslist"];
    
    
    NSDictionary *dict;
    
    if ([self.classGoodsId isEqualToString:@"0"])
    {
        
        dict = @{@"category_id":@0,@"page":self.page,@"pagesize":@"8",@"is_boutique":@"1",@"is_recommend":@"1"};
    }else
    {
        NSInteger idNumber = [self.classGoodsId integerValue];
        
        dict = @{@"category_id":@(idNumber),@"page":self.page,@"pagesize":@"8"};
    }
    
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = responseObject[@"list"];
        
        
        NSMutableArray *modelArray = [ShopGoodsListModel mj_objectArrayWithKeyValuesArray:array];
  
        [self.shopModelArray arrayByAddingObjectsFromArray:modelArray];
      
            [self.tableVc reloadData];
            [self.tableVc.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
      
    }];

    
}


#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopGoodsListModel *model = self.shopModelArray[indexPath.row];
    
    
   
    [self pushShopViewControllGoodsId:model.id AndPage:@"1"];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    
    ClassificationOfMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell = [[ClassificationOfMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    ShopGoodsListModel *model = self.shopModelArray[indexPath.row];
    
    cell.model = model;
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
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

@end
