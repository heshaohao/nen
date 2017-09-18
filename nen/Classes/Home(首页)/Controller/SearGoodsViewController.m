//
//  SearGoodsViewController.m
//  nen
//
//  Created by apple on 17/5/17.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SearGoodsViewController.h"
#import "SearchGoodsViewCell.h"
#import "ShopGoodsListModel.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "TheOrderViewController.h"
#import "ShoppingViewController.h"

@interface SearGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,copy) NSString *page;
@property(nonatomic,strong) UITextField *searcgTextField;

@property(nonatomic,strong) NSMutableArray <ShopGoodsListModel *> *shopModelArray;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIView *backgroundView;

@property(nonatomic,copy) NSString *goodsName;

@property(nonatomic,copy) NSString *shopName;

@property(nonatomic,copy) NSString *iconImageStr;

@property(nonatomic,copy) NSString *shareStr;

@property (nonatomic,strong) NSUserDefaults *defaluts;

@property (nonatomic,copy) NSString *recordStr;


@end

@implementation SearGoodsViewController

- (NSMutableArray *)shopModelArray
{
    if (!_shopModelArray)
    {
        _shopModelArray = [NSMutableArray array];
    }
    return _shopModelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _defaluts = [NSUserDefaults standardUserDefaults];
    
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0,64,ScreenWidth,50);
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *searchTitle = [[UILabel alloc] init];
    searchTitle.text= @"搜索指定类型:";
    searchTitle.textColor =[UIColor lightGrayColor];
    searchTitle.font = [UIFont systemFontOfSize:13];
    searchTitle.frame = CGRectMake(0,5,ScreenWidth *0.3,20);
    searchTitle.textAlignment = NSTextAlignmentRight;
    [headView addSubview:searchTitle];
    
    UILabel *goodsTitle = [[UILabel alloc] init];
    goodsTitle.text= @"商品";
    goodsTitle.textColor =[UIColor blackColor];
    goodsTitle.font = [UIFont systemFontOfSize:13];
    goodsTitle.frame = CGRectMake(0,30,ScreenWidth,20);
    goodsTitle.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:goodsTitle];
    
    
//    UIView *linView1 = [[UIView alloc] init];
//    linView1.frame = CGRectMake(goodsTitle.sh_right,goodsTitle.sh_y + 4,2, 12);
//    linView1.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:29.0/255.0 alpha:1];
//    [headView addSubview:linView1];
//    
//    
//    UILabel *shopTitle = [[UILabel alloc] init];
//    shopTitle.text= @"商家";
//    shopTitle.textColor =[UIColor blackColor];
//    shopTitle.font = [UIFont systemFontOfSize:13];
//    shopTitle.frame = CGRectMake(linView1.sh_right,30,(ScreenWidth *0.5) - 1,20);
//    shopTitle.textAlignment = NSTextAlignmentCenter;
//    [headView addSubview:shopTitle];
    
//    UIView *linView2 = [[UIView alloc] init];
//    linView2.frame = CGRectMake(shopTitle.sh_right,linView1.sh_y,1, 12);
//    linView2.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:29.0/255.0 alpha:1];
//    [headView addSubview:linView2];
//    
//    UILabel *consultantTitle = [[UILabel alloc] init];
//    consultantTitle.text= @"顾问";
//    consultantTitle.textColor =[UIColor blackColor];
//    consultantTitle.font = [UIFont systemFontOfSize:13];
//    consultantTitle.frame = CGRectMake(linView2.sh_right,30,ScreenWidth *0.2 - 1,20);
//    consultantTitle.textAlignment = NSTextAlignmentCenter;
//    [headView addSubview:consultantTitle];
//
//    UIView *linView3 = [[UIView alloc] init];
//    linView3.frame = CGRectMake(consultantTitle.sh_right,linView1.sh_y,1, 12);
//    linView3.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:29.0/255.0 alpha:1];
//    [headView addSubview:linView3];
//
//    UILabel *tutoringTitle = [[UILabel alloc] init];
//    tutoringTitle.text= @"家教";
//    tutoringTitle.textColor =[UIColor blackColor];
//    tutoringTitle.font = [UIFont systemFontOfSize:13];
//    tutoringTitle.frame = CGRectMake(linView3.sh_right,30,ScreenWidth *0.3 - 1,20);
//    tutoringTitle.textAlignment = NSTextAlignmentCenter;
//    [headView addSubview:tutoringTitle];
    
    [self.view addSubview:headView];
   
    UITableView *tabelV = [[UITableView alloc] init];
    self.tableView = tabelV;
    tabelV.delegate = self;
    tabelV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabelV.dataSource = self;
    tabelV.rowHeight = 150;
    tabelV.frame = CGRectMake(0,headView.sh_bottom,ScreenWidth,ScreenHeight - 114);
    [self.view addSubview:tabelV];
    
    [self setNavView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searShareClick:) name:@"shareBtns" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyBtn:) name:@"pushBuyVcs" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullBtn:) name:@"pushShopVcs" object:nil];
    
    [self pulldownNews];
    
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
- (void)searShareClick:(NSNotification  *)notification
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


