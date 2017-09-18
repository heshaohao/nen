//
//  MeViewController.m
//  nen
//
//  Created by nenios101 on 2017/2/27.
//
//我的

#import "MeViewController.h"
#import "MeHeadView.h"
#import "MyCareerView.h"
#import "AppointmentView.h"
#import "ProfessionalView.h"
#import "PlatformView.h"
#import "SmallShopViewController.h"
#import "MyProfessionalController.h"
#import "DoConsultantController.h"
#import "DoTeacherController.h"
#import "DoMasterController.h"
#import "AllOrderViewController.h"
#import "SetMyCenterViewController.h"
#import "MYMoneyBagViewController.h"
// 我的事业
#import "MyTheViewMemberController.h"

#import "MyTheCompanyViewController.h"
#import "MessageManagementViewController.h"

// 实名验证
#import "RealNameAuthenticationController.h"

// 暂时购物单
#import "MYShoppingListViewController.h"
#import "MyShoppView.h"

// 我的微店
#import "SmallShopViewController.h"
#import "MyShopController.h"
#import "MyCollectionViewController.h"
#import "ShoppingCarController.h"

// 微店订单管理
#import "BootomViewController.h"
#import "CommentsTheManagementController.h"

//没有登录状态显示
#import "UseHelpViewController.h"
#import "RegisterViewController.h"
#import "LoginAndRegisterViewController.h"

@interface MeViewController ()

@property(nonatomic,strong)MeHeadView *meHeadView;

@property(nonatomic,weak) UIScrollView  *scrollView;

@property(nonatomic,strong)MyCareerView *careerView;


@property(nonatomic,strong)AppointmentView *appointView;

@property(nonatomic,strong)ProfessionalView *professView;

@property(nonatomic,strong)PlatformView *platformView;

@property(nonatomic,strong) NSDictionary *buyCount;


@property(nonatomic,strong) NSMutableDictionary *myDataDict;

@property(nonatomic,strong) UIButton *hudBtn;
@property(nonatomic,strong) UIView *backgroundView;

// 购物单
@property(nonatomic,strong)MyShoppView *shoppView;
// 购物单数据
@property(nonatomic,strong) NSArray *stateArray;

@property(nonatomic,copy) NSString *is_audit;

@property(nonatomic,strong) UIWindow *wind;

@property(nonatomic,assign) NSInteger flag;

@property (nonatomic,strong) UIView *headView;


// 标记
@property (nonatomic,copy) NSString *flag1;
@property (nonatomic,copy) NSString *flag2;

@property(nonatomic,strong) NSUserDefaults *defaluts;

@property (nonatomic,copy) NSString *recordStr;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wind = [UIApplication sharedApplication].keyWindow;
    
    _defaluts = [NSUserDefaults standardUserDefaults];
    self.recordStr = [_defaluts objectForKey:@"is_login"];
    
    self.flag1 = @"0";
    self.is_audit = [_defaluts objectForKey:@"is_audit"];
    
    [self establishScrollView];
    
  
    if ([self.recordStr isEqualToString:@"1"])
    {
        self.headView.hidden = YES;
        self.scrollView.hidden = NO;
        
        self.navigationController.navigationBarHidden = YES;
        
        [self loadData];
        
        self.scrollView.contentSize = CGSizeMake(0, _platformView.sh_bottom + 10);
    }
    
    [self notLoginStateBackgroundView];
    
    // 二维码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickTwoCodes) name:@"twoCodes" object:nil];
    
//    // 商品管理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smallBtn) name:@"weidian" object:nil];
   // 我的的微店
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(professBtn) name:@"profess" object:nil];
   // 我的微店 订单管理
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consultantBtn) name:@"consultant" object:nil];
    // 我的微店评论管理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doTeacherBtn) name:@"doTeacher" object:nil];
    // 全部订单
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipAllOrder) name:@"allOrder" object:nil];
//    // 个人中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBtnClick) name:@"set" object:nil];
    
    // 推送消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beingPushed) name:@"pushMessages" object:nil];
