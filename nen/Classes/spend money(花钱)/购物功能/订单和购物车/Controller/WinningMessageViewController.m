//
//  WinningMessageViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "WinningMessageViewController.h"
#import "ShoppingViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
@interface WinningMessageViewController ()

@property(nonatomic,copy) NSString *imgUrl;

@property(nonatomic,copy) NSString *share_url;

@property(nonatomic,copy) NSString *winingTotal;

@property (nonatomic,copy) NSString *price;

@property(nonatomic,strong) UIButton *btn;


@end

@implementation WinningMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgrouImage = [[UIImageView alloc] init];
    backgrouImage.frame = CGRectMake(0,64,ScreenWidth,ScreenHeight - 135);
    backgrouImage.image = [UIImage imageNamed:@"hongbao.jpg"];
    [self.view addSubview:backgrouImage];
    [self loadData];
    // 中奖提示
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.font = [UIFont systemFontOfSize:15];
    promptLabel.text = @"温馨提示";
    promptLabel.frame = CGRectMake(10,ScreenHeight - 65,ScreenWidth - 20,15);
    promptLabel.textColor = [UIColor colorWithHexString:@"#FF5001"];
    [self.view addSubview:promptLabel];
    
    UILabel *promptTitlLabel = [[UILabel alloc] init];
    promptTitlLabel.font = [UIFont systemFontOfSize:12];
    promptTitlLabel.text = @"网一网app内的一切中奖活动与苹果公司无关，最终解释权归网一网信息科技有限公司所有";
    promptTitlLabel.frame = CGRectMake(10, promptLabel.sh_bottom + 10,ScreenWidth - 20,30);
    promptTitlLabel.numberOfLines = 0;
    [self.view addSubview:promptTitlLabel];

    
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn = shareBtn;
    shareBtn.frame = CGRectMake(ScreenWidth * 0.5 - 80,ScreenHeight *0.55 - 25,160,50);
    [shareBtn setTitle:@"分享领红包" forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.layer.cornerRadius = 5;
    shareBtn.clipsToBounds = YES;
    [self.view addSubview:shareBtn];

   
    
}


- (void)loadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/pay/orderwin"];
    
//    NSLog(@"%@",completeStr);
//    
//    NSLog(@"%@",self.trade_no);
// 
//    NSLog(@"%@",self.pay_type);
    
    NSDictionary *dict = @{@"pay_id":self.trade_no,@"pay_type":self.pay_type};
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
     //   NSLog(@"%@",responseObject);
//        
        self.imgUrl = responseObject[@"obj"][@"imgUrl"];
        self.share_url = responseObject[@"obj"][@"share_url"];
        self.winingTotal = responseObject[@"obj"][@"total"];
        self.price = responseObject[@"obj"][@"price"];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(ScreenWidth *0.5 - 80,ScreenHeight *0.38 - 15, 160,30);
        titleLabel.textColor = [UIColor redColor];
        titleLabel.text = [NSString stringWithFormat:@"恭喜你获得%.2f元",[self.winingTotal doubleValue]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:titleLabel];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
//        NSData  * data = error .userInfo [ @“com.alamofire.serialization.response.error.data” ];
//        NSString  * str = [[NSString  alloc ] initWithData：数据 编码：NSUTF 8 StringEncoding];
//        NSLog（@“服务器的错误原因：％@” ，str）;
        
               
    }];

}


- (void)clickShare
{
 
    [self winningShareClick];
}


- (void)winningShareClick {
    
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
    NSString* thumbURL = self.imgUrl;
    NSLog(@"%@",thumbURL);
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"消费有惊喜，我中得现金红包啦~" descr:[NSString stringWithFormat:@"消费金额为%@元,中得现金红包%.2f元",self.price,[self.winingTotal doubleValue]] thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.share_url;
    
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
//

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavBar];
}

#pragma mark 导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"中奖中心";
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




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for(UIViewController * controller in self.navigationController.viewControllers){
        
        if([controller isKindOfClass:[ShoppingViewController class]])
        {
            
        [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
    
    
    
}


@end
