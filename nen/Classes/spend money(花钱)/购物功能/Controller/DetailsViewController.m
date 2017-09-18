//
//  DetailsViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/6.
//  Copyright © 2017年 nen. All rights reserved.
//商品详情

#import "DetailsViewController.h"
#import "DetailsHeadView.h"
#import "DetailsMidstView.h"
#import "DetailsBottomView.h"
#import "ModalView.h"
#import "TheOrderViewController.h"
#import "GoodsProductModel.h"
#import "ShoppingCarController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "GroupBuyingItemGoodsItemModel.h"
#import "GroupBuyingHeadView.h"
#import "generalButton.h"
#import "MyShopController.h"
#import "detailsBtn.h"
#import "FLCountDownView.h"

@interface DetailsViewController ()

@property(nonatomic,strong) DetailsHeadView *detailsView;

@property(nonatomic,strong) DetailsMidstView *detailsMidstView;

@property(nonatomic,strong) DetailsBottomView *detailsBottomView;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) ModalView *modalView;

// 立即购买
@property(nonatomic,strong) GoodsProductModel *productModel;

@property(nonatomic,strong) UIView *hudView;

// 团购
@property(nonatomic,strong) GroupBuyingItemGoodsItemModel *groupItemModel;

@property(nonatomic,strong) GroupBuyingHeadView *groupHeadView;

@property(nonatomic,strong) UIView *grouopMidsdtViews;

@property(nonatomic,strong) detailsBtn *rightfBtns;

// 防止商铺查看店铺 死循环
@property (nonatomic,copy) NSString *flag;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addScrollView];
    
    self.flag = @"0";
    
    if (!self.groupBuyingId.length)
    {
        // 消费中奖
        [GoodsProductModel goodsproductListGoodsId:self.goodsId success:^(GoodsProductModel *goodsList) {
            self.productModel = goodsList;
            
            NSLog(@"%@",self.productModel);
            
            NSMutableArray *imageArray = [NSMutableArray array];
//            
//            NSLog(@"%@",imageArray);
            
            NSDictionary *imageDcit = self.productModel.goods_all_img;
            for (NSInteger i = 0;i < imageDcit.count;i++)
            {
                NSString *img = [NSString stringWithFormat:@"img%ld",i + 1];
                
                NSString *imageStr = imageDcit[img];
                
                [imageArray addObject:imageStr];
            }
            

            DetailsHeadView *detailsHeadV = [[DetailsHeadView alloc] init];
            self.detailsView = detailsHeadV;
            
//            if (imageArray.count == 0)
//            {
//                [imageArray addObject:@"placeholderImage"];
//            }
            
            detailsHeadV.imageArray = imageArray;
            detailsHeadV.model = self.productModel;
            detailsHeadV.backgroundColor = [UIColor whiteColor];
            detailsHeadV.sh_y = 10;
            detailsHeadV.sh_width = ScreenWidth;
            detailsHeadV.sh_x = 0;
            detailsHeadV.sh_height = 385;
            
            [self.scrollView addSubview:detailsHeadV];
            
            if (self.productModel !=nil)
            {
                [self addMidsdtView];
                [self addBottomView];
                
            }
            
            
        } error:^{
           NSLog(@"失败");
        }];
        
    }else
    {
        
        // 团购
        [GroupBuyingItemGoodsItemModel groupBuyingItemGoodsId:self.groupBuyingId success:^(GroupBuyingItemGoodsItemModel *groupBuyingModel) {
            self.groupItemModel = groupBuyingModel;
            
//            
//            if (self.productModel == nil)
//            {
//                self.scrollView.frame = CGRectMake(0, 99,ScreenWidth,ScreenHeight - 100);
//                
//            }
            
            NSMutableArray *imageArray = [NSMutableArray array];
            
            NSDictionary *imageDcit = self.groupItemModel.goods_all_img;
            for (NSInteger i = 0;i < imageDcit.count;i++)
            {
                NSString *img = [NSString stringWithFormat:@"img%ld",i + 1];
                
                NSString *imageStr = imageDcit[img];
                
                [imageArray addObject:imageStr];
            }

            GroupBuyingHeadView * headView = [[GroupBuyingHeadView alloc] init];
            self.groupHeadView = headView;
            
            headView.imageArray = imageArray;
            headView.model = self.groupItemModel;
            
            headView.backgroundColor = [UIColor whiteColor];
            headView.sh_y = 0;
            headView.sh_width = ScreenWidth;
            headView.sh_x = 0;
            headView.sh_height = 385;
            
            [self.scrollView addSubview:headView];
            [self addGroupMidsdtView];
            
            if (self.groupItemModel !=nil)
            {
                [self addGroupMidsdtBottomView];
                [self addGroupBottomView];
                
            }
        
            
        } error:^{
          //  NSLog(@"失败");
        }];
    }
    
    // 立即购买弹框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modalView:) name:@"modalView" object:nil];
    // 关闭弹框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeBtn) name:@"close" object:nil];
    // 立即购买点击确定后传递要购买的个数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confimBtn:) name:@"confirm" object:nil];
    // 加入购物车
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoppingBtn:) name:@"shoppingCar" object:nil];
    //  商品分享
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoodsShareBtnClick:) name:@"shoppingShar" object:nil];
    // 查看店铺
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookAtThestore:) name:@"goodsDetailsPushShopVc"object:nil];
    // 商品收藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickPushloginVc) name:@"pushloginVc"object:nil];
}