//    // 钱包
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moneyWrapClick) name:@"moneyWrap" object:nil];
//    // 我的事业
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myTheMemberClick:) name:@"myTheMember" object:nil];
//    // 品牌公司
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreClick) name:@"more" object:nil];
//    
//    // 我的购物单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAllOrderVc:) name:@"allOderVc"object:nil];
//    
//    // 购物车
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushShoopingCatViewControll) name:@"PushShoopingCatVc"object:nil];
//    
//    // 我的收藏
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meCollection) name:@"myCollection" object:nil];
//    
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/orderstate"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
       // NSLog(@"%@",responseObject);
//        
        self.buyCount = responseObject[@"obj"];
//        
//        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
       NSLog(@"%@",error);
//        
    }];
}

#pragma mark 没有登录界面
- (void)notLoginStateBackgroundView
{
    self.navigationController.navigationBarHidden = NO;
    //   [self.scrollView removeFromSuperview];
    //    [self.headView removeFromSuperview];
    
    self.scrollView.hidden = YES;
    self.headView.hidden = NO;
    UIView *headView = [[UIView alloc] init];
    self.headView = headView;
    headView.backgroundColor =[UIColor colorWithHexString:@"#F0F0F0"];
    
    // 没有登录时显示
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.frame = CGRectMake(0,64,ScreenWidth,150);
    headImage.image = [UIImage imageNamed:@"notLonginStateBackgroundImage"];
    [headView addSubview:headImage];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.frame = CGRectMake(0,headImage.sh_bottom + 50,ScreenWidth,60);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.numberOfLines = 0;
    promptLabel.textColor = [UIColor lightGrayColor];
    promptLabel.text = @"登录后，你可以把你喜欢的商品分享给其他人\n\n购买商品时候还有现金红包等你拿，赶快注册^ - ^";
    [headView addSubview:promptLabel];
    
    UIButton *registeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registeredBtn.frame = CGRectMake(ScreenWidth *0.15,promptLabel.sh_bottom + 60,ScreenWidth *0.3,40);
    [registeredBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registeredBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    registeredBtn.layer.borderWidth = 1.0f;
    registeredBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [registeredBtn addTarget:self action:@selector(mePushRegosterdVc) forControlEvents:UIControlEventTouchUpInside];
    registeredBtn.layer.cornerRadius = 5;
    registeredBtn.clipsToBounds = YES;
    [headView addSubview:registeredBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(ScreenWidth *0.55,promptLabel.sh_bottom + 60,ScreenWidth *0.3,40);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(mePushLoginVc) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    [headView addSubview:loginBtn];
    
    headView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    [self.view addSubview:headView];
    
    
}


#pragma mark 加载数据
- (NSInteger)flag
{
    if (!_flag)
    {
        _flag = 0;
    }
    return _flag;
}

- (void)loadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/baseinfo"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager GET:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        NSMutableDictionary *dict = responseObject[@"obj"];
        
//        self.name = dict[@"nickname"];
//        self.head_image = dict[@"head_img"];
//        self.twoCodeStr = dict[@"qr_code"];
        
        self.myDataDict = dict;
    
        [self shoppingData];
        
        // 隐藏联盟平台
       // [self addplatforView];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
    
    }];
}


#pragma mark 购物订单数据
- (void)shoppingData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/general"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager GET:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        self.stateArray = responseObject[@"list"];
        
