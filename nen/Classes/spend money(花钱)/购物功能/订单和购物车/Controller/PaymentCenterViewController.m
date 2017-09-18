 //
//  PaymentCenterViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/5.
//  Copyright © 2017年 nen. All rights reserved.
// 支付中心

#import "PaymentCenterViewController.h"
#import "PaymentModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WinningMessageViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "ShoppingViewController.h"

@interface PaymentCenterViewController ()
@property(nonatomic,strong) UIScrollView *scrView;

@property(nonatomic,strong) NSArray<PaymentModel *> *paymentArray;

@property(nonatomic,assign) CGFloat totalPriceSum;

@property(nonatomic,strong) UIView *orderView;

@property(nonatomic,strong) NSMutableArray *goodsIdArr;

@property(nonatomic,copy) NSString *trade_no;
@end

@implementation PaymentCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    // 选择中奖方式
    if (self.options == nil)
    {
        self.options = @"1";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (self.is_group.length == 0)
    {
        self.is_group = @"0";
    }
    
  
    
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    scrVc.frame = CGRectMake(0,64,ScreenWidth,ScreenHeight - 64);
    scrVc.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    scrVc.bounces = NO;
    self.scrView = scrVc;
    [self.view addSubview:scrVc];

    
  
    
    if (self.goodsId.length >0 )
    {
        [PaymentModel paymentModelGoodsId:self.goodsId GoodsNum:self.goods_num Options:self.options is_Group:self.is_group succes:^(NSArray<PaymentModel *> *paymentModelArray) {
            
            self.paymentArray = paymentModelArray;
            
            [self addOderView];
            
            [self paymentView];
            
            [self orderID];
            

        } error:^{
            
             NSLog(@"失败");
            
        }];
        
//        [PaymentModel paymentModelGoodsId:self.goodsId GoodsNum:self.goods_num Options:self.options succes:^(NSArray<PaymentModel *> *paymentModelArray) {
//            
//          //  NSLog(@"%@------%@",self.goodsId,self.goods_num);
//            
//            self.paymentArray = paymentModelArray;
//            
//            [self addOderView];
//            
//            [self paymentView];
//            
//             [self orderID];
//            
//            
//        } error:^{
//            
//            NSLog(@"失败");
//        }];
        
    }else
    {
        
        
        NSString *goodsId = [self.GoodsIdArray componentsJoinedByString:@","];
        
     
        
//        [PaymentModel paymentModelGoodsId:goodsId succes:^(NSArray<PaymentModel *> *paymentModelArray) {
//            
//            self.paymentArray = paymentModelArray;
        
            [self addOderView];
            
            [self paymentView];
            
           // [self orderID];
            
//        } error:^{
//            NSLog(@"失败");
//        }];
        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayCallBack:) name:UIApplicationWillEnterForegroundNotification object:self];
}

- (void)orderID
{
    // 订单id
    for (int i = 0; i < self.paymentArray.count;i++)
    {
        PaymentModel *model = self.paymentArray[i];
        [self.goodsIdArr addObject:model.id];
        
    }

}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"支付中心";
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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // NSLog(@"viewWillAppear");
    // 添加支付宝app通知方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alipayCallBack:) name:@"aliPayReslut" object:nil]
    ;
    
    // 微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinSuccess:) name:@"weixinSuccess" object:nil];
    
    // 微信用户中途退出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payOutAndError:) name:@"weixinOutAndErroe" object:nil];
    
   
}

- (NSMutableArray *)goodsIdArr
{
    if (!_goodsIdArr) {
        _goodsIdArr = [NSMutableArray array];
    }
    return _goodsIdArr;
}

- (void)addOderView
{
    UIView  *orderView = [[UIView alloc] init];
    self.orderView = orderView;
    
    self.orderView.frame = CGRectMake(0,-64,ScreenWidth,40);
    
    orderView.backgroundColor = [UIColor whiteColor];
    [self.scrView addSubview:self.orderView];
    
    UILabel *orderLabel = [[UILabel alloc]init];
    orderLabel.frame = CGRectMake(10,10,60,20);
    orderLabel.text = @"订单金额";
    orderLabel.font = [UIFont systemFontOfSize:14];
    [orderView addSubview:orderLabel];
    
    UILabel *rightOrderLabel = [[UILabel alloc]init];
    rightOrderLabel.frame = CGRectMake(ScreenWidth *0.7,10,80,20);
   
    if (self.goodsId)
    {
        rightOrderLabel.text = [NSString stringWithFormat:@"¥%.2f",self.singleTotalPrice];
        
    }else
    {
        rightOrderLabel.text = [NSString stringWithFormat:@"¥%.2f",self.moreTotalPrice];
    }
    
    rightOrderLabel.textColor = [UIColor orangeColor];
    rightOrderLabel.font = [UIFont systemFontOfSize:14];
    [orderView addSubview:rightOrderLabel];
    
}