#pragma mark 没有登录时调用
- (void)clickPushloginVc
{
    [self.navigationController pushViewController:[LoginAndRegisterViewController sharedManager] animated:YES];
}

#pragma mark --------团购部分 ------------

#pragma mark 获取系统时间戳
-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}


#pragma mark 团购商品详情中间部分
- (void)addGroupMidsdtView
{
    UIView *grouopMidsdtView = [[UIView alloc] init];
    self.grouopMidsdtViews = grouopMidsdtView;
    grouopMidsdtView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:grouopMidsdtView];
    
    UILabel *leftTtitle = [[UILabel alloc] init];
    leftTtitle.text = @"以下小伙正在发起拼团";
    leftTtitle.frame = CGRectMake(10,5, 150,20);
    leftTtitle.font = [UIFont systemFontOfSize:11];
    [grouopMidsdtView addSubview:leftTtitle];
    
    if (self.groupItemModel.group.count)
    {
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.frame = CGRectMake(15,leftTtitle.sh_bottom + 10,40,40);
        iconImage.layer.cornerRadius = 20;
        iconImage.clipsToBounds = YES;
        iconImage.image = [UIImage imageNamed:@"3"];
        [grouopMidsdtView addSubview:iconImage];
        
        
        UILabel *headTitle = [[UILabel alloc] init];
        headTitle.frame = CGRectMake(iconImage.sh_right + 20,iconImage.sh_y + 5,30,25);
        headTitle.text = @"剩余";
        headTitle.font = [UIFont systemFontOfSize:13];
        [grouopMidsdtView addSubview:headTitle];
        
        long long theTime = [[self getNowTimeTimestamp] longLongValue ];
        
        //NSLog(@"%lld",theTime);
        
        long long endTime = [[NSString stringWithFormat:@"%@",self.groupItemModel.group[0][@"end_time"]] longLongValue];
        
       // NSLog(@"%lld",endTime);
        
        NSInteger time;
        
        if (theTime < endTime)
        {
            time = endTime - theTime;
            
        }else
        {
            time = 0;
        }
        
        
        
        
        
        FLCountDownView *countDown = [FLCountDownView fl_countDown];
        countDown.frame = CGRectMake(headTitle.sh_right - 5,iconImage.sh_y + 5,(ScreenWidth - 150) - 80,25);
        countDown.timestamp = time;
//        countDown.backgroundImageName = @"search_k";
        countDown.timerStopBlock = ^{
            NSLog(@"时间停止");
        };
        [grouopMidsdtView addSubview:countDown];
        
        UILabel *endTitle = [[UILabel alloc] init];
        endTitle.frame = CGRectMake(countDown.sh_right - 2,iconImage.sh_y + 5,30,25);
        endTitle.text = @"结束";
        endTitle.font = [UIFont systemFontOfSize:13];
        [grouopMidsdtView addSubview:endTitle];
        
        UIButton *offeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        offeredBtn.frame = CGRectMake(ScreenWidth - 70,countDown.sh_y + 5,60,25);
        [offeredBtn setTitle:@"去参团" forState:UIControlStateNormal];
        [offeredBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [offeredBtn addTarget:self action:@selector(offeredBtn) forControlEvents:UIControlEventTouchUpInside];
        offeredBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        offeredBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        offeredBtn.layer.borderWidth = 0.5f;
        [grouopMidsdtView addSubview:offeredBtn];
        
        grouopMidsdtView.frame = CGRectMake(0,self.groupHeadView.sh_bottom + 5,ScreenWidth,iconImage.sh_bottom + 10);
    }else
    {
        grouopMidsdtView.frame = CGRectMake(0,self.groupHeadView.sh_bottom + 5,ScreenWidth,0);
    }
    
}