//        [_meHeadView removeFromSuperview];
//        [_careerView removeFromSuperview];
//        [_shoppView removeFromSuperview];
//        [_professView removeFromSuperview];
        
       // NSLog(@"%@",self.flag1);
        
        // 登录完成 初始化
        if ([self.flag1 isEqualToString:@"0"])
        {
            [self addHeadView];
            //
            [self addCareerView];
            //
            // [self addAppointmentView];
            [self addShoppingView];
            //
            [self addProfessionalView];
            
            self.flag1 = @"1";
            
        }
        
        
        // 加载完成后跳转回来显示最新数据 重新刷新数据
        if ([self.flag1 isEqualToString:@"1"])
        {
            [self.meHeadView removeFromSuperview];
            [self.careerView removeFromSuperview];
            [self.shoppView removeFromSuperview];
            [self.professView removeFromSuperview];
            
            
            [self addHeadView];
            [self addCareerView];
            [self addShoppingView];
            [self addProfessionalView];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark ---------------------------头部模块-----------------------
#pragma mark 二维码
- (void)clickTwoCodes
{

   // NSLog(@"%@",_wind.subviews);
    
    NSString *btnP = [NSString stringWithFormat:@"%p",_hudBtn];
   
    _hudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hudBtn.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    [_hudBtn setBackgroundColor:[UIColor blackColor]];
    [_hudBtn setAlpha:0.6];
    [_hudBtn addTarget:self action:@selector(deleteHudBtns) forControlEvents:UIControlEventTouchUpInside];
    [_wind addSubview:_hudBtn];
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.frame = CGRectMake(30,ScreenHeight *0.15,ScreenWidth - 60,ScreenHeight *0.7);
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [_wind addSubview:_backgroundView];
        
        NSString *iconImageStr = self.myDataDict[@"head_img"];
        // 头像
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.frame = CGRectMake(20,20,70,70);
        iconImage.layer.cornerRadius = 35;
        iconImage.clipsToBounds = YES;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:iconImageStr]];
        [_backgroundView addSubview:iconImage];
        
        // 名称
        NSString *nameStr = [NSString stringWithFormat:@"%@",self.myDataDict[@"nickname"]];
        UILabel *nameLabel = [[UILabel alloc] init];
        
        if (nameStr.length == 0 || [nameStr isEqualToString:@"<null>"] )
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            nameLabel.text = [defaults objectForKey:@"userNumber"];
            
            
        }else
        {
            nameLabel.text = nameStr;
        }
        nameLabel.frame = CGRectMake(iconImage.sh_right + 20,iconImage.sh_y + 10,150,25);
        nameLabel.font = [UIFont systemFontOfSize:15];
        [_backgroundView addSubview:nameLabel];
        
        // 二维码
        UIImageView *codeImage = [[UIImageView alloc] init];
        CGFloat codeImageY = _backgroundView.sh_height *0.5 - ((_backgroundView.sh_width *0.5)*0.5);
        codeImage.frame = CGRectMake(_backgroundView.sh_width *0.25,codeImageY,_backgroundView.sh_width *0.5,_backgroundView.sh_width *0.5);
        codeImage.image = [UIImage imageNamed:@"1"];
        [_backgroundView addSubview:codeImage];
        // 1. 创建一个二维码滤镜实例(CIFilter)
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 滤镜恢复默认设置
        [filter setDefaults];
        // 2. 给滤镜添加数据
        NSString *codeStr = self.myDataDict[@"qr_code"];
        NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKeyPath:@"inputMessage"];
        
        // 3. 生成二维码
        CIImage *image = [filter outputImage];
        
        // 4. 显示二维码
        codeImage.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:_backgroundView.sh_width *0.5];
        
        // 底部文本
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.frame = CGRectMake(20,codeImage.sh_bottom + 30,_backgroundView.sh_width - 40,25);
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.text = @"加入刚需济众,成就有钱有闲有大爱";
        bottomLabel.font = [UIFont systemFontOfSize:15];
        [_backgroundView addSubview:bottomLabel];
        
    

}

#pragma mark 转换高清二维码
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    //设置比例
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap（位图）;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}

#pragma mark 移除遮挡View

- (void)deleteHudBtns
{
    [_hudBtn removeFromSuperview];
    _hudBtn = nil;
    [_backgroundView removeFromSuperview];
    _backgroundView = nil;
}


#pragma mark ------------------------- 我的事业  营销公司 服务公司 招商公司-----------------
- (void)myTheMemberClick:(NSNotification *)notification
{
    NSString *companyTypeStr = notification.userInfo[@"companyType"];
//    myCareerViewController *careerVc = [[myCareerViewController alloc] init];
//    careerVc.page = @"1";
//    careerVc.type = companyTypeStr;
    
    MyTheViewMemberController * careerVc = [[MyTheViewMemberController alloc] init];
    careerVc.membersType = companyTypeStr;
    [self.navigationController pushViewController:careerVc animated:YES];
    
}

#pragma mark 我的事业  品牌公司
    - (void)moreClick
{
   
    [self.navigationController pushViewController:[[MyTheCompanyViewController alloc] init] animated:YES];
}



#pragma mark -------------------------我的微店模块--------------------

#pragma mark 钱包
- (void)moneyWrapClick
{
   [self.navigationController pushViewController:[[MYMoneyBagViewController alloc] init] animated:YES];
}


#pragma mark 我的收藏
- (void)meCollection
{
    [self.navigationController pushViewController:[[MyCollectionViewController alloc] init] animated:YES];
}