- (void)paymentView
{
    UIView *paymentView = [[UIView alloc] init];
   
    paymentView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.scrView addSubview:paymentView];
    
    UILabel *payLabel = [[UILabel alloc] init];
    payLabel.frame = CGRectMake(0,0,ScreenWidth,30);
    payLabel.text = @"   支付方式";
    payLabel.font = [UIFont systemFontOfSize:14];
    payLabel.backgroundColor = [UIColor whiteColor];
    [paymentView addSubview:payLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0,payLabel.sh_bottom,ScreenWidth,1);
    [paymentView addSubview:lineView];
    
//    // 刚需球电子钱包
//    UIView *walletView = [[UIView alloc] init];
//    walletView.frame = CGRectMake(0,lineView.sh_bottom,ScreenWidth,50);
//    walletView.backgroundColor = [UIColor whiteColor];
//    [paymentView addSubview:walletView];
//    
//    UIImageView *walletImage = [[UIImageView alloc] init];
//    walletImage.frame = CGRectMake(20,10,30,30);
//    walletImage.image = [UIImage imageNamed:@"aaa.jpg"];
//    [walletView addSubview:walletImage];
//    
//    UILabel *walletLabel = [[UILabel alloc] init];
//    walletLabel.frame = CGRectMake(walletImage.sh_right + 10,10,100,30);
//    walletLabel.font = [UIFont systemFontOfSize:14];
//    walletLabel.text = @"刚需求电子钱包";
//    [walletView addSubview:walletLabel];
//    
//    UILabel *walletRightLabel = [[UILabel alloc] init];
//    walletRightLabel.frame = CGRectMake(ScreenWidth *0.7,10,80,30);
//    walletRightLabel.font = [UIFont systemFontOfSize:14];
//    walletRightLabel.text = @"可用额度0>";
//    walletRightLabel.textColor = [UIColor orangeColor];
//    [walletView addSubview:walletRightLabel];
//    
//    UITapGestureRecognizer *walletTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(walletClick:)];
//    [walletView addGestureRecognizer:walletTap];
//    
//    UIView *lineView1 = [[UIView alloc] init];
//    lineView1.backgroundColor = [UIColor lightGrayColor];
//    lineView1.frame = CGRectMake(0,walletView.sh_bottom,ScreenWidth,1);
//    [paymentView addSubview:lineView1];

    
    
