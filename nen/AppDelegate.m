//
//  AppDelegate.m
//  nen
//
//  Created by nenios101 on 2017/2/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "AppDelegate.h"
#import "SHTabBarViewController.h"
#import "LoginAndRegisterViewController.h"
#import "PaymentCenterViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "PushAfterTheJumpViewController.h"

#import <Bugly/Bugly.h>

#import "MainViewController.h"
//#import "LoginViewController.h"

#import "AppDelegate+EaseMob.h"
#import "RedPacketUserConfig.h"
#import <UserNotifications/UserNotifications.h>



@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@end

#define EaseMobAppKey @"1146161114115548#gangxuqiu"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
    // bugly
    [Bugly startWithAppId:@"2126c8d816"];
//    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
//    // 设置根控制器
//     self.window.rootViewController = [SHTabBarViewController sharedManager];
//        // 显示窗口
//        [self.window makeKeyAndVisible];
    
    // 微信
    [WXApi registerApp:@"wx2023c934d947da80"];
    UMSocialHandler *handler = [UMSocialWechatHandler defaultManager];
    
    [handler setAppId:@"wx2023c934d947da80" appSecret:@"25b5d74cdc79ae750694b2a7cb0887b0" url:@"http://www.baidu.com"];
    
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:NO];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58ec70561c5dd02800001a9e"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    
    //可以只适配8.0以上 可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    
    
    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    
    //注册极光推送
    [JPUSHService setupWithOption:launchOptions appKey:@"d1fef621c2af0f3f73753a68"
                          channel:@"AppStore"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    
    
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"debug";
#else
    apnsCertName = @"product";
#endif
    
//    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
    if (!appkey) {
        appkey = EaseMobAppKey;
        [ud setObject:appkey forKey:@"identifier_appkey"];
    }
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:appkey
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
//    self.window.rootViewController = [SHTabBarViewController sharedManager];
//    
//    [self.window makeKeyAndVisible];
    
    
    return YES;
}


// 接收远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_mainController) {
        [_mainController jumpToChatList];
    }
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}

// 本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainController) {
        [_mainController didReceiveLocalNotification:notification];
    }
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if (_mainController) {
        [_mainController didReceiveUserNotification:response.notification];
    }
    completionHandler();
}




//2. 获取Token
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //3. Required - 注册 DeviceToken --> 将Token给极光后台服务器
    [JPUSHService registerDeviceToken:deviceToken];
}

//4. 处理远程通知的值
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    
    PushAfterTheJumpViewController  *pushVc = [[PushAfterTheJumpViewController alloc] init];
    pushVc.alertStr = userInfo[@"aps"][@"alert"];
    
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:pushVc];
    [self.window.rootViewController presentViewController:na animated:YES completion:nil];
   
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx2023c934d947da80" appSecret:@"25b5d74cdc79ae750694b2a7cb0887b0" redirectURL:@"http://www.baidu.com"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105568417"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://www.baidu.com"];
//
    
  }

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        //    NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
     [[NSNotificationCenter defaultCenter]postNotificationName:@"aliPayReslut" object:nil userInfo:resultDic];
            
        }];
    }
    
    if ([url.host isEqualToString:@"pay"])
        
    {      //微信支付，处理支付结果
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    
    if (![[UMSocialManager defaultManager] handleOpenURL:url]) {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        return result;
    }
    
    
    return YES;

}





//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSDictionary *dict;
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
      //  NSLog(@"%d",resp.errCode);
        
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功!";
                dict = @{@"state":@0};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"weixinSuccess" object:nil userInfo:dict];
                break;
            case -1:
                payResoult = @"支付结果：失败!";
                dict = @{@"state":@-1};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"weixinOutAndErroe" object:nil userInfo:dict];
                break;
            case -2:
                payResoult = @"用户已经退出支付!";
                dict = @{@"state":@-2};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"weixinOutAndErroe" object:nil userInfo:dict];
                 //[[NSNotificationCenter defaultCenter]postNotificationName:@"weixinSuccess" object:nil userInfo:dict];
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}

@end
