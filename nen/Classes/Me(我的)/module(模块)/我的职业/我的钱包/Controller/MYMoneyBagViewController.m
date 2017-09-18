//
//  MYMoneyBagViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/19.
//  Copyright © 2017年 nen. All rights reserved.
//我的钱包

#import "MYMoneyBagViewController.h"
#import "TotalIncomeViewController.h"
#import "CheckViewController.h"
#import "RemainingBalanceViewController.h"
#import "BankCardViewController.h"
#import "NetCashViewController.h"
@interface MYMoneyBagViewController ()<SDCycleScrollViewDelegate>
// 图片轮播器
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property(nonatomic,strong) NSArray<ShufflingFigureModel *> *shuffingMoldelArray;

@property(nonatomic,strong) UIView *oneView;

@property(nonatomic,strong) UIView *twoView;

@property(nonatomic,strong) UILabel *remainingL;

@property(nonatomic,strong) UILabel *incomeLabel1;

@property(nonatomic,strong) UILabel *remainingLabel1;

@property(nonatomic,strong) UILabel *bankcardLabel1;

@property(nonatomic,strong) UILabel *netCashLabel1;
// 余额
@property(nonatomic,assign) CGFloat cash;


@end

@implementation MYMoneyBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    
    [ShufflingFigureModel shufflingFigureLocation:@"11" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        
        self.shuffingMoldelArray = shufflingFigure;
        
        
        
    } error:^{
        NSLog(@"失败");
    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/wallet/index"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        [self addOneView];
        [self addTwoView];
        [self addThreeView];
        
        self.remainingL.text = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"balance"]];
        self.incomeLabel1.text = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"booked"]];
        self.remainingLabel1.text = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"balance"]];
        self.netCashLabel1.text = [NSString stringWithFormat:@"%@", responseObject[@"obj"][@"net_coin"]];
        self.bankcardLabel1.text = [NSString stringWithFormat:@"%@", responseObject[@"obj"][@"bank_card"]];
      
        // 余额
        self.cash = [responseObject[@"obj"][@"balance"] doubleValue];
        
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark 账单
- (void)pushCheckVc
{
    
    [self.navigationController pushViewController:[[CheckViewController alloc] init] animated:NO];
    
}

- (void)selectItemAtIndex:(NSInteger)index {
    
    
}