#pragma mark 去参团
- (void)offeredBtn
{
    [self checkTheTuxedoNumber];
}

#pragma mark 去参团 二人团  查看参团人数
- (void)checkTheTuxedoNumber
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/group/setgroupnum"];
    
    
   // NSLog(@"%@",self.groupItemModel.group);
    
    
    NSDictionary *dict;
    if (self.groupItemModel.group.count >= 1) {
    dict = @{@"goods_id":self.groupBuyingId ,@"parent_id":self.groupItemModel.group[0][@"group_id"]};
    }else{
    
    dict = @{@"goods_id":self.groupBuyingId,@"parent_id":@"0"};
    }
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSString *resultCodeStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        if ([resultCodeStr isEqualToString:@"0"])
        {
           
            TheOrderViewController *orderVc = [[TheOrderViewController alloc] init];
            orderVc.is_groupStr = @"1";
            orderVc.goodsId = self.groupBuyingId;
            orderVc.goods_num = @"1";
            orderVc.groupModel = self.groupItemModel;
            [self.navigationController pushViewController:orderVc animated:YES];
            
        }else
        {
             [JKAlert alertText:responseObject[@"result"][@"resultMessage"]];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
#pragma mark 团购商品详情中间下部 部分
- (void)addGroupMidsdtBottomView
{
    UIView *midsdtBottomView = [[UIView alloc] init];
    midsdtBottomView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:midsdtBottomView];
    
    UILabel *leftTtitle = [[UILabel alloc] init];
    leftTtitle.text = @"支付开团并邀请1人参加,人数部足自动退款";
    leftTtitle.textColor = [UIColor lightGrayColor];
    leftTtitle.frame = CGRectMake(10,5, ScreenWidth *0.8,20);
    leftTtitle.font = [UIFont systemFontOfSize:13];
    [midsdtBottomView addSubview:leftTtitle];
    
    NSArray *titleArray = @[@"01\n选购商品",@"02\n选购商品\n或参团",@"03\n等待好友\n参团支付",@"04\n达到人数组团成功"];
    //控制总列数
    int totalColumns = 4;
    CGFloat Y = leftTtitle.sh_bottom + 5;
    CGFloat W = 60;
    CGFloat H = 60;
    CGFloat X = (self.view.frame.size.width - totalColumns * W) / (totalColumns + 1);
    
    for (int index = 0; index < 4; index++) {
        
        int col = index % totalColumns;
        CGFloat viewX = X + col * (W + X);
        
//        UIView *iconBtn = [[UIView alloc] init];
//     //   [iconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",index]] forState:UIControlStateNormal];
//        iconBtn.backgroundColor =[UIColor colorWithHexString:@"#aaaaaa"];
//        iconBtn.frame = CGRectMake(viewX,Y, W, H);
//        iconBtn.layer.cornerRadius = 30;
//        iconBtn.clipsToBounds =YES;
//        [midsdtBottomView addSubview:iconBtn];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(viewX,Y, W, H);
        titleLabel.layer.cornerRadius = 30;
        titleLabel.clipsToBounds =YES;
        titleLabel.text = titleArray[index];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (index == 0)
        {
            titleLabel.textColor = [UIColor redColor];
        }
        titleLabel.numberOfLines = 0;
        [midsdtBottomView addSubview:titleLabel];
        
        
    }
    midsdtBottomView.frame = CGRectMake(0,self.grouopMidsdtViews.sh_bottom + 5,ScreenWidth,120);
    
    self.scrollView.contentSize = CGSizeMake(0,midsdtBottomView.sh_bottom);
}