#pragma mark 设置导航栏
- (void)setNavView
{
    UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0,0,30,20)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0,0,20,20);
    [rightBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
   // [rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_02"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"🔍" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightVeiw addSubview:rightBtn];
    
    CGRect mainViewBounds = self.navigationController.view.bounds;
    UITextField *searTextField = [[UITextField alloc] init];
    self.searcgTextField = searTextField;
    searTextField.placeholder  = @"   搜商品";
    searTextField.textAlignment = NSTextAlignmentCenter;
    searTextField.delegate = self;
    searTextField.layer.cornerRadius = 5;
    searTextField.clipsToBounds = YES;
    searTextField.frame = CGRectMake(ScreenWidth/2-((ScreenWidth)/2), CGRectGetMinY(mainViewBounds)+20,ScreenWidth *0.8, 25);
    searTextField.backgroundColor = [UIColor whiteColor];
    searTextField.font = [UIFont systemFontOfSize: 13];
    searTextField.rightView =rightVeiw;
    searTextField.rightViewMode = UITextFieldViewModeAlways;
    self.navigationItem.titleView = searTextField;

}


#pragma mark -----------刷新控件-------------

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
    
   // NSLog(@"%@",self.searcgTextField.text);
    [ShopGoodsListModel shopGoodsproductListGoodsId:nil Page:@"1"GoodsName:self.searcgTextField.text success:^(NSMutableArray<ShopGoodsListModel *> *goodsList) {
        
        weakself.shopModelArray = goodsList;
        
        if (weakself.shopModelArray.count > 0)
        {
            [self removeBackgroundView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header  endRefreshing];
            
        }else
        {
            [weakself removeBackgroundView];
            [weakself setEmptyView];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header  endRefreshing];
            
        }
    } error:^{
        [weakself.tableView.mj_footer  endRefreshing];
        
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
    __weak typeof(self)weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/shop/goodslist"];
    
    
    NSDictionary *dict = @{@"page":self.page,@"pagesize":@"8",@"is_boutique":@"0",@"goods_name":self.searcgTextField.text};
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSArray *array = responseObject[@"list"];
        
        NSMutableArray <ShopGoodsListModel *>*modelArray = [NSMutableArray array];
        
       modelArray = [ShopGoodsListModel mj_objectArrayWithKeyValuesArray:array];
        
        weakself.shopModelArray = (NSMutableArray *)[weakself.shopModelArray arrayByAddingObjectsFromArray:modelArray];
    
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [weakself.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark 导航栏翻回
-(void)goBackAction{
         
// 在这里增加返回按钮的自定义动作
[self.navigationController popViewControllerAnimated:YES];
         
}

// 滑动的时候 searchBar 回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searcgTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
     [self pulldownNews];
    [self.searcgTextField resignFirstResponder];
    
        
    return YES;
}

#pragma mark 搜索框右边搜索按钮

- (void)searchBtnClick
{
    
    //    if (self.searcgTextField.text.length > 0)
    //    {
    [self.searcgTextField resignFirstResponder];
    [self pulldownNews];
    
    //  }
    
}


#pragma mark 没有数据时显示
- (void)setEmptyView
{
    //默认视图背景
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight - 249)];
    _backgroundView.tag = 100;
    [self.tableView addSubview:_backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Snip"]];
    img.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [_backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.frame = CGRectMake(ScreenWidth *0.5 - 40 ,img.sh_bottom + 10,80,35);
    warnLabel.text = @"暂无数据!";
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = LZColorFromHex(0x706F6F);
    [_backgroundView addSubview:warnLabel];
}

#pragma mark 移除backgroundView
- (void)removeBackgroundView
{
    [_backgroundView removeFromSuperview];
}


#pragma mark ----------tableViewDelegate--------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    
    SearchGoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell = [[SearchGoodsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    ShopGoodsListModel *model = self.shopModelArray[indexPath.row];
    
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    [self.searcgTextField resignFirstResponder];
    ShopGoodsListModel *model = self.shopModelArray[indexPath.row];
    
    [self pushShopViewControllGoodsId:model.id AndPage:@"0"];
    
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
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searcgTextField resignFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