//    // 微信支付
//    UIView *weChatView = [[UIView alloc] init];
//    weChatView.frame = CGRectMake(0,lineView1.sh_bottom,ScreenWidth,50);
//    weChatView.backgroundColor = [UIColor whiteColor];
//    [paymentView addSubview:weChatView];
//    
//    UIImageView *weChatImage = [[UIImageView alloc] init];
//    weChatImage.frame = CGRectMake(20,10,30,30);
//    weChatImage.image = [UIImage imageNamed:@"aaa.jpg"];
//    [weChatView addSubview:weChatImage];
//    
//    UILabel *weChatLabel = [[UILabel alloc] init];
//    weChatLabel.frame = CGRectMake(walletImage.sh_right + 10,10,100,30);
//    weChatLabel.font = [UIFont systemFontOfSize:14];
//    weChatLabel.text = @"微信支付";
//    [weChatView addSubview:weChatLabel];
//    
//    UILabel *weChatRightLabel = [[UILabel alloc] init];
//    weChatRightLabel.frame = CGRectMake(ScreenWidth *0.9,10,30,30);
//    weChatRightLabel.font = [UIFont systemFontOfSize:16];
//    weChatRightLabel.text = @">";
//    weChatRightLabel.textColor = [UIColor lightGrayColor];
//    [weChatView addSubview:weChatRightLabel];
//    
//    UITapGestureRecognizer *weChatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatClick:)];
//    [weChatView addGestureRecognizer:weChatTap];
//    
//    UIView *lineView2 = [[UIView alloc] init];
//    lineView2.backgroundColor = [UIColor lightGrayColor];
//    lineView2.frame = CGRectMake(0,weChatView.sh_bottom,ScreenWidth,1);
//    [paymentView addSubview:lineView2];

    // 支付宝支付
    UIView *alipayView = [[UIView alloc] init];
    alipayView.frame = CGRectMake(0,lineView.sh_bottom,ScreenWidth,50);
    alipayView.backgroundColor = [UIColor whiteColor];
    [paymentView addSubview:alipayView];
    
    UIImageView *alipayImage = [[UIImageView alloc] init];
    alipayImage.frame = CGRectMake(20,10,30,30);
    alipayImage.image = [UIImage imageNamed:@"zhifubao_img"];
    [alipayView addSubview:alipayImage];
    
    UILabel *alipayLabel = [[UILabel alloc] init];
    alipayLabel.frame = CGRectMake(alipayImage.sh_right + 10,10,100,30);
    alipayLabel.font = [UIFont systemFontOfSize:14];
    alipayLabel.text = @"支付宝支付";
    [alipayView addSubview:alipayLabel];
    
    UILabel *alipayRightLabel = [[UILabel alloc] init];
    alipayRightLabel.frame = CGRectMake(ScreenWidth *0.9,10,30,30);
    alipayRightLabel.font = [UIFont systemFontOfSize:16];
    alipayRightLabel.text = @">";
    alipayRightLabel.textColor = [UIColor lightGrayColor];
    [alipayView addSubview:alipayRightLabel];
    
    UITapGestureRecognizer *alipayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alipayClick:)];
    [alipayView addGestureRecognizer:alipayTap];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = [UIColor lightGrayColor];
    lineView3.frame = CGRectMake(0,alipayView.sh_bottom,ScreenWidth,1);
    [paymentView addSubview:lineView3];

