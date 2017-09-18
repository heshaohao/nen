//
//  TotalIncomeViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/19.
//  Copyright © 2017年 nen. All rights reserved.
//总收入 十个按钮界面

#import "TotalIncomeViewController.h"
#import "ClassificationOptionsView.h"
#import "CheckViewController.h"
#import "IncomeViewController.h"
#import "WithdrawCashViewController.h"
#import "UMSocialWechatHandler.h"
#import <UMSocialCore/UMSocialCore.h>

@interface TotalIncomeViewController ()

@property(nonatomic,strong) UIScrollView *scrView;

@property(nonatomic,strong) ClassificationOptionsView *classificationView;

@property(nonatomic,strong) NSArray * ListArray;

@property(nonatomic,strong) UIView *headView;


@property(nonatomic,copy) NSString *titleStr;

@property(nonatomic,copy) NSString * winingMoney;

@property(nonatomic,strong) UIAlertController *alertController;

@end

@implementation TotalIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self setNav];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/wallet/allincome"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.ListArray = responseObject[@"list"];
        
       // NSLog(@"%@",responseObject);
        
//        
       [self addSCrollview];
       [self addHeadView];
       [self addClassificationView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushIncomeVc:) name:@"incomeVc" object:nil];
 
}

#pragma mark 跳转到收入控制器
- (void)pushIncomeVc:(NSNotification *)notification
{
    self.titleStr = notification.userInfo[@"title"];
    IncomeViewController *icomeVc = [[IncomeViewController alloc] init];
    if ([notification.userInfo[@"type"] isEqualToString:@"1"])
    {
        [self.ListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *typ = [NSString stringWithFormat:@"%@",obj[@"type"]];
            
          if([typ isEqualToString:@"day"])
            {
                icomeVc.dayStr = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
                
            }
            if ([typ isEqualToString:@"month"])
            {
                icomeVc.monthlyStr = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
            }
            if([typ  isEqualToString:@"all"])
            {
               icomeVc.allStr = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
            }
            
        }];
    }
    
    icomeVc.navigationItem.title = self.titleStr;
    icomeVc.type = notification.userInfo[@"type"];
    icomeVc.remainingCash = self.cashWithdrawal;
    [self.navigationController pushViewController:icomeVc animated:YES];
    
}


#pragma mark 设置导航栏
- (void)setNav
{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.sh_width = 40;
    btn.sh_height = 40;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font= [UIFont systemFontOfSize:15];
    [btn setTitle:@"账单" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushCheckVc) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
     self.navigationItem.rightBarButtonItem = rightBtn;

}

#pragma mark 跳转帐单控制器
- (void)pushCheckVc
{
    [self.navigationController pushViewController:[[CheckViewController alloc] init] animated:NO];
}


- (void)addSCrollview
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    self.scrView = scrVc;
    self.scrView.bounces = NO;
    scrVc.frame = CGRectMake(0,64,ScreenWidth,ScreenHeight);
    scrVc.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.view addSubview:scrVc];
}