#pragma mark 个人中心
- (void)setBtnClick
{
    SetMyCenterViewController *setVc = [[SetMyCenterViewController alloc] init];
    
    setVc.iconStr = self.myDataDict[@"head_img"];
    [self.navigationController pushViewController:setVc animated:YES];
    
}

#pragma mark 推送消息
- (void)beingPushed
{
    [self.navigationController pushViewController:[[MessageManagementViewController alloc] init] animated:YES];
}


#pragma mark 全部订单
- (void)skipAllOrder
{
    [self.navigationController pushViewController:[[AllOrderViewController alloc] init] animated:YES];
}

#pragma mark 商品管理
- (void)smallBtn
{
    
   // NSLog(@"%@",self.is_audit);
    
    if ([self.is_audit isEqualToString:@"0"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲爱的用户,为了保障消费者的权益,您需要【实名认证】后进行操作哦~" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController pushViewController:[[RealNameAuthenticationController alloc] init] animated:YES];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        [self.navigationController pushViewController:[[MyShopController alloc] init] animated:YES];
        
    }
    
    
}
#pragma mark 微店订单管理
- (void)consultantBtn
{
    
    
    if ([self.is_audit isEqualToString:@"0"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲爱的用户,为了保障消费者的权益,您需要【实名认证】后进行操作哦~" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController pushViewController:[[RealNameAuthenticationController alloc] init] animated:YES];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
       [self.navigationController pushViewController:[[BootomViewController alloc] init] animated:YES];
        
    }

    
}

#pragma mark 我的微店 || 更多
- (void)professBtn
{
    if ([self.is_audit isEqualToString:@"0"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲爱的用户,为了保障消费者的权益,您需要【实名认证】后进行操作哦~" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        [self.navigationController pushViewController:[[RealNameAuthenticationController alloc] init] animated:YES];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
         [self.navigationController pushViewController:[[SmallShopViewController alloc] init] animated:YES];
    }

    
}


#pragma mark 评论管理
- (void)doTeacherBtn
{
    
    
    if ([self.is_audit isEqualToString:@"0"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲爱的用户,为了保障消费者的权益,您需要【实名认证】后进行操作哦~" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController pushViewController:[[RealNameAuthenticationController alloc] init] animated:YES];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
        [self.navigationController pushViewController:[[CommentsTheManagementController alloc] init] animated:YES];
    }

    
    
}

#pragma mark 购物车
- (void)PushShoopingCatViewControll
{
    [self.navigationController pushViewController:[[ShoppingCarController alloc] init] animated:YES];
}


#pragma mark --------------------------添加模块-------------------

- (void)establishScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
   
    
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self.view addSubview:scrollView];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succesLoginHeight:) name:@"successLogin" object:nil];
    

    self.recordStr = [_defaluts objectForKey:@"is_login"];
    
    if ([self.recordStr isEqualToString:@"1"])
    {
        self.navigationController.navigationBarHidden = YES;
        self.headView.hidden = YES;
        self.scrollView.hidden = NO;
        
        if ([self.flag1 isEqualToString:@"0"])
        {
            
          //  [self establishScrollView];
            self.navigationController.navigationBarHidden = YES;
            
            [self loadData];
            
           // self.scrollView.contentSize = CGSizeMake(0, _platformView.sh_bottom + 10);
            
        }else
        {
            [self loadData];
            
        }

    }
    else
    {
        self.navigationController.navigationBarHidden = NO;
       //  self.flag1 = @"1";
         //   [self.scrollView removeFromSuperview];
       //    [self.headView removeFromSuperview];
        
        self.scrollView.hidden = YES;
        self.headView.hidden = NO;
        
        }
    
}
#pragma mark 跳转注册页面
- (void)mePushRegosterdVc
{
    [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:YES];
    
}
#pragma mark 跳转登录页面
-(void)mePushLoginVc
{
//    LoginAndRegisterViewController *loginVc = [[LoginAndRegisterViewController alloc] init];
//    loginVc.flag = @"1";
    [self.navigationController pushViewController:[LoginAndRegisterViewController sharedManager] animated:YES];
    
}

#pragma mark 设置导航栏
- (void)setNavBar
{
   
    self.recordStr = [_defaluts objectForKey:@"is_login"];
    
    if ([self.recordStr isEqualToString:@"1"])
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.navigationItem.title = @"我";
        self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F0F0F0"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(mePushAboutVC)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
        
    }
    
}

