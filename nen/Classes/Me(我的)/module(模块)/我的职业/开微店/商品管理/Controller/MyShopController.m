//
//  MyShopController.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
//底部控制器

#import "MyShopController.h"
#import "HeadView.h"
#import "SHTitleButton.h"
#import "ShopHomeController.h"
#import "AllController.h"
#import "NesController.h"
#import "BottomView.h"
#import "GoodsManagementViewController.h"
#import "ShopIntroduceController.h"
#import "ShopmanageModel.h"
#import "BabyClassificationManagementViewController.h"
@interface MyShopController ()<UIScrollViewDelegate>

@property(nonatomic,strong) HeadView *headView;

/** 当前选中的标题按钮 */
@property (nonatomic, weak) SHTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;

@property(nonatomic,strong) ShopmanageModel *shopModel;

// 商家信息
@property(nonatomic,strong) NSDictionary *shopDict;

@property(nonatomic,copy) NSString *shopId;

@property(nonatomic,assign) NSInteger page;


@end

@implementation MyShopController

//+ (MyShopController *)MyShopManager
//{
//    static MyShopController *shopManager = nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        shopManager = [[self alloc] init];
//    });
//  return shopManager;
//    
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    if (self.shopDetailed_Id.length == 0)
    {
        [self loadData];
        
    }else
    {
        [self shopLodaData];
    }
    
  self.view.backgroundColor = [UIColor whiteColor];
        
    [ShopmanageModel ShopmanageModelsuccess:^(ShopmanageModel *shopmanageModel) {
            
            self.shopModel = shopmanageModel;
            
            [self.view addSubview:_headView];
            
//            [self setupNav];
//            
//            [self setupChildViewControllers];
//            
//            [self setupScrollView];
//            
//            [self setupTitlesView];
//            
//            [self addHeadView];
            
        
        } error:^{
            
            NSLog(@"失败");
        }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyBtn) name:@"baby" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(introfuceBtn) name:@"introfuce" object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callPhone) name:@"buyerPhone" object:nil];
    
}


#pragma mark  添加底部View
- (void)addBottomView
{
    if (self.shopDetailed_Id.length == 0)
    {
        BottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:nil options:nil] lastObject];
        
        bottomView.frame = CGRectMake(0,ScreenHeight - 50,ScreenWidth,50);
        
        [self.view addSubview:bottomView];
        
    }else
    {
        
        UIView *detailedBottomView = [[UIView alloc] init];
        detailedBottomView.backgroundColor = [UIColor colorWithHexString:@"#c7c7c7"];
        detailedBottomView.frame = CGRectMake(0,ScreenHeight - 50,ScreenWidth,50);
        [self.view addSubview:detailedBottomView];
        
        
        CGFloat btnW = (ScreenWidth - 3)/4;
        UIButton *classificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [classificationBtn setTitle:@"宝贝分类" forState:UIControlStateNormal];
        classificationBtn.frame = CGRectMake(0,0,btnW,50);
        [classificationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [classificationBtn addTarget:self action:@selector(babyClassification) forControlEvents:UIControlEventTouchUpInside];
        [detailedBottomView addSubview:classificationBtn];
        
        UIView *oneCutLine = [[UIView alloc] init];
        oneCutLine.frame = CGRectMake(classificationBtn.sh_right,5,1,40);
        oneCutLine.backgroundColor = [UIColor blackColor];
        [detailedBottomView addSubview:oneCutLine];
        
        UIButton *shopIsintroducedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shopIsintroducedBtn setTitle:@"店铺介绍" forState:UIControlStateNormal];
        shopIsintroducedBtn.frame = CGRectMake(oneCutLine.sh_right,0,btnW,50);
        [shopIsintroducedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [shopIsintroducedBtn addTarget:self action:@selector(shopIsintroduced) forControlEvents:UIControlEventTouchUpInside];
        [detailedBottomView addSubview:shopIsintroducedBtn];
        
        UIView *twoCutLine = [[UIView alloc] init];
        twoCutLine.frame = CGRectMake(shopIsintroducedBtn.sh_right,5,1,40);
        twoCutLine.backgroundColor = [UIColor blackColor];
        [detailedBottomView addSubview:twoCutLine];
        
        
        UIButton *contactTheSellerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contactTheSellerBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        contactTheSellerBtn.frame = CGRectMake(twoCutLine.sh_right,0,btnW,50);
        [contactTheSellerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contactTheSellerBtn addTarget:self action:@selector(contactTheSellerBtn) forControlEvents:UIControlEventTouchUpInside];
        [detailedBottomView addSubview:contactTheSellerBtn];
        
        UIView *threeCutLine = [[UIView alloc] init];
        threeCutLine.frame = CGRectMake(contactTheSellerBtn.sh_right,5,1,40);
        threeCutLine.backgroundColor = [UIColor blackColor];
        [detailedBottomView addSubview:threeCutLine];
        
        
        UIButton *shopFavoritesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shopFavoritesBtn setTitle:@"收藏店铺" forState:UIControlStateNormal];
        shopFavoritesBtn.frame = CGRectMake(threeCutLine.sh_right,0,btnW,50);
        [shopFavoritesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [shopFavoritesBtn addTarget:self action:@selector(shopFavorites:) forControlEvents:UIControlEventTouchUpInside];
        [detailedBottomView addSubview:shopFavoritesBtn];
        
    }

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
    
    
}