//    // 银联支付
//    UIView *unionPayView = [[UIView alloc] init];
//    unionPayView.frame = CGRectMake(0,lineView3.sh_bottom,ScreenWidth,50);
//    unionPayView.backgroundColor = [UIColor whiteColor];
//    [paymentView addSubview:unionPayView];
//    
//    UIImageView *unionPayImage = [[UIImageView alloc] init];
//    unionPayImage.frame = CGRectMake(20,10,30,30);
//    unionPayImage.image = [UIImage imageNamed:@"aaa.jpg"];
//    [unionPayView addSubview:unionPayImage];
//    
//    UILabel *unionPayLabel = [[UILabel alloc] init];
//    unionPayLabel.frame = CGRectMake(alipayImage.sh_right + 10,10,100,30);
//    unionPayLabel.font = [UIFont systemFontOfSize:14];
//    unionPayLabel.text = @"银联支付";
//    [unionPayView addSubview:unionPayLabel];
//    
//    UILabel *unionPayLabelRightLabel = [[UILabel alloc] init];
//    unionPayLabelRightLabel.frame = CGRectMake(ScreenWidth *0.9,10,30,30);
//    unionPayLabelRightLabel.font = [UIFont systemFontOfSize:16];
//    unionPayLabelRightLabel.text = @">";
//    unionPayLabelRightLabel.textColor = [UIColor lightGrayColor];
//    [unionPayView addSubview:unionPayLabelRightLabel];
//    
//    UITapGestureRecognizer *unionPayViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unionPayClick:)];
//    [unionPayView addGestureRecognizer:unionPayViewTap];
//    
//    UIView *lineView4 = [[UIView alloc] init];
//    lineView4.backgroundColor = [UIColor lightGrayColor];
//    lineView4.frame = CGRectMake(0,unionPayView.sh_bottom,ScreenWidth,1);
//    [paymentView addSubview:lineView4];

    // 随机中奖
    
    UILabel * randomLabel = [[UILabel alloc]init];
    randomLabel.text = @"随机中奖";
    randomLabel.font = [UIFont systemFontOfSize:15];
    randomLabel.textColor = [UIColor redColor];
    randomLabel.frame = CGRectMake(ScreenWidth *0.4,lineView3.sh_bottom + 20,80,30);
    [paymentView addSubview:randomLabel];
    
    UILabel *randomLeftLabel = [[UILabel alloc] init];
    
    randomLeftLabel.frame = CGRectMake(ScreenWidth *0.05,randomLabel.sh_bottom + 10,ScreenWidth *0.4,30);
    
    randomLeftLabel.numberOfLines = 2;
    
    randomLeftLabel.font = [UIFont systemFontOfSize:12];
    
    randomLeftLabel.textColor = [UIColor redColor];
    
    if (self.goodsId)
    {
        randomLeftLabel.text = [NSString stringWithFormat:@"中奖额度最高%.2f元",self.singleTotalPrice];
    }else
    {
        randomLeftLabel.text = [NSString stringWithFormat:@"中奖额度最高%.2f元",self.moreTotalPrice];
    }
    [paymentView addSubview:randomLeftLabel];
    
    UILabel *randomRightLabel = [[UILabel alloc] init];
    randomRightLabel.frame = CGRectMake(randomLeftLabel.sh_right + 30,randomLabel.sh_bottom + 10,ScreenWidth *0.4,30);
   
    randomRightLabel.numberOfLines = 2;
    randomRightLabel.font = [UIFont systemFontOfSize:12];
    randomRightLabel.textColor = [UIColor redColor];
    if (self.goodsId)
    {
        randomRightLabel.text = [NSString stringWithFormat:@"中奖额度最底%.2f元",self.singleTotalPrice / 10];
    }else
    {
        randomRightLabel.text = [NSString stringWithFormat:@"中奖额度最底%.2f元",self.moreTotalPrice / 10];
    }
    
    [paymentView addSubview:randomRightLabel];
    
    UIImageView *bottomImage = [[UIImageView alloc] init];
    bottomImage.frame = CGRectMake(0,randomRightLabel.sh_bottom +30,ScreenWidth,150);
    bottomImage.image = [UIImage imageNamed:@"win.jpg"];
    [paymentView addSubview:bottomImage];
    
    
    // 中奖提示
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.font = [UIFont systemFontOfSize:15];
    promptLabel.text = @"温馨提示";
    promptLabel.frame = CGRectMake(10, bottomImage.sh_bottom + 10,ScreenWidth - 20,15);
    promptLabel.textColor = [UIColor colorWithHexString:@"#FF5001"];
    [paymentView addSubview:promptLabel];
    
    UILabel *promptTitlLabel = [[UILabel alloc] init];
    promptTitlLabel.font = [UIFont systemFontOfSize:12];
    promptTitlLabel.text = @"网一网app内的一切中奖活动与苹果公司无关，最终解释权归网一网信息科技有限公司所有";
    promptTitlLabel.frame = CGRectMake(10, promptLabel.sh_bottom + 10,ScreenWidth - 20,30);
    promptTitlLabel.numberOfLines = 0;
    [paymentView addSubview:promptTitlLabel];
    
    paymentView.frame = CGRectMake(0,self.orderView.sh_bottom + 20,ScreenWidth,promptTitlLabel.sh_bottom);
    
    self.scrView.contentSize = CGSizeMake(0,paymentView.sh_bottom);
}

#pragma mark  电子钱包点击事件
- (void)walletClick:(UITapGestureRecognizer *)gesture
{

}

#pragma mark ----------------------- 微信 -------------------------
- (void)weChatClick:(UITapGestureRecognizer *)gesture
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/pay/prepay"];
    NSDictionary *dict;
    
    NSString *str;
    if (self.GoodsIdArray.count == 0)
    {
        str = [self.goodsIdArr componentsJoinedByString:@","];
        
    }else
    {
      for (NSString *orderIdStr in self.GoodsIdArray)
        {
            str = orderIdStr;
        }
        
    }
    
    // 判断是否为立即购买