#pragma mark 图片轮播器数组
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = @"我的钱包";
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0,KNavBarBackBtnW, KNavBarBackBtnH);
    [leftButton setBackgroundImage:KNavBarBackIconColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    nagetiveSpacer.width = KNavBarSpacing;   //这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,leftBarButtonItems];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:KNavBarTittleFont],
       
       NSForegroundColorAttributeName:KNavBarTitlesColor }];
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintsColor;
    
    UIButton *rightButton = [[UIButton alloc]init];
     rightButton.frame = CGRectMake(0, 0,KNavBarBackBtnW, KNavBarBackBtnH);
    [rightButton setTitle:@"账单" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(pushCheckVc) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:KNavBarTitlesColor forState:UIControlStateNormal];
    UIBarButtonItem *rightsButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *rightNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    rightNagetiveSpacer.width = 0;   //这个值可以根据自己需要自己调整
    self.navigationItem.rightBarButtonItems = @[rightNagetiveSpacer,rightsButton];
    
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)addOneView
{
    
    UIView  *oneView = [[UIView alloc] init];
    self.oneView = oneView;
    oneView.frame = CGRectMake(0,64,ScreenWidth,ScreenHeight *0.4);
    oneView.backgroundColor = [UIColor colorWithHexString:@"#FF5001"];
    
    UILabel *propertyLabel = [[UILabel alloc] init];
    propertyLabel.frame = CGRectMake(10,0,100,30);
    propertyLabel.text = @"总资产 (元)";
    propertyLabel.font = [UIFont systemFontOfSize:15];
    propertyLabel.textColor = [UIColor whiteColor];
    [oneView addSubview:propertyLabel];
    
    UIImageView *rightImage = [[UIImageView alloc] init];
    rightImage.frame = CGRectMake(ScreenWidth - 30,0,30, 30);
    rightImage.image = [UIImage imageNamed:@"wenhao"];
    [oneView addSubview:rightImage];
    
    
    UILabel *remainingLabel = [[UILabel alloc] init];
    self.remainingL = remainingLabel;
    remainingLabel.frame = CGRectMake(10,oneView.sh_height - 40,200,30);
    remainingLabel.text = @"0.00";
    remainingLabel.font = [UIFont systemFontOfSize:20];
    remainingLabel.textColor =[UIColor whiteColor];
    [oneView addSubview:remainingLabel];
    
    [self.view addSubview:oneView];
}
- (void)addTwoView
{
    
    UIView  *twoView = [[UIView alloc] init];
    self.twoView = twoView;
    twoView.frame = CGRectMake(0,self.oneView.sh_bottom,ScreenWidth,(ScreenHeight *0.25)*0.5);
    twoView.backgroundColor = KNavBarBarTintsColor;
    [self.view addSubview:twoView];
    
   /************收入*******************/
    UIView * incomeView = [[UIView alloc] init];
    incomeView.frame = CGRectMake(0,0,ScreenWidth *0.5 - 0.5, twoView.sh_height);
    [twoView addSubview:incomeView];
    
    UITapGestureRecognizer *incomeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(incomeTpaClick:)];
    
    [incomeView addGestureRecognizer:incomeTap];
    
    /*******************************/
    UIImageView *incomImage = [[UIImageView alloc] init];
    incomImage.frame = CGRectMake(incomeView.sh_width * 0.2,incomeView.sh_height *0.2,incomeView.sh_width * 0.3, incomeView.sh_height * 0.6);
    incomImage.image = [UIImage imageNamed:@"shouru"];
    [incomeView addSubview:incomImage];
    
    /*******************************/
    UILabel *incomeLabel = [[UILabel alloc] init];
    incomeLabel.frame = CGRectMake(incomImage.sh_right + 10,incomImage.sh_y,50,incomImage.sh_height *0.5);
    incomeLabel.text = @"收入";
    incomeLabel.textColor= [UIColor lightGrayColor];
    incomeLabel.font = [UIFont systemFontOfSize:13];
    [incomeView addSubview:incomeLabel];
    
    /*******************************/
    UILabel *incomeLabel1 = [[UILabel alloc] init];
    self.incomeLabel1 = incomeLabel1;
    incomeLabel1.frame = CGRectMake(incomImage.sh_right + 10,incomeLabel.sh_bottom,50,incomImage.sh_height *0.5);
    incomeLabel1.text = @"0.00";
    incomeLabel1.textColor= [UIColor lightGrayColor];
    incomeLabel1.font = [UIFont systemFontOfSize:13];
    [incomeView addSubview:incomeLabel1];

    /************中心分割线*******************/
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(incomeView.sh_right,4,1,incomeView.sh_height - 8);
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [twoView addSubview:lineView1];
 
    /************余额*******************/
    UIView * remainingView = [[UIView alloc] init];
    remainingView.frame = CGRectMake(lineView1.sh_right,0,ScreenWidth *0.5 - 0.5, twoView.sh_height);
    [twoView addSubview:remainingView];
    
    UITapGestureRecognizer *remainingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remainingTapClick:)];
    
    [remainingView addGestureRecognizer:remainingTap];
    
    /*******************************/
    UIImageView *remainingImage = [[UIImageView alloc] init];
    remainingImage.frame = CGRectMake(remainingView.sh_width * 0.2,remainingView.sh_height *0.2,remainingView.sh_width * 0.3, remainingView.sh_height * 0.6);
    remainingImage.image = [UIImage imageNamed:@"yue"];
    [remainingView addSubview:remainingImage];
    /*******************************/
    
    UILabel *remainingLabel = [[UILabel alloc] init];
    remainingLabel.frame = CGRectMake(remainingImage.sh_right + 10,remainingImage.sh_y,50,remainingImage.sh_height *0.5);
    remainingLabel.text = @"余额";
    remainingLabel.textColor = [UIColor grayColor];
    remainingLabel.font = [UIFont systemFontOfSize:13];
    [remainingView addSubview:remainingLabel];
 
    /*******************************/
    UILabel *remainingLabel1 = [[UILabel alloc] init];
    self.remainingLabel1 = remainingLabel1;
    remainingLabel1.frame = CGRectMake(remainingImage.sh_right + 10,remainingLabel.sh_bottom,50,remainingImage.sh_height *0.5);
    remainingLabel1.text = @"0.00";
    remainingLabel1.textColor = [UIColor grayColor];
    remainingLabel1.font = [UIFont systemFontOfSize:13];
    [remainingView addSubview:remainingLabel1];
    
//    /*******************************/
//    UIView *centerLine = [[UIView alloc] init];
//    centerLine.frame = CGRectMake(0,remainingView.sh_bottom,ScreenWidth,1);
//    centerLine.backgroundColor = [UIColor lightGrayColor];
//    [twoView addSubview:centerLine];
//    
     /************银行*******************/
    