#pragma mark 团购商品详情底部分
- (void)addGroupBottomView
{
    UIView *groupBottomView = [[UIView alloc] init];
    groupBottomView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    groupBottomView.frame = CGRectMake(0,ScreenHeight - 50,ScreenWidth, 50);
    
    [self.view addSubview:groupBottomView];
    
    detailsBtn *letfBtn = [detailsBtn buttonWithType:UIButtonTypeCustom];
    letfBtn.frame = CGRectMake(10,0,40,50);
    [letfBtn setImage:[UIImage imageNamed:@"kefu"] forState:UIControlStateNormal];
    [letfBtn setTitle:@"客服" forState:UIControlStateNormal];
    [letfBtn addTarget:self action:@selector(phoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [letfBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    letfBtn.titleLabel.textAlignment =NSTextAlignmentCenter;
    letfBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [groupBottomView addSubview:letfBtn];
    
    detailsBtn *rightfBtn = [detailsBtn buttonWithType:UIButtonTypeCustom];
    self.rightfBtns = rightfBtn;
    rightfBtn.frame = CGRectMake(letfBtn.sh_right + 20,0,40,50);
    [rightfBtn setImage:[UIImage imageNamed:@"SHOUCHANG1"] forState:UIControlStateNormal];
    [rightfBtn setImage:[UIImage imageNamed:@"SHOUCANG"] forState:UIControlStateSelected];
    [rightfBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [rightfBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [rightfBtn addTarget:self action:@selector(goodsEnshrine:) forControlEvents:UIControlEventTouchUpInside];
    rightfBtn.titleLabel.textAlignment =NSTextAlignmentCenter;
    rightfBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [groupBottomView addSubview:rightfBtn];
    
    NSInteger collection = [self.groupItemModel.is_collect integerValue];
    
   // NSLog(@"%ld",(long)collection);
    // 团购商品收藏 1否 ：0是
    if (collection == 1)
    {
        rightfBtn.selected = NO;
        
    }else
    {
        rightfBtn.selected = YES;
    }
    
    
    UIView *buyView = [[UIView alloc] init];
    buyView.frame = CGRectMake((ScreenWidth - 100) *0.5,0,(ScreenWidth - 100) *0.5,groupBottomView.sh_height);
    buyView.backgroundColor = [UIColor colorWithHexString:@"#FF5001"];
    [groupBottomView addSubview:buyView];
    
    
    UITapGestureRecognizer *buyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aloneBuyingClick:)];
    [buyView addGestureRecognizer:buyTap];

    UILabel *sumPriceTitle = [[UILabel alloc] init];
    sumPriceTitle.text = self.groupItemModel.price;
    sumPriceTitle.frame = CGRectMake(0,0,buyView.sh_width,20);
    sumPriceTitle.textColor = [UIColor whiteColor];
    sumPriceTitle.font = [UIFont systemFontOfSize:15];
    sumPriceTitle.textAlignment = NSTextAlignmentCenter;
    [buyView addSubview:sumPriceTitle];
    
    UILabel *oneBuyTitle = [[UILabel alloc] init];
    oneBuyTitle.text = @"单独购买";
    oneBuyTitle.frame = CGRectMake(0,sumPriceTitle.sh_bottom + 10,buyView.sh_width,20);
    oneBuyTitle.textAlignment = NSTextAlignmentCenter;
    oneBuyTitle.textColor = [UIColor whiteColor];
    oneBuyTitle.font = [UIFont systemFontOfSize:15];
    [buyView addSubview:oneBuyTitle];
    
    UIView *groupBuyingView = [[UIView alloc] init];
    groupBuyingView.frame = CGRectMake(buyView.sh_right,0,(ScreenWidth - 100) *0.37,groupBottomView.sh_height);
    groupBuyingView.backgroundColor = [UIColor redColor];
    [groupBottomView addSubview:groupBuyingView];
    
    UITapGestureRecognizer *groupTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupBuyingClick:)];
    [groupBuyingView addGestureRecognizer:groupTap];
    
    
    UILabel *twoBuyPriceTitle = [[UILabel alloc] init];
    twoBuyPriceTitle.text = self.groupItemModel.group_price;
    
  //  NSLog(@"%@",self.groupItemModel.group_price);
    
    twoBuyPriceTitle.textAlignment = NSTextAlignmentCenter;
    twoBuyPriceTitle.frame = CGRectMake(0,0,groupBuyingView.sh_width,20);
    twoBuyPriceTitle.textColor = [UIColor whiteColor];
    twoBuyPriceTitle.font = [UIFont systemFontOfSize:15];
    [groupBuyingView addSubview:twoBuyPriceTitle];
    
    UILabel *groupBuyingTitle = [[UILabel alloc] init];
    groupBuyingTitle.text = self.groupItemModel.group_num;
    groupBuyingTitle.frame = CGRectMake(0,twoBuyPriceTitle.sh_bottom + 10,groupBuyingView.sh_width,20);
    groupBuyingTitle.textAlignment = NSTextAlignmentCenter;
    groupBuyingTitle.textColor = [UIColor whiteColor];
    groupBuyingTitle.font = [UIFont systemFontOfSize:15];
    [groupBuyingView addSubview:groupBuyingTitle];
}


#pragma mark 2人团购点击事件
- (void)groupBuyingClick:(UITapGestureRecognizer *)tap
{

    [self checkTheTuxedoNumber];
}

#pragma mark 单独购买点击事件
- (void)aloneBuyingClick:(UITapGestureRecognizer *)tap
{
    [self popupView];
}

#pragma mark 团购商品收藏
- (void)goodsEnshrine:(UIButton *)btn
{
//    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
//    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    // 请求地址
    NSString *splitCompleteStr = @"";
    
    if (btn.isSelected == 1)
    {
        self.rightfBtns.selected = NO;
        [JKAlert alertText:@"已取消收藏"];
        splitCompleteStr = [NSString stringEncryptedAddress:@"/collect/cancelgoods"];
       
        
    }else if (btn.isSelected == 0)
    {
        self.rightfBtns.selected = YES;
        [JKAlert alertText:@"已加入收藏"];
         splitCompleteStr = [NSString stringEncryptedAddress:@"/collect/collectgoods"];
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSInteger  colletId = [self.groupBuyingId integerValue];
    
    NSDictionary *dict = @{@"collect_id":@(colletId)};
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
       // NSLog(@"%@",error);
        
    }];
    
}