//    if(self.goodsId)
//    {
//        dict = @{@"type":@"shop",@"payment":@"wx",@"order_ids":self.goodsId};
//    }else
//    {
        dict = @{@"type":@"shop",@"payment":@"wx",@"order_ids":str};
    //}
    
   // NSLog(@"%@",dict[@"order_ids"]);
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSDictionary *dict = responseObject[@"obj"];
        
        self.trade_no = responseObject[@"result"][@"out_trade_no"];
        
      //  NSLog(@"%@",self.trade_no);
        
    // 创建支付对象
        PayReq *req = [[PayReq alloc] init];
        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
        req.openID = [NSString stringWithFormat:@"%@",dict[@"appid"]];
        
        // 商家id，在注册的时候给的
        req.partnerId =[NSString stringWithFormat:@"%@",dict[@"partnerid"]];
        
        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
        req.prepayId  = [NSString stringWithFormat:@"%@",dict[@"prepayid"]]; //dict[@"prepayid"];
        
        // 根据财付通文档填写的数据和签名
        //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
        req.package  = [NSString stringWithFormat:@"%@",dict[@"package"]]; //dict[@"package"];
        
        // 随机编码，为了防止重复的，在后台生成
        req.nonceStr  = [NSString stringWithFormat:@"%@",dict[@"noncestr"]]; //dict[@"noncestr"];
        
        // 这个是时间戳，也是在后台生成的，为了验证支付的
        NSString * stamp = [NSString stringWithFormat:@"%@",dict[@"timestamp"]]; //dict[@"timestamp"];
        req.timeStamp = stamp.intValue;
        
        // 这个签名也是后台做的
        req.sign = [NSString stringWithFormat:@"%@",dict[@"sign"]]; //dict[@"sign"];
        
      
        // 判断手机是否安装微信客户端
        if ([WXApi isWXAppInstalled])
        {  //发送请求到微信，等待微信返回onResp
            [WXApi sendReq:req];
        }else
        {
        [JKAlert alertText:@"请安装微信"];
            
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                for(UIViewController * controller in self.navigationController.viewControllers){
                    
                    if([controller isKindOfClass:[ShoppingViewController class]])
                    {
                        
                    [self.navigationController popToViewController:controller animated:YES];
                        
                    }
                }

            });
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        NSLog(@"%@",error);
    }];
}

#pragma mark 微信支付成功

- (void)weixinSuccess:(NSNotification *)notification
{
    NSString *stateStr = [NSString stringWithFormat:@"%@",notification.userInfo[@"state"]];
    
    if ([stateStr isEqualToString:@"0"])
    {
        
        WinningMessageViewController *winningVc = [[WinningMessageViewController alloc] init];
        winningVc.trade_no  = self.trade_no;
        winningVc.pay_type = @"1";
        
        [self.navigationController pushViewController:winningVc animated:NO];
        
    }
}

#pragma mark 微信支付 用户中途退出 / 支付失败
- (void)payOutAndError:(NSNotification *)notification
{
    NSString *stateStr = [NSString stringWithFormat:@"%@",notification.userInfo[@"state"]];
    
    if ([stateStr isEqualToString:@"-1"])
    {
        [JKAlert alertText:@"支付失败"];
    }else
    {
        [JKAlert alertText:@"用户中途退出"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for(UIViewController * controller in self.navigationController.viewControllers){
            
            if([controller isKindOfClass:[ShoppingViewController class]])
            {
                
                [self.navigationController popToViewController:controller animated:YES];
                
            }
        }
        
    });
}


#pragma mark ------------------ 支付宝网页端支付 ----------------------------

- (void)alipayClick:(UITapGestureRecognizer *)gesture
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
      NSString *completeStr = [NSString stringEncryptedAddress:@"/pay/prepay"];
    
    
    NSDictionary *dict;
    
    
    NSString *str;
    if (self.GoodsIdArray.count == 0)
    {
        str = [self.goodsIdArr componentsJoinedByString:@","];
        
    }else
    {
      
        for (NSString *orderIdStr in self.GoodsIdArray)
        {
            str = orderIdStr;
        }
        
    }
    
    // 判断是否为立即购买