#pragma mark 设置导航栏
- (void)setNavBar
{
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



#pragma mark 宝贝分类
- (void)babyClassification
{
    BabyClassificationManagementViewController *babyVc = [[BabyClassificationManagementViewController alloc] init];
    babyVc.shopId = self.shopId;
    babyVc.navigationItem.title =@"宝贝分类";
    [self.navigationController pushViewController:babyVc animated:YES];
    
}

#pragma mark 店铺介绍
- (void)shopIsintroduced
{
    [self introfuceBtn];
}

#pragma mark 联系卖家
- (void)contactTheSellerBtn
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        NSString *phoneNuber = [NSString stringWithFormat:@"tel:%@",self.shopDict[@"customer_mobile"]];
        
        // NSLog(@"%@",phoneNuber);
        
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNuber]]];
        [self.view addSubview:callWebview];

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


#pragma mark 收藏店铺
- (void)shopFavorites:(UIButton *)btn
{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        NSDictionary *dict = @{@"collect_id":@([self.shopId integerValue])};
        
        NSString *completeStr = [NSString stringEncryptedAddress:@"/collect/collectshop"];
        
        [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
            
            NSString *resultMessage = responseObject[@"result"][@"resultMessage"];
            
            if ([coder isEqualToString:@"0"])
            {
                [JKAlert alertText:@"收藏店铺成功"];
            }else
            {
                [JKAlert alertText:resultMessage];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"%@",error);
            
        }];
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

#pragma mark 联系买家
- (void)callPhone
{
    
    NSString *phoneNuber = [NSString stringWithFormat:@"tel:%@",self.shopDict[@"customer_mobile"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNuber]]];
    [self.view addSubview:callWebview];
   
}

// 从自己店铺查看
- (void)loadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/shopmanage/index"];
    
    [manager GET:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
   // NSLog(@"%@",responseObject);
        
//        self.shopDict = responseObject[@"obj"];
//        self.shopId = responseObject[@"obj"][@"id"];
        
        
        NSDictionary *dict = responseObject[@"obj"];
        
        if (dict == nil || dict == NULL)
        {
            [JKAlert alertText:@"商品详情页进入店铺查看数据错误"];
            return;
        }else
        {
            self.shopDict = responseObject[@"obj"];
            self.shopId = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"id"]];
            
            if (self.shopId == nil || self.shopId == NULL)
            {
                [JKAlert alertText:@"商品详情页进入店铺查看数据ID错误"];
                return;
            }
            
            
            [self setupNav];
            
            [self setupChildViewControllers];
            
            [self setupScrollView];
            
            [self setupTitlesView];
            
            [self addHeadView];

            // 默认添加子控制器的view
            [self addChildVcView];
            
            [self addBottomView];
        }

        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