#pragma mark 客服电话
- (void)phoneBtn

{NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.groupItemModel.customer_mobile];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
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

#pragma mark ----------分享----------------
    
#pragma mark 分享按钮
-(void)GoodsShareBtnClick:(NSNotification *)notifcation
{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        // 调用分享方法
        [self shareClickDetalis];

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

#pragma mark - UMSocialUIDelegate
/**
 * 分享
 */
- (void)shareClickDetalis {
    
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
    
    
    NSString *goods_image;
    NSString *goods_name;
    NSString *descrGoods_name;
    NSString *goods_sharUrl;
    
    if (self.productModel) {
        goods_name = self.productModel.goods_name;
        goods_image = self.productModel.goods_img;
        descrGoods_name = self.productModel.shop_name;
        goods_sharUrl = self.productModel.share_url;
    }else
    {
        goods_sharUrl = @"www.baidu.com";
        goods_image = self.groupItemModel.goods_all_img[@"img1"];
        goods_name = self.groupItemModel.goods_name;
        descrGoods_name = self.groupItemModel.shop_name;
    }
    
    //创建网页内容对象
    NSString* thumbURL =  goods_image;
   // NSLog(@"%@",thumbURL);
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:goods_name descr:descrGoods_name thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = goods_sharUrl;
    
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
//            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
             result = [NSString stringWithFormat:@"取消分享"];
            
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
         result = [NSString stringWithFormat:@"分享失败"];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.flag = @"0";
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"商品详情";
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
       
       NSForegroundColorAttributeName:KNavBarTitleColor}];
    
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -------------底部按钮--------------