//   if(self.goodsId !=nil)
//   {
//        dict = @{@"type":@"shop",@"payment":@"alipay",@"order_ids":self.goodsId};
//    }else
//    {
        dict = @{@"type":@"shop",@"payment":@"alipay",@"order_ids":str};
 
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSDictionary *dic = responseObject[@"obj"];
//        self.trade_no = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"alipay_trade_app_pay_response"][@"out_trade_no"]];
        NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        NSString *resultMessage = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultMessage"]];
        
        if ([codeStr isEqualToString:@"0"])
        {
            //  NSLog(@"%@",dic);
            
            //1. 应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"com.www.020.nen";
            //2. 调用自己的后台接口, 获取签名加密后的订单信息字符串
            
            NSString *orderString = [NSString stringWithFormat:@"%@",dic[@"orderinfo"]];
            //3. 调用支付宝接口 将签名成功字符串格式化为订单字符串,请严格按照该格式
            if (orderString != nil) {
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    //resultStatus = 9000 就代表支付成功. 开发者可以跳转到支付成功的控制器
                    //   NSLog(@"reslut = %@",resultDic);
                    
                    
                    NSString *str = resultDic[@"result"];
                    
                    // 提取支付结果字符串
                    NSDictionary *returnDic =  [self stringToJson:str];
                    
                    NSDictionary *dataDic = returnDic[@"alipay_trade_app_pay_response"];
                    
                    self.trade_no = [NSString stringWithFormat:@"%@",dataDic[@"out_trade_no"]];
                    
                    NSString *result = resultDic[@"resultStatus"];
                    
                    if ([result isEqualToString:@"9000"])
                    {
                        
                        
                        if ([self.is_group isEqualToString:@"1"])
                        {
                            [self PaymentAfterTheSuccessOpenGroupPayTyep:@"2"];
                            
                        }else
                        {
                            WinningMessageViewController *winningVc = [[WinningMessageViewController alloc] init];
                            winningVc.trade_no  = self.trade_no;
                            winningVc.pay_type = @"2";
                            [self.navigationController pushViewController:winningVc animated:NO];
                        }
                        
                        
                    }else
                    {
                        [JKAlert alertText:@"用户取消支付"];
                        return;
                    }
                }];
            }
        }else
        {
            [JKAlert alertText:resultMessage];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
        
    }];
}

#pragma mark  跳转支付宝App回调方法 成功 / 失败
- (void)alipayCallBack:(NSNotification *)notification
{
   // NSString *memoStr = notification.userInfo[@"memo"];
    NSString *resultMessageStr = notification.userInfo[@"resultStatus"];
    
    NSString *str = notification.userInfo[@"result"];
    
    // 提取支付结果字符串
    NSDictionary *returnDic =  [self stringToJson:str];
    
    NSDictionary *dataDic = returnDic[@"alipay_trade_app_pay_response"];
    

    self.trade_no = [NSString stringWithFormat:@"%@",dataDic[@"out_trade_no"]];
    
    
    if([resultMessageStr isEqualToString:@"9000"])
    {
        if ([self.is_group isEqualToString:@"1"])
        {
            [self PaymentAfterTheSuccessOpenGroupPayTyep:@"2"];
            
        }else
        {
            WinningMessageViewController *winningVc = [[WinningMessageViewController alloc] init];
            winningVc.trade_no  = self.trade_no;
            winningVc.pay_type = @"2";
            [self.navigationController pushViewController:winningVc animated:NO];
            
        }

    }else
    {
        [JKAlert alertText:@"取消支付"];
        return;
        
    }
}

#pragma mark - 处理支付宝支付结果  (字符串转json)
- (NSDictionary *)stringToJson:(NSString *)str
{
    
    NSString *requestTmp = [NSString stringWithString: str];
    
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    return resultDic;
}



#pragma mark 团购支付完成后开团
- (void)PaymentAfterTheSuccessOpenGroupPayTyep:(NSString *)payTyep
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr;
    
    NSString *orderStr = [self.goodsIdArr componentsJoinedByString:@","];
    
    if ([self.groupModel.type isEqualToString:@"1"])
    {
        completeStr = [NSString stringEncryptedAddress:@"/group/grouping"];
    }else
    {
        completeStr = [NSString stringEncryptedAddress:@"/group/notgroups"];
    }
    NSDictionary *dict;
    if (self.groupModel.group.count > 0)
    {
        dict = @{@"pay_id":self.trade_no,@"pay_type":payTyep,@"parent_id":self.groupModel.group[0][@"group_id"]};
        
    }else
    {
        dict = @{@"pay_id":self.trade_no ,@"pay_type":payTyep};
    }
    
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
       
        NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        NSString *resultMessage = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultMessage"]];
        
        if ([codeStr isEqualToString:@"0"])
        {
            WinningMessageViewController *winningVc = [[WinningMessageViewController alloc] init];
            winningVc.trade_no  = self.trade_no;
            winningVc.pay_type = @"2";
            [self.navigationController pushViewController:winningVc animated:NO];
            
        }else
        {
            [JKAlert alertText:resultMessage];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark  银联点击事件
- (void)unionPayClick:(UITapGestureRecognizer *)gesture
{
  
}


#pragma mark 购物车支付中心返回
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.GoodsIdArray.count >0)
    {
        UIViewController *viewVc = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:viewVc animated:YES];
    
    }
    
    
}

@end