- (void)addHeadView
{
    UIView *headview = [[UIView alloc] init];
    self.headView = headview;
    headview.frame = CGRectMake(0,0,ScreenWidth,150);
    headview.backgroundColor = [UIColor colorWithHexString:@"#FF5001"];
    [self.scrView addSubview:headview];
    
    UILabel *propertyLabel = [[UILabel alloc] init];
    propertyLabel.frame = CGRectMake(10,0,100,30);
    propertyLabel.text = @"总收入 (元)";
    propertyLabel.font = [UIFont systemFontOfSize:15];
    propertyLabel.textColor = [UIColor whiteColor];
    [headview addSubview:propertyLabel];
   
    UILabel *propertyNumeLabel = [[UILabel alloc] init];
    propertyNumeLabel.frame = CGRectMake(10,propertyLabel.sh_bottom,100,30);
    propertyNumeLabel.text = @"0";
    propertyNumeLabel.font = [UIFont systemFontOfSize:15];
    propertyNumeLabel.textColor = [UIColor whiteColor];
    [headview addSubview:propertyNumeLabel];
    
    UIImageView *rightImage = [[UIImageView alloc] init];
    rightImage.frame = CGRectMake(ScreenWidth - 30,0,30, 30);
    rightImage.image = [UIImage imageNamed:@"wenhao"];
    [headview addSubview:rightImage];
    
    
    UILabel *todayLabel = [[UILabel alloc] init];
    todayLabel.frame = CGRectMake(10,propertyNumeLabel.sh_bottom + 20,100,30);
    todayLabel.text = @"今日收入 (元)";
    todayLabel.font = [UIFont systemFontOfSize:15];
    todayLabel.textColor = [UIColor whiteColor];
    [headview addSubview:todayLabel];

    UILabel *todayNumeLabel = [[UILabel alloc] init];
    todayNumeLabel.frame = CGRectMake(10,todayLabel.sh_bottom,100,30);
    
    
    todayNumeLabel.text = [NSString stringWithFormat:@"%@",self.ListArray[8][@"money_count"]];
    todayNumeLabel.font = [UIFont systemFontOfSize:15];
    todayNumeLabel.textColor = [UIColor whiteColor];
    [headview addSubview:todayNumeLabel];
    
    
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.frame = CGRectMake(ScreenWidth *0.7,todayLabel.sh_y ,100,30);
    monthLabel.text = @"本月收入 (元)";
    monthLabel.font = [UIFont systemFontOfSize:15];
    monthLabel.textColor = [UIColor whiteColor];
    [headview addSubview:monthLabel];
    
    
    UILabel *monthNumeLabel = [[UILabel alloc] init];
    monthNumeLabel.frame = CGRectMake(ScreenWidth *0.7,monthLabel.sh_bottom,100,30);
    monthNumeLabel.text = @"0";
    monthNumeLabel.font = [UIFont systemFontOfSize:15];
    monthNumeLabel.textColor = [UIColor whiteColor];
    [headview addSubview:monthNumeLabel];
    
    [self.ListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *typ = [NSString stringWithFormat:@"%@",obj[@"type"]];
        
        if ([typ isEqualToString:@"1"])
        {
         //   NSLog(@"%@",obj[@"money_count"]);
            
            self.winingMoney = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
        }
        if([typ isEqualToString:@"day"])
        {
            todayNumeLabel.text = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
            
        }
        if ([typ isEqualToString:@"month"])
        {
            monthNumeLabel.text = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
        }
        if([typ  isEqualToString:@"all"])
        {
            propertyNumeLabel.text = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
        }

    }];
    
}


#pragma mark  添加中间部分
- (void)addClassificationView
{
    ClassificationOptionsView *classView = [[[NSBundle mainBundle] loadNibNamed:@"ClassificationOptionsView" owner:nil options:nil] lastObject];
    
    self.classificationView  =classView;
    classView.frame = CGRectMake(0, self.headView.sh_bottom,ScreenWidth,120);
    classView.Str = self.winingMoney;
    
    self.classificationView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.scrView addSubview:classView];
    
    UIView *affirmView = [[UIView alloc] init];
    affirmView.frame = CGRectMake(0,self.classificationView.sh_bottom + 10,ScreenWidth, 50);
    affirmView.backgroundColor = [UIColor whiteColor];
    [self.scrView addSubview:affirmView];

    UILabel *affirmLabel = [[UILabel alloc] init];
    affirmLabel.frame = CGRectMake(10,5,100,20);
    affirmLabel.font = [UIFont systemFontOfSize:13];
    affirmLabel.text = @"待确认收入 (元)";
    [affirmView addSubview:affirmLabel];
    
    UIImageView *affirmImage = [[UIImageView alloc] init];
    affirmImage.frame = CGRectMake(affirmLabel.sh_right ,affirmLabel.sh_y,20, 20);
    affirmImage.image = [UIImage imageNamed:@"wenhao"];
    [affirmView addSubview:affirmImage];