//    UIView * bankcardView = [[UIView alloc] init];
//    bankcardView.frame = CGRectMake(0,centerLine.sh_bottom,ScreenWidth *0.5 - 0.5, twoView.sh_height *0.5 - 0.5);
//    [twoView addSubview:bankcardView];
//    
//    UITapGestureRecognizer *bankcardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bankcardTapClick:)];
//    
//    [bankcardView addGestureRecognizer:bankcardTap];
//    UIImageView *bankcardImage = [[UIImageView alloc] init];
//    bankcardImage.frame = CGRectMake(bankcardView.sh_width * 0.2,bankcardView.sh_height *0.2,bankcardView.sh_width * 0.3, bankcardView.sh_height * 0.6);
//    bankcardImage.image = [UIImage imageNamed:@"yinhangka"];
//    [bankcardView addSubview:bankcardImage];
//
//    /*******************************/
//    UILabel *bankcardLabel = [[UILabel alloc] init];
//    bankcardLabel.frame = CGRectMake(bankcardImage.sh_right + 10,bankcardImage.sh_y,50,bankcardImage.sh_height *0.5);
//    bankcardLabel.text = @"银行卡";
//    bankcardLabel.textColor = [UIColor grayColor];
//    bankcardLabel.font = [UIFont systemFontOfSize:13];
//    [bankcardView addSubview:bankcardLabel];
//    
//    /*******************************/
//    UILabel *bankcardLabel1 = [[UILabel alloc] init];
//    self.bankcardLabel1 = bankcardLabel1;
//    bankcardLabel1.frame = CGRectMake(bankcardImage.sh_right + 10,bankcardLabel.sh_bottom,50,bankcardImage.sh_height *0.5);
//    bankcardLabel1.text = @"0";
//    bankcardLabel1.textColor = [UIColor grayColor];
//    bankcardLabel1.font = [UIFont systemFontOfSize:13];
//    [bankcardView addSubview:bankcardLabel1];
//
//    
//    
//    /************中心分割线*******************/
//    UIView *lineView2 = [[UIView alloc] init];
//    lineView2.frame = CGRectMake(bankcardView.sh_right,centerLine.sh_bottom + 4 ,1,bankcardView.sh_height - 8);
//    lineView2.backgroundColor = [UIColor lightGrayColor];
//    [twoView addSubview:lineView2];
//    
//    
//    /************网币*******************/
//    UIView * netCashView = [[UIView alloc] init];
//    netCashView.frame = CGRectMake(lineView2.sh_right,centerLine.sh_bottom,ScreenWidth *0.5 - 0.5, twoView.sh_height *0.5 - 0.5);
//    [twoView addSubview:netCashView];
//    
//    UITapGestureRecognizer *netCashTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(netCashTapClick:)];
//    
//    [netCashView addGestureRecognizer:netCashTap];
//    
//    /*******************************/
//    UIImageView *netCashImage = [[UIImageView alloc] init];
//    netCashImage.frame = CGRectMake(netCashView.sh_width * 0.2,netCashView.sh_height *0.2,netCashView.sh_width * 0.3, netCashView.sh_height * 0.6);
//    netCashImage.image = [UIImage imageNamed:@"qitashouru"];
//    [netCashView addSubview:netCashImage];
//    /*******************************/
//    
//    UILabel *netCashLabel = [[UILabel alloc] init];
//    netCashLabel.frame = CGRectMake(netCashImage.sh_right + 10,netCashImage.sh_y,50,netCashImage.sh_height *0.5);
//    netCashLabel.text = @"其他";
//    netCashLabel.font = [UIFont systemFontOfSize:13];
//    bankcardLabel1.textColor = [UIColor grayColor];
//    [netCashView addSubview:netCashLabel];
//    
//    /*******************************/
//    UILabel *netCashLabel1 = [[UILabel alloc] init];
//    self.netCashLabel1 = netCashLabel1;
//    netCashLabel1.frame = CGRectMake(netCashImage.sh_right + 10,netCashLabel.sh_bottom,50,netCashImage.sh_height *0.5);
//    netCashLabel1.text = @"0.00";
//    netCashLabel1.font = [UIFont systemFontOfSize:13];
//    [netCashView addSubview:netCashLabel1];
}


#pragma mark 收入
- (void)incomeTpaClick:(UITapGestureRecognizer *)tap
{
    
    TotalIncomeViewController *totallInVc = [[TotalIncomeViewController alloc] init];
    totallInVc.cashWithdrawal = self.cash;
    
    [self.navigationController pushViewController:totallInVc animated:NO];
}
#pragma mark 余额
- (void)remainingTapClick:(UITapGestureRecognizer *)tap
{
    RemainingBalanceViewController *remainVc = [[RemainingBalanceViewController alloc] init];
    remainVc.remainingStr = self.remainingL.text;
    
    [self.navigationController pushViewController:remainVc animated:YES];
}
#pragma mark 银行卡
- (void)bankcardTapClick:(UITapGestureRecognizer *)tap
{
    [self.navigationController pushViewController:[[BankCardViewController alloc] init] animated:YES];
}

#pragma mark 网币
- (void)netCashTapClick:(UITapGestureRecognizer *)tap
{
    [JKAlert alertText:@"暂无其他功能"];
//    [self.navigationController pushViewController:[[NetCashViewController alloc] init] animated:YES];
}

#pragma mark 添加轮播图
- (void)addThreeView
{
    UIView  *threeView = [[UIView alloc] init];
    threeView.frame = CGRectMake(0,self.twoView.sh_bottom,ScreenWidth,ScreenHeight *0.4);
    threeView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:threeView];
    
    
       SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth,threeView.sh_height -20) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];

    
    NSMutableArray *arrTemp = [NSMutableArray array];
    
    [self.shuffingMoldelArray enumerateObjectsUsingBlock:^(ShufflingFigureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrTemp addObject:obj.img_url];
    }];
    
    cycleScrollView.imageURLStringsGroup = arrTemp;
    
    [threeView addSubview:cycleScrollView];
    
    
}


@end