// 从商品详情页进入店铺查看
- (void)shopLodaData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];

    NSDictionary *dict = @{@"shop_id":self.shopDetailed_Id};
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/shopmanage/store"];
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSDictionary *dict = responseObject[@"obj"];
        
        if (dict == nil)
        {
            [JKAlert alertText:@"商品详情页进入店铺查看数据错误"];
            return;
        }else
        {
            self.shopDict = responseObject[@"obj"];
            self.shopId = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"id"]];
            
            if (self.shopId == nil)
            {
                [JKAlert alertText:@"商品详情页进入店铺查看数据ID错误"];
                return;
            }
            
            [self setupNav];
            
            [self setupChildViewControllers];
            
            [self setupScrollView];
            
            [self setupTitlesView];
            
            [self addHeadView];
            
            // 默认添加子控制器的view
            [self addChildVcView];
            
            [self addBottomView];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

    
}

#pragma mark  宝贝管理通知
- (void)babyBtn
{
    [self.navigationController pushViewController:[GoodsManagementViewController new] animated:YES];
    
}
#pragma mark 店铺介绍
- (void)introfuceBtn
{
    ShopIntroduceController *shopVc = [[ShopIntroduceController alloc] init];
    shopVc.shopDict = self.shopDict;
   [self.navigationController pushViewController:shopVc animated:YES];
}

- (void)addHeadView
{
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil] lastObject];
    _headView.shopDict = self.shopDict;
    _headView.frame = CGRectMake(0,64,ScreenWidth,100);
    [self.view addSubview:_headView];
}

- (void)setupChildViewControllers
{
    if (self.shopId != nil)
    {
        ShopHomeController *shop = [[ShopHomeController alloc] init];
        shop.shopId = self.shopId;
        [self addChildViewController:shop];
        
        AllController *all = [[AllController alloc] init];
        all.shopId = self.shopId;
        [self addChildViewController:all];
        
        NesController *nes = [[NesController alloc] init];
        nes.shopId = self.shopId;
        [self addChildViewController:nes];


 
        
    }else
    {
        [JKAlert alertText:@"商品管理ID错误"];
    }
    
}


- (void)setupNav
{
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor =[UIColor whiteColor];
    
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.bounces = YES;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count *scrollView.sh_width,0);
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupTitlesView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    titlesView.frame = CGRectMake(0, 164,self.scrollView.sh_width,35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 添加标题
    NSArray *titles = @[@"店铺首页",@"全部宝贝",@"新品上架"];
    NSUInteger count = titles.count;
    CGFloat buttonW = self.titlesView.sh_width / count;
    CGFloat buttonH = self.titlesView.sh_height;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        SHTitleButton * titleButton = [SHTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        // 设置frame
        titleButton.frame = CGRectMake(i * buttonW ,0, buttonW, buttonH);
        
    }
    // 按钮的选中颜色
    SHTitleButton *firstTitleButton = titlesView.subviews.firstObject;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.sh_height = 1;
    indicatorView.sh_y = titlesView.sh_height - indicatorView.sh_height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    // 立刻根据文字内容计算label的宽度
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.sh_width = firstTitleButton.sh_width;
    indicatorView.sh_centerX = firstTitleButton.sh_centerX;
    
    // 默认情况 : 选中最前面的标题按钮
    firstTitleButton.selected = YES;
    
    self.selectedTitleButton = firstTitleButton;
    
    
}

- (void)titleClick:(SHTitleButton *)titleButton
{
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    
    self.selectedTitleButton = titleButton;
    
    // 底部指示器
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.sh_width = titleButton.sh_width;
        self.indicatorView.sh_centerX = titleButton.sh_centerX;
        
    }];
    
    // 让UIScrollView滚动到对应位置
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.sh_width;
    [self.scrollView setContentOffset:offset animated:YES];
    
}

#pragma mark - 添加子控制器的view

- (void)addChildVcView
{
    // 子控制器的索引
    
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.sh_width;
    
    switch (index) {
        case 0:
            self.navigationItem.title = @"店铺首页";
            break;
        case 1:
            self.navigationItem.title = @"全部宝贝";
            break;
        case 2:
            self.navigationItem.title = @"新品上架";
            break;
            
        default:
            break;
    }
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
    
    
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}


/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //   // 选中\点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.sh_width;
    SHTitleButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    // 添加子控制器的view
    [self addChildVcView];
    
}


- (void)tagClick
{
    //NSLog(@"选中点击对应的按钮");
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