#pragma mark 查看店铺
- (void)lookAtThestore:(NSNotification *)notification
{
    

    
    if ([self.flag isEqualToString:@"0"])
    {
        self.flag = @"1";
        MyShopController *shopVc = [[MyShopController alloc] init];
        shopVc.shopDetailed_Id = notification.userInfo[@"shopId"];
        [self.navigationController pushViewController:shopVc animated:YES];
        
    }
    
    

    
}


#pragma mark 加入购物车
-(void)shoppingBtn:(NSNotification *)notifcation
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/addgoodscart"];
        
        NSDictionary *dict= @{@"goods_id":self.productModel.id,@"num":@"1"};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [self.navigationController pushViewController:[[ShoppingCarController alloc] init] animated:YES];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //  NSLog(@"%@",error);
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




#pragma mark 消费中奖通知调用  立即购买弹框方法
-(void)modalView:(NSNotification*)notification
{
    [self popupView];
    
}

#pragma mark 立即购买弹框
- (void)popupView
{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        _hudView = [[UIView alloc] init];
        _hudView.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
        _hudView.backgroundColor = [UIColor blackColor];
        _hudView.alpha = 0.4;
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudViewTap:)];
        [_hudView addGestureRecognizer:singleTap];
        
        [self.view addSubview:_hudView];
        _modalView = [[[NSBundle mainBundle] loadNibNamed:@"ModalView" owner:nil options:nil] lastObject];
        
        if (self.productModel.goods_name.length)
        {
            _modalView.model = self.productModel;
        }else
        {
            _modalView.groupModel = self.groupItemModel;
        }
        
        _modalView.frame = CGRectMake(0,ScreenHeight - 310, ScreenWidth,310);
        [self.view addSubview:_modalView];

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

#pragma mark 遮挡View
- (void)hudViewTap:(UITapGestureRecognizer *)tap
{
    
    [_modalView removeFromSuperview];
    [_hudView removeFromSuperview];
    
}

#pragma mark 关闭按钮
- (void)closeBtn
{
    [_modalView removeFromSuperview];
    [_hudView removeFromSuperview];
}

#pragma mark 立即购买点击确定后传递要购买的个数
- (void)confimBtn:(NSNotification *)notification
{
    NSString *count = notification.userInfo[@"count"];
    TheOrderViewController *theorderVc = [[TheOrderViewController alloc] init];
    theorderVc.goods_num = count;
    
    if (self.productModel.id) {
        
        theorderVc.goodsId = self.productModel.id;
    }else
    {
        theorderVc.goodsId = self.groupItemModel.id;
    }
    
    if (self.groupItemModel.id)
    {
       // NSLog(@"%@",self.groupItemModel.id);
        theorderVc.goodsId = self.groupBuyingId;
    }
    
    
    [self.navigationController pushViewController:theorderVc animated:YES];
}



- (void)addScrollView
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    self.scrollView = scrVc;
    scrVc.frame = CGRectMake(0, 99,ScreenWidth,ScreenHeight - 150);
    [self.view addSubview:scrVc];
    scrVc.bounces = NO;
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
}

#pragma mark ------------消费中奖----------------
- (void)addMidsdtView
{
    _detailsMidstView = [[[NSBundle mainBundle] loadNibNamed:@"DetailsMidstView" owner:nil options:nil] lastObject];
    
    _detailsMidstView.frame = CGRectMake(0, _detailsView.sh_bottom + 10, ScreenWidth,220);
    _detailsMidstView.model = self.productModel;
    [self.scrollView addSubview:_detailsMidstView];
    self.scrollView.contentSize = CGSizeMake(0,_detailsMidstView.sh_bottom);
    
}

- (void)addBottomView
{
    _detailsBottomView = [[[NSBundle mainBundle] loadNibNamed:@"DetailsBottomView" owner:nil options:nil] firstObject];
    _detailsBottomView.goodsModel = self.productModel;
    _detailsBottomView.frame = CGRectMake(0, ScreenHeight - 50,ScreenWidth,50);
    
    [self.view addSubview:_detailsBottomView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
