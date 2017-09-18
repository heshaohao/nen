//
//  MarketingPlanViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/6.
//  Copyright © 2017年 nen. All rights reserved.
//营销方案

#import "MarketingPlanViewController.h"
#import "PlanView.h"
#import "ConsumptionWiningController.h"
#import "GoodsProductModel.h"
#import "MarketingModel.h"
#import "TheOrderViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "GroupBuyingItemGoodsItemModel.h"
@interface MarketingPlanViewController ()

@property(nonatomic,strong) PlanView *planView;


@property(nonatomic,strong) GoodsProductModel *prodsModel;
@property(nonatomic,strong) MarketingModel *marketingModel;
@property(nonatomic,strong) GroupBuyingItemGoodsItemModel *groupItemModel;

@property(nonatomic,strong) UIButton *playBtn;

@property(nonatomic,strong) UIScrollView *scrollView;

//头部模块的高度
@property(nonatomic,assign) CGFloat planViewBottomH;
//选购窍门底部
@property(nonatomic,strong) UIView *trickView;

@property(nonatomic,assign) CGFloat playBtnY;

@end

@implementation MarketingPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setNavBar];
    [self addScrollView];
   
    if (!self.groupGoodsId.length) {
        [GoodsProductModel goodsproductListGoodsId:self.goodsId success:^(GoodsProductModel *goodsList) {
            self.prodsModel = goodsList;
            [self addPlanView];
            [self loadMarketingData];
            
        } error:^{
        }];
        
    }else
    {
        [GroupBuyingItemGoodsItemModel groupBuyingItemGoodsId:self.groupGoodsId success:^(GroupBuyingItemGoodsItemModel *groupBuyingModel) {
            self.groupItemModel = groupBuyingModel;
            [self addPlanView];
            [self loadMarketingData];
            
        } error:^{
            NSLog(@"失败");
        }];
    }
    
   
    
}

// 加载底部模块的数据
- (void)loadMarketingData
{
    if (!self.groupGoodsId.length) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MarketingModel marketingListGoodsId:self.goodsId success:^(MarketingModel *markeModel) {
                self.marketingModel = markeModel;
                
                [self theTrick];
                
            } error:^{
             //   NSLog(@"失败");
                
            }];
        });
    }else
    {
    [MarketingModel marketingListGoodsId:self.groupGoodsId success:^(MarketingModel *markeModel) {
    self.marketingModel = markeModel;
    [self theTrick];
        
    } error:^{
   // NSLog(@"失败");
               
                
        }];
        

    }
    
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"选购窍门";
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



#pragma mark 立即购买按钮
- (void)buyBtnClick
{
    
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        TheOrderViewController *theVc = [[TheOrderViewController alloc] init];
        if (self.goodsId !=nil)
        {
            theVc.goodsId = self.goodsId;
        }else
        {
            theVc.goodsId = self.groupGoodsId;
            theVc.is_groupStr = @"1";
        }
        theVc.goods_num = @"1";
        [self.navigationController  pushViewController:theVc animated:YES];
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

#pragma mark 分享按钮
- (void)PlanShareBtnClick
{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        [self markShareClick];
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
- (void)markShareClick {
    
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
    NSString* thumbURL =  self.prodsModel.goods_img;
  //  NSLog(@"%@",thumbURL);
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.prodsModel.shop_name descr:self.prodsModel.goods_name thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.prodsModel.share_url;
    
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

-(void)addScrollView
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    scrVc.bounces = NO;
    self.scrollView = scrVc;
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        scrVc.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight - 50);
        
    }else
    {
        scrVc.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight);
    }
    
    
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrVc];
}

#pragma mark 选购窍门头部

