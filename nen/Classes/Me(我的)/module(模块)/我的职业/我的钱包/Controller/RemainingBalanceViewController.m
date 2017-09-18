//
//  RemainingBalanceViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/25.
//  Copyright © 2017年 nen. All rights reserved.
// 余额

#import "RemainingBalanceViewController.h"
#import "WithdrawCashViewController.h"
#import "UMSocialWechatHandler.h"
#import <UMSocialCore/UMSocialCore.h>
@interface RemainingBalanceViewController ()

@property(nonatomic,strong) NSUserDefaults *defaults;

@end

@implementation RemainingBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.frame = CGRectMake(ScreenWidth *0.5 - 75,ScreenHeight *0.25,150,150);
    iconImage.image = [UIImage imageNamed:@"jingbi2"];
    [self.view addSubview:iconImage];
    
    UILabel *remainLabel = [[UILabel alloc] init];
    remainLabel.frame = CGRectMake(ScreenWidth *0.5 - 75,iconImage.sh_bottom + 10,150,30);
    remainLabel.text = @"我的余额 (元)";
    remainLabel.textColor = [UIColor lightGrayColor];
    remainLabel.textAlignment = NSTextAlignmentCenter;
    remainLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:remainLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.frame = CGRectMake(ScreenWidth *0.5 - 75,remainLabel.sh_bottom + 10 ,150,30);
    moneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.remainingStr];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:moneyLabel];
    
    UIButton *cashWithdrawal = [UIButton buttonWithType:UIButtonTypeCustom];
    cashWithdrawal.frame = CGRectMake(ScreenWidth *0.05,moneyLabel.sh_bottom + 80,ScreenWidth *0.9,35);
    [cashWithdrawal setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cashWithdrawal setTitle:@"提现" forState:UIControlStateNormal];
    cashWithdrawal.titleLabel.font = [UIFont systemFontOfSize:15];
    cashWithdrawal.layer.cornerRadius = 5;
    cashWithdrawal.clipsToBounds = YES;
    [cashWithdrawal addTarget:self action:@selector(cashWithdawalBtn) forControlEvents:UIControlEventTouchUpInside];
    cashWithdrawal.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cashWithdrawal.layer.borderWidth = 1;
    [self.view addSubview:cashWithdrawal];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.frame = CGRectMake(ScreenWidth *0.5 - 75,cashWithdrawal.sh_bottom + 10,150,20);
    bottomLabel.font = [UIFont systemFontOfSize:15];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"领取某某大礼包";
    [self.view addSubview:bottomLabel];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNav];
    _defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *isWx = [_defaults objectForKey:@"is_wx"];
    
    if ([isWx isEqualToString:@"0"])
    {
        // 标题
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"您还未绑定您的微信,去绑定~" message:nil preferredStyle:UIAlertControllerStyleAlert];
        // 暂不绑定
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
            
        }];
        [alert addAction:cancelAction];
        [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        
        // 去绑定
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self getAuthWithUserInfoFromWechat];
            
        }];
        
        [defaultAction setValue:[UIColor orangeColor] forKey:@"_titleTextColor"];
        [alert addAction:defaultAction];
        
        
        [self presentViewController:alert animated:NO completion:nil];
        
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

#pragma mark 提取现金
- (void)cashWithdawalBtn
{
    NSString *isWx = [_defaults objectForKey:@"is_wx"];
    
    
    if ([isWx isEqualToString:@"0"])
    {
        [JKAlert alertText:@"您还没绑定微信账号"];
      
    }else if ([isWx isEqualToString:@"1"])
    {
        
        if ([self.remainingStr integerValue] >= 1)
        {
            
            [self.navigationController pushViewController:[[WithdrawCashViewController alloc] init] animated:YES];
        }else
        {
            [JKAlert alertText:@"要大于一元才可以提现!"];
        }
        
    }
    
}

- (void)setNav
{
    self.navigationItem.title = @"余额";
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