//    
//    UILabel *affirmLabelbb = [[UILabel alloc] init];
//    affirmLabelbb.frame = CGRectMake(10,affirmLabel.sh_bottom,100,20);
//    affirmLabelbb.font = [UIFont systemFontOfSize:13];
//    affirmLabelbb.text = self.winingMoney;
//    [affirmView addSubview:affirmLabelbb];
    
    UILabel *affirmBottomLabel = [[UILabel alloc] init];
    affirmBottomLabel.frame = CGRectMake(10,affirmView.sh_height *0.5,200,20);
    affirmBottomLabel.font = [UIFont systemFontOfSize:13];
    affirmBottomLabel.text = self.winingMoney;
    affirmBottomLabel.textColor = [UIColor blackColor];
    [affirmView addSubview:affirmBottomLabel];
    
    
    
    
    
    UIView *withdrawalView = [[UIView alloc] init];
    withdrawalView.frame = CGRectMake(0,affirmView.sh_bottom + 10,ScreenWidth, 60);
    withdrawalView.backgroundColor = [UIColor whiteColor];
    [self.scrView addSubview:withdrawalView];
    
    UILabel *withdrawalLabel = [[UILabel alloc] init];
    withdrawalLabel.frame = CGRectMake(10,5,100,20);
    withdrawalLabel.font = [UIFont systemFontOfSize:13];
    withdrawalLabel.text = @"可提现收入 (元)";
    [withdrawalView addSubview:withdrawalLabel];
    
    UIImageView *withdrawalImage = [[UIImageView alloc] init];
    withdrawalImage.frame = CGRectMake(withdrawalLabel.sh_right ,withdrawalLabel.sh_y,20, 20);
    withdrawalImage.image = [UIImage imageNamed:@"wenhao"];
    [withdrawalView addSubview:withdrawalImage];
    
    UILabel *withdrawalBottomLabel = [[UILabel alloc] init];
    withdrawalBottomLabel.frame = CGRectMake(10,withdrawalLabel.sh_bottom,200,20);
    withdrawalBottomLabel.font = [UIFont systemFontOfSize:13];
    withdrawalBottomLabel.text = [NSString stringWithFormat:@"%.2f",self.cashWithdrawal];
    [withdrawalView addSubview:withdrawalBottomLabel];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth *0.05,withdrawalView.sh_bottom + 50,ScreenWidth *0.9,35);
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(withdrawClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    
    [self.scrView addSubview:btn];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.frame = CGRectMake(ScreenWidth *0.5 - 50,btn.sh_bottom + 10,100,20);
    bottomLabel.font = [UIFont systemFontOfSize:13];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"如何赚钱?";
    [self.scrView addSubview:bottomLabel];
    
    self.scrView.contentSize = CGSizeMake(0,bottomLabel.sh_bottom + 74);
    
}


#pragma mark 金额提现
- (void)withdrawClick:(UIButton *)btn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *isWx = [defaults objectForKey:@"is_wx"];
    
    if ([isWx isEqualToString:@"0"])
    {
        // 标题
        self.alertController = [UIAlertController alertControllerWithTitle:@"您还未绑定您的微信,去绑定~" message:nil preferredStyle:UIAlertControllerStyleAlert];
        // 暂不绑定
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"暂不");
        }];
        [self.alertController addAction:cancelAction];
        [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        
        // 去绑定
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self getAuthWithUserInfoFromWechat];
           
        }];
        
        [defaultAction setValue:[UIColor orangeColor] forKey:@"_titleTextColor"];
        [self.alertController addAction:defaultAction];
        
        
        [self presentViewController:self.alertController animated:NO completion:nil];
        
    }else
    {
        if (self.cashWithdrawal >= 1)
        {
            [self.navigationController pushViewController:[[WithdrawCashViewController alloc] init] animated:YES];
            
        }else
        {
            [JKAlert alertText:@"要大于一元才可以提现!"];
        }
        
    }

}


#pragma mark 微信登陆
- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            
            UMSocialUserInfoResponse *resp = result;
//            
//            //            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//            
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.gender);
//            //
            //              // 第三方平台SDK源数据
     //       NSLog(@"Wechat originalResponse: %@", resp.originalResponse);

//            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
            //  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSString *loginCompleteStr = [NSString stringEncryptedAddress:@"/site/wxlogin"];
            
            NSInteger sex = 0;
            
            if ([resp.gender isEqualToString:@"m"])
            {
                sex = 1;
            }else if([resp.gender isEqualToString:@"2"])
            {
                sex = 2;
            }
            
            
            NSString * provinceStr = resp.originalResponse[@"province"];
            NSString * cityStr = resp.originalResponse[@"city"];
            NSString * countryStr = resp.originalResponse[@"country"];
            
            NSDictionary *dict = @{@"openid":resp.openid,@"nickname":resp.name,@"headimgurl":resp.iconurl,@"city":cityStr,@"country":countryStr,@"province":provinceStr,@"unionid":resp.uid,@"sex":@(sex)};
            
            
            
            [manager POST:loginCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"1" forKey:@"is_wx"];
                
                [defaults synchronize];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"%@",error);
                
            }];
            
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popAdjustmentScrollViewHeight:) name:@"pop" object:nil];
    
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"总收入";
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
    
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark 从下一页跳转回来后从新设置scrollView的y值
- (void)popAdjustmentScrollViewHeight:(NSNotification *)notification
{
    
    NSString *popStr = notification.userInfo[@"popStr"];
    if ([popStr isEqualToString:@"1"])
    {
        self.scrView.sh_y = 0;
    }
    
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
