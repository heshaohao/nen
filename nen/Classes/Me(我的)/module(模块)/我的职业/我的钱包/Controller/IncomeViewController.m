//
//  IncomeViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/20.
//  Copyright © 2017年 nen. All rights reserved.
// 收入界面 


#import "IncomeViewController.h"
#import "UMSocialWechatHandler.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WithdrawCashViewController.h"
#import "CheckViewController.h"
@interface IncomeViewController ()
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UIAlertController *alertController;

@property(nonatomic,strong) NSMutableArray *billArray;

// 总收入
@property(nonatomic,strong) UILabel *propertyNumeLabel;
// 今日收入
@property(nonatomic,strong) UILabel *todayNumeLabel;
// 本月收入
@property(nonatomic,strong) UILabel *monthNumeLabel;

@end

@implementation IncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
   [self addHeadView];
    [self addBottomView];
    [self setNav];
    
    if (self.type.length !=0)
    {
        [self loadData];
    }
    
}

- (void)loadData
{
    
    __weak typeof(self) weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/wallet/typeincome"];
    
    NSDictionary *dict = @{@"type":self.type};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        weakself.billArray = responseObject[@"list"];
        
        [weakself.billArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *typeStr = obj[@"type"];
            
            if ([typeStr isEqualToString:@"day"])
            {
                weakself.todayNumeLabel.text = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
            }
            
            if ([typeStr isEqualToString:@"month"])
            {
                weakself.monthNumeLabel.text = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
            }
            
            if ([typeStr isEqualToString:@"all"])
            {
                weakself.propertyNumeLabel.text = [NSString stringWithFormat:@"%@",obj[@"money_count"]];
            }
          
            
        }];
        
        
              
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
     //   NSLog(@"%@",error);
        
    }];

}


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

- (void)pushCheckVc
{
    
    [self.navigationController pushViewController:[[CheckViewController alloc] init] animated:NO];
    
}




- (void)addHeadView
{
    UIView *headview = [[UIView alloc] init];
    self.headView = headview;
    headview.frame = CGRectMake(0,64,ScreenWidth,150);
    headview.backgroundColor = [UIColor colorWithHexString:@"#FF5001"];
    [self.view addSubview:headview];
    
    UILabel *propertyLabel = [[UILabel alloc] init];
    propertyLabel.frame = CGRectMake(10,0,100,30);
    propertyLabel.text = @"总收入 (元)";
    propertyLabel.font = [UIFont systemFontOfSize:15];
    propertyLabel.textColor = [UIColor whiteColor];
    [headview addSubview:propertyLabel];
    
    UILabel *propertyNumeLabel = [[UILabel alloc] init];
    self.propertyNumeLabel = propertyNumeLabel;
    propertyNumeLabel.frame = CGRectMake(10,propertyLabel.sh_bottom,100,30);
   // propertyNumeLabel.text = self.allStr;
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
     self.todayNumeLabel = todayNumeLabel;
    todayNumeLabel.frame = CGRectMake(10,todayLabel.sh_bottom,100,30);
   // todayNumeLabel.text = self.dayStr;
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
    self.monthNumeLabel = monthNumeLabel;
    monthNumeLabel.frame = CGRectMake(ScreenWidth *0.7,monthLabel.sh_bottom,100,30);
  //  monthNumeLabel.text = self.monthlyStr;
    monthNumeLabel.font = [UIFont systemFontOfSize:15];
    monthNumeLabel.textColor = [UIColor whiteColor];
    [headview addSubview:monthNumeLabel];
    
    
}

