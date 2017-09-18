//
//  SmallShopViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/9.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SmallShopViewController.h"
#import "SmallHeadView.h"
#import "SmallContentView.h"
#import "GoodsManagementViewController.h"
#import "BootomViewController.h"
#import "MessageViewController.h"
#import "IncomeTableViewController.h"
#import "MyShopController.h"
#import "ShopSetDecorateController.h"
#import "ShopmanageModel.h"
#import "ReleaseGoodsViewController.h"
#import "IncomeViewController.h"

#import "CommentsTheManagementController.h"
@interface SmallShopViewController ()

@property(nonatomic,strong) SmallHeadView *headView;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) SmallContentView *smallContentView;

@property(nonatomic,strong) UIButton *btn;

@property(nonatomic,copy) NSString  *shopsId;

@property(nonatomic,strong) ShopmanageModel *shopModel;

@end

@implementation SmallShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addScrollview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsBtn) name:@"goods" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderBtn) name:@"order" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBtn) name:@"message" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomeBtn) name:@"income" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopBtn) name:@"shop" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decorateBtn) name:@"decorate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCommentsManagement) name:@"commentsManagement" object:nil];
    
}



#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"微店";
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


- (void)shopsToApplyForData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/shop/isshop"];

    
    [manager POST:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.shopsId = responseObject[@"obj"][@"id"];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}

#pragma mark 商品评论
- (void)pushCommentsManagement
{
    [self.navigationController pushViewController:[CommentsTheManagementController new] animated:YES];
}

#pragma mark 商品管理通知

-(void)goodsBtn
{
    [self.navigationController pushViewController:[GoodsManagementViewController new] animated:YES];
}
#pragma mark 订单管理通知
-(void)orderBtn
{
    [self.navigationController pushViewController:[BootomViewController new] animated:YES];
}
#pragma mark 订单管理通知
-(void)messageBtn
{
    [self.navigationController pushViewController:[MessageViewController new] animated:YES];
}

#pragma mark 店铺收入通知
-(void)incomeBtn
{
    IncomeViewController *incomeVc = [[IncomeViewController alloc] init];
    incomeVc.type = @"4";
    incomeVc.navigationItem.title = @"店铺收入";
    [self.navigationController pushViewController:incomeVc animated:YES];
    
}
#pragma mark 我的店铺通知
-(void)shopBtn
{
    [self.navigationController pushViewController:[MyShopController new] animated:YES];
}

#pragma mark 店铺装修通知
-(void)decorateBtn
{
    [self.navigationController pushViewController:[ShopSetDecorateController new] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self setNavBar];
    [ShopmanageModel ShopmanageModelsuccess:^(ShopmanageModel *shopmanageModel) {
        self.shopModel  = shopmanageModel;
        
        [self addHeadView];
        
        [self addContenView];
        
        [self addBtn];
        
        [self shopsToApplyForData];
        
    } error:^{
        
        NSLog(@"失败");
    }];

    
}


- (void)addScrollview
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    self.scrollView = scrVc;
    scrVc.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    scrVc.frame = self.view.frame;
    [self.view addSubview:scrVc];
}

- (void)addHeadView
{
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"SmallHeadView" owner:nil options:nil] lastObject];
    _headView.frame = CGRectMake(0, 0, ScreenWidth, 230);
    _headView.model = self.shopModel;
    [self.scrollView addSubview:_headView];
}

- (void)addContenView
{
    _smallContentView = [[[NSBundle mainBundle] loadNibNamed:@"SmallContentView" owner:nil options:nil] lastObject];
    _smallContentView.frame = CGRectMake(0, _headView.sh_bottom + 10, ScreenWidth, 180);
    [self.scrollView addSubview:_smallContentView];
}

- (void)addBtn
{
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(ScreenWidth * 0.1,_smallContentView.sh_bottom + 50,ScreenWidth * 0.8,30);
    [_btn setBackgroundColor:[UIColor orangeColor]];
    [_btn setTitle:@"发布商品" forState:UIControlStateNormal];
    _btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btn addTarget:self action:@selector(releaseGoods) forControlEvents:UIControlEventTouchUpInside];
    _btn.clipsToBounds = YES;
    _btn.layer.cornerRadius=5;
    
    [self.scrollView addSubview:_btn];
    
}

- (void)releaseGoods
{
    [self.navigationController  pushViewController:[[ReleaseGoodsViewController alloc] init] animated:YES];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