#pragma mark 跳转关于我们界面
- (void)mePushAboutVC
{
    
    [self.navigationController  pushViewController:[[UseHelpViewController alloc] init] animated:YES];
    
}


// 头部

- (void)addHeadView
{
    MeHeadView  *meHeadView = [[[NSBundle mainBundle] loadNibNamed:@"MeHeadView" owner:nil options:nil] lastObject];
    self.meHeadView = meHeadView;
//    
//    meHeadView.imageStr = self.head_image;
//    meHeadView.myTheLink = self.twoCodeStr;
//    if (self.name.length == 0)
//    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        self.name = [defaults objectForKey:@"userNumber"];
//        meHeadView.nameStr = self.name;
//        
//    }else
//    {
//        meHeadView.nameStr = self.name;
//    }
    
 //   NSLog(@"%f",meHeadView.sh_y);
    
    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OB9RFE0.jpg"]];
    meHeadView.dataDict = self.myDataDict;
    meHeadView.backgroundColor = bgColor;
    meHeadView.sh_width = ScreenWidth;
    meHeadView.sh_height = 120;
    meHeadView.sh_x = 0;
    meHeadView.sh_y = 0;
    [self.scrollView addSubview:meHeadView];
    
}
// 我的事业
- (void)addCareerView
{
    _careerView = [[[NSBundle mainBundle] loadNibNamed:@"MyCareerView" owner:nil options:nil] firstObject];
    _careerView.sh_width = ScreenWidth;
    _careerView.sh_height = 140;
    _careerView.sh_x = 0;
    _careerView.sh_y = self.meHeadView.sh_bottom;
    [self.scrollView addSubview:_careerView];
}
//  我的购物单

- (void)addShoppingView
{
    _shoppView = [[[NSBundle mainBundle] loadNibNamed:@"MyShoppView" owner:nil options:nil] lastObject];
   // NSLog(@"%@",self.stateArray);
    _shoppView.staeCountArray = self.stateArray;
    
   
        _shoppView.sh_width = ScreenWidth;
        _shoppView.sh_height = 120;
        _shoppView.sh_x = 0;
        _shoppView.sh_y = _careerView.sh_bottom + 10;
        [self.scrollView addSubview:_shoppView];
        
    
}


#pragma mark 根据点击不同的按钮跳转购物单对应的控制器
- (void)pushAllOrderVc:(NSNotification *)notification
{
    NSString *pageStr = notification.userInfo[@"page"];
    
    MYShoppingListViewController *shoppingListVc = [[MYShoppingListViewController alloc] init];
    shoppingListVc.page = pageStr ;
    
    [self.navigationController pushViewController:shoppingListVc animated:YES];
    
}

// 暂时替换
//- (void)addAppointmentView
//{
//    _appointView = [[[NSBundle mainBundle] loadNibNamed:@"AppointmentView" owner:nil options:nil] lastObject];
//    _appointView.dict = self.buyCount;
//    _appointView.sh_width = ScreenWidth;
//    _appointView.sh_height = 110;
//    _appointView.sh_x = 0;
//    _appointView.sh_y = _careerView.sh_bottom + 10;
//    [self.scrollView addSubview:_appointView];
//}
//


//  我的职业
-(void)addProfessionalView
{
    _professView = [[[NSBundle mainBundle] loadNibNamed:@"ProfessionalView" owner:nil options:nil] lastObject];
    _professView.sh_width = ScreenWidth;
    _professView.sh_height = 225;
    _professView.sh_x = 0;
    _professView.sh_y = _shoppView.sh_bottom + 10;
    [self.scrollView addSubview:_professView];
    self.scrollView.contentSize = CGSizeMake(0,_professView.sh_bottom);
}


//  联盟平台
//- (void)addplatforView
//{
//    _platformView = [[[NSBundle mainBundle] loadNibNamed:@"PlatformView" owner:nil options:nil] lastObject];
//    _platformView.sh_width = ScreenWidth;
//    _platformView.sh_height = 250;
//    _platformView.sh_x = 0;
//    _platformView.sh_y = _professView.sh_bottom + 10;
//    [self.scrollView addSubview:_platformView];
 //   self.scrollView.contentSize = CGSizeMake(0,_platformView.sh_bottom);
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