-(void)addBottomView
{
    UIView *centerView = [[UIView alloc] init];
    centerView.frame = CGRectMake(0,self.headView.sh_bottom,ScreenWidth,60);
    [self.view addSubview:centerView];
    
    /************收入*******************/
    UIView * tradingView = [[UIView alloc] init];
    tradingView.frame = CGRectMake(0,0,ScreenWidth *0.5 - 0.5, centerView.sh_height);
    tradingView.backgroundColor = [UIColor whiteColor];
    [centerView addSubview:tradingView];
    
    /*******************************/
    UIImageView *tradingImage = [[UIImageView alloc] init];
    tradingImage.frame = CGRectMake(tradingView.sh_width * 0.2,tradingView.sh_height *0.2,tradingView.sh_width * 0.3, tradingView.sh_height * 0.6);
    tradingImage.image = [UIImage imageNamed:@"SR"];
    tradingImage.contentMode = UIViewContentModeScaleAspectFit;
    [tradingView addSubview:tradingImage];
    
    /*******************************/
    UILabel *tradingLabel = [[UILabel alloc] init];
    tradingLabel.frame = CGRectMake(tradingImage.sh_right + 10,tradingImage.sh_y,50,tradingImage.sh_height *0.5);
    tradingLabel.text = @"自营收入";
    tradingLabel.textColor = [UIColor grayColor];
    tradingLabel.font = [UIFont systemFontOfSize:11];
    [tradingView addSubview:tradingLabel];
    
    /*******************************/
    UILabel *tradingLabel1 = [[UILabel alloc] init];
    tradingLabel1.frame = CGRectMake(tradingImage.sh_right + 10,tradingLabel.sh_bottom,50,tradingImage.sh_height *0.5);
    tradingLabel1.text = @"0.00";
    tradingLabel1.textColor = [UIColor grayColor];
    tradingLabel1.font = [UIFont systemFontOfSize:11];
    [tradingView addSubview:tradingLabel1];
    
    /************中心分割线*******************/
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(tradingView.sh_right,4,1,tradingView.sh_height - 8);
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#FF5001"];
    [centerView addSubview:lineView1];
    
    /************余额*******************/
    UIView * agentView = [[UIView alloc] init];
    agentView.frame = CGRectMake(lineView1.sh_right,0,ScreenWidth *0.5 - 0.5, centerView.sh_height);
    agentView.backgroundColor = [UIColor whiteColor];
    [centerView addSubview:agentView];
    
        /*******************************/
    UIImageView * agentImage = [[UIImageView alloc] init];
    agentImage.frame = CGRectMake(agentView.sh_width * 0.2,agentView.sh_height *0.2,agentView.sh_width * 0.3, agentView.sh_height * 0.6);
    agentImage.image = [UIImage imageNamed:@"SR"];
    agentImage.contentMode = UIViewContentModeScaleAspectFit;
    [agentView addSubview:agentImage];
    /*******************************/
    
    UILabel *agentLabel = [[UILabel alloc] init];
    agentLabel.frame = CGRectMake(agentImage.sh_right + 10,agentImage.sh_y,50,agentImage.sh_height *0.5);
    agentLabel.text = @"代理收入";
    agentLabel.textColor = [UIColor grayColor];
    agentLabel.font = [UIFont systemFontOfSize:11];
    [agentView addSubview:agentLabel];
    
    /*******************************/
    UILabel *agentLabel1 = [[UILabel alloc] init];
    agentLabel1.frame = CGRectMake(agentImage.sh_right + 10,agentLabel.sh_bottom,50,agentImage.sh_height *0.5);
    agentLabel1.text = @"0.00";
    agentLabel1.textColor = [UIColor grayColor];
    agentLabel1.font = [UIFont systemFontOfSize:11];
    [agentView addSubview:agentLabel1];
    
    
    
    UIView *affirmView = [[UIView alloc] init];
    affirmView.frame = CGRectMake(0,centerView.sh_bottom + 10,ScreenWidth, 50);
    affirmView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:affirmView];
    
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
//    affirmLabelbb.text = @"0";
//    [affirmView addSubview:affirmLabelbb];
    
    
    
    UILabel *affirmBottomLabel = [[UILabel alloc] init];
    affirmBottomLabel.frame = CGRectMake(10,affirmView.sh_height *0.5,200,20);
    affirmBottomLabel.font = [UIFont systemFontOfSize:13];
    affirmBottomLabel.text = self.allStr;
    affirmBottomLabel.textColor = [UIColor blackColor];
    [affirmView addSubview:affirmBottomLabel];
    
    
    
    UIView *withdrawalView = [[UIView alloc] init];
    withdrawalView.frame = CGRectMake(0,affirmView.sh_bottom + 10,ScreenWidth, 60);
    withdrawalView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:withdrawalView];
    
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
    withdrawalBottomLabel.text = [NSString stringWithFormat:@"%.2f",self.remainingCash];
    [withdrawalView addSubview:withdrawalBottomLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth *0.05,withdrawalView.sh_bottom + 50,ScreenWidth *0.9,35);
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(withdrawCashClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    
    [self.view addSubview:btn];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.frame = CGRectMake(ScreenWidth *0.5 - 50,btn.sh_bottom + 10,100,20);
    bottomLabel.font = [UIFont systemFontOfSize:13];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"如何赚钱?";
    [self.view addSubview:bottomLabel];
    


}

#pragma mark 提现按钮事件
- (void)withdrawCashClick:(UIButton *)btn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *isWx = [defaults objectForKey:@"is_wx"];
    
    if ([isWx isEqualToString:@"0"])
    {
        // 标题
        self.alertController = [UIAlertController alertControllerWithTitle:@"您还未绑定您的微信,去绑定~" message:nil preferredStyle:UIAlertControllerStyleAlert];
        // 暂不绑定
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         //   NSLog(@"暂不");
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
        if (self.remainingCash >= 1)
        {
            [self.navigationController pushViewController:[[WithdrawCashViewController alloc] init] animated:YES];
            
            
        }else
        {
            [JKAlert alertText:@"要大于一元才可以提现!"];
        }
        
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavBar];
    NSDictionary *dict = @{@"popStr":@"1"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pop" object:self userInfo:dict];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *isWx = [defaults objectForKey:@"is_wx"];
    
    if ([isWx isEqualToString:@"0"])
    {
        // 标题
        self.alertController = [UIAlertController alertControllerWithTitle:@"您还未绑定您的微信,去绑定~" message:nil preferredStyle:UIAlertControllerStyleAlert];
        // 暂不绑定
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           //    NSLog(@"暂不");
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
        
    }
    
}

#pragma mark 设置导航栏
- (void)setNavBar
{
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

#pragma mark 微信登陆
- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            
            UMSocialUserInfoResponse *resp = result;
            
//            // 授权信息
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
            
            
            NSLog(@"%@",dict);
            
            
            [manager POST:loginCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                
             //   NSLog(@"返回参数%@",responseObject);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"1" forKey:@"is_wx"];
                [defaults synchronize];
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"%@",error);
          
            }];
        
            

            
            // 第三方平台SDK源数据
           // NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
        }
    }];
}



@end