- (void)addPlanView
{
    _planView = [[[NSBundle mainBundle] loadNibNamed:@"PlanView" owner:nil options:nil] lastObject];
    
    if (!self.groupItemModel.goods_name.length)
    {
        _planView.productModel = self.prodsModel;
        
    }else
    {
        _planView.groupModel = self.groupItemModel;
    }
    
    self.planViewBottomH = [_planView returnPlanViewHeght];
    
    
    [self.scrollView addSubview:_planView];
    
    _planView.frame = CGRectMake(0,99,ScreenWidth, self.planViewBottomH);
    
    self.scrollView.contentSize = CGSizeMake(0,self.planViewBottomH + 99);
    
}

#pragma mark 选购窍门底部
- (void)theTrick
{
    UIView *planBottomView = [[UIView alloc] init];
    self.trickView = planBottomView;
    planBottomView.frame = CGRectMake(0,_planView.sh_bottom,ScreenWidth,500);
    planBottomView.backgroundColor = [UIColor whiteSmoke];
    [self.scrollView addSubview:planBottomView];
  //  NSLog(@"%f",planBottomView.sh_bottom);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth,planBottomView.sh_bottom);
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(20,10,ScreenWidth - 40,30);
    leftLabel.text = @"选购窍门";
    leftLabel.textColor = [UIColor blackColor];
    [planBottomView addSubview:leftLabel];
    
    NSString *goodsImageStr = self.prodsModel.goods_all_img[@"img1"];
    
    UIImageView *goodsImage = [[UIImageView alloc] init];
    goodsImage.frame = CGRectMake(10,leftLabel.sh_bottom + 10,ScreenWidth - 20,230);
    [goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsImageStr]];
    [planBottomView addSubview:goodsImage];
    goodsImage.sh_height = goodsImageStr.length == 0 ? 0 :230;
    
    CGFloat mantileY = goodsImage.sh_height != 0 ? goodsImage.sh_bottom + 10 : leftLabel.sh_bottom + 10;
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    NSString *mainTitleStr = self.marketingModel.details1;
    mainTitleLabel.text = mainTitleStr;
    mainTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    mainTitleLabel.numberOfLines = 0;
    mainTitleLabel.sh_x = 10;
    mainTitleLabel.sh_y = mantileY;
    NSDictionary *mainTitleAttrs = @{NSFontAttributeName : mainTitleLabel.font};
    CGSize maxSize = CGSizeMake(ScreenWidth - 20, MAXFLOAT);
    CGSize mainTitleSize = [mainTitleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:mainTitleAttrs context:nil].size;
    mainTitleLabel.sh_height = mainTitleSize.height;
    mainTitleLabel.sh_width = mainTitleSize.width;
    mainTitleLabel.font = [UIFont systemFontOfSize:15];
    mainTitleLabel.textColor = [UIColor lightGrayColor];
    [planBottomView addSubview:mainTitleLabel];
    mainTitleLabel.hidden = self.marketingModel.details1.length == 0 ? YES : NO;
   
    
    if (mainTitleLabel.sh_height != 0)
    {
        _playBtnY = mainTitleLabel.sh_bottom + 10;
        
    }else if (goodsImage.sh_height !=0)
    {
        _playBtnY = goodsImage.sh_bottom +10;
    }else
    {
        _playBtnY = leftLabel.sh_bottom + 10;
    }
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame = CGRectMake(10,_playBtnY,ScreenWidth - 20,300);
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"pay.jpg"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playWebView) forControlEvents:UIControlEventTouchUpInside];
    [planBottomView addSubview:_playBtn];
    
    planBottomView.sh_height = _playBtnY + 310;
    
   // NSLog(@"%f",_playBtn.sh_bottom);
    
    self.scrollView.contentSize = CGSizeMake(0,planBottomView.sh_bottom);
}


- (void)playWebView
{
    
    [_playBtn removeFromSuperview];
    
    UIWebView  *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, _playBtnY, ScreenWidth - 20, 300)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.trickView addSubview: webView];
    [webView loadRequest:request];
    
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlanShareBtnClick) name:@"planShare" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyBtnClick) name:@"buy" object:nil];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
