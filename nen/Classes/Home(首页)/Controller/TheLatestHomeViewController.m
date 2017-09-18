//
//  TheLatestHomeViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "TheLatestHomeViewController.h"
#import "OptionModel.h"
#import "OptionView.h"
#import "YFRollingLabel.h"
#import "ShopItemModel.h"
#import "ShopArrayModel.h"
#import "ClassifiCationOfGoodsUITableViewCell.h"
#import "ShoppingViewController.h"
#import "ClassificationOfMoreViewController.h"
#import "TrainingEducationViewController.h"
#import "ShoppingCarController.h"
#import "MessageManagementViewController.h"
#import "InfoturnModel.h"
#import "ReleaseGoodsViewController.h"

#import "DHGuidePageHUD.h"

#import "MainViewController.h"



@interface TheLatestHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property(nonatomic,strong) NSArray<ShufflingFigureModel *> *shuffingMoldelArray;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) ShufflingFigureModel *shufflingModel;
// 模型数组
@property (nonatomic, strong) NSArray *appList;
// 选项区
@property(nonatomic,strong) UIView *opctionview;

@property(nonatomic,strong) UIView  *horseView;

@property (nonatomic, strong) YFRollingLabel *horseRaceLampLabel;

@property(nonatomic,strong) NSMutableArray <ShopArrayModel *> *shopArray;

@property(nonatomic,strong) NSMutableArray <ShopItemModel *>*shopItemArray;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) MBProgressHUD *hub;


@property(nonatomic,copy) NSString *signal;
@property (nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property (nonatomic,strong) NSUserDefaults *defaluts;

@property (nonatomic,copy) NSString *recordStr;

@end

#define Height 150

@implementation TheLatestHomeViewController

#pragma mark 获取key 和 secret
- (void)setData{
    
   
     self.recordStr = [_defaluts objectForKey:@"key"];
    
   
    
    [_defaluts synchronize];
    
    
    if (!self.recordStr.length) {
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        [manager GET:@"http://api.neno2o.com/site/token" parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
            
            NSDictionary *dict = responseObject[@"obj"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:[NSString stringWithFormat:@"%@",dict[@"key"]] forKey:@"key"];
            [defaults setObject:dict[@"secret"] forKey:@"secret"];
            [defaults synchronize];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            // NSLog(@"获取数据失败");
        }];
    }
    
}


#pragma mark 模拟数据数组
- (NSArray *)appList
{
    if (_appList == nil) {
        NSMutableArray *mutArray = [NSMutableArray array];
        NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app.plist" ofType:nil]];
        for (NSDictionary *dict in array) {
            [mutArray addObject:[OptionModel modelWithDict:dict]];
        }
        _appList = mutArray;
    }
    return _appList;
}
- (NSArray *)shopArray
{
    if (!_shopArray) {
    _shopArray = [NSMutableArray array];
    }
    
    return _shopArray;
}

#pragma mark 图片轮播器数组
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightPink];
    
     _defaluts = [NSUserDefaults standardUserDefaults];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        // 静态引导页
        [self setStaticGuidePage];
        
         [self setData];
       
        [_defaluts setObject:@"" forKey:@"key"];
        [_defaluts setObject:@"0" forKey:@"is_login"];
        [_defaluts synchronize];
        
        // 动态引导页
        // [self setDynamicGuidePage];
        
        // 视频引导页
        // [self setVideoGuidePage];
        
        
    }
    
    
    [ShufflingFigureModel shufflingFigureLocation:@"0" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        self.shuffingMoldelArray = shufflingFigure;
        
        [self addhead];
        
        [self optionView];
        
        [self horseRaceLamp];
        
        UITableView *tableVc = [[UITableView alloc] init];
        self.tableView = tableVc;
        tableVc.separatorStyle = UITableViewCellSeparatorStyleNone;
      //  tableVc.frame = CGRectMake(0,_horseView.sh_bottom,ScreenWidth,self.shopArray.count * 178);
        tableVc.bounces = NO;
        tableVc.scrollEnabled = NO;
        tableVc.rowHeight = 178;
        tableVc.backgroundColor = [UIColor lightGrayColor];
        tableVc.delegate = self;
        tableVc.dataSource = self;
        [self.scrollView addSubview:tableVc];
        self.scrollView.contentSize = CGSizeMake(0,tableVc.sh_bottom);
        self.scrollView.bounces = NO;
        
       [self goodsLoadData];

        
    } error:^{
       // NSLog(@"失败");
    }];

    
    [self addScrollView];
}

#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"guide1",@"guide2",@"guide3",@"guide4"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.slideInto = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.view addSubview:guidePage];
    
}
#pragma mark 引导页消息后显示Tabr
- (void)removePageHUDVc
{
    self.tabBarController.tabBar.hidden = NO;
}


#pragma 商品列表 数据
- (void)goodsLoadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shop/recommend"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak typeof(self) weakself = self;
    [manager POST:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        NSArray *dataArray = responseObject[@"list"];
        
        self.shopArray = [ShopArrayModel mj_objectArrayWithKeyValuesArray:dataArray];
        if (self.shopArray.count > 0)
        {   [weakself removeBackgroundView];
            weakself.tableView.frame = CGRectMake(0,_horseView.sh_bottom,ScreenWidth,self.shopArray.count * 178);
            [weakself.tableView reloadData];
            weakself.scrollView.contentSize = CGSizeMake(0,weakself.tableView.sh_bottom);
            
        }else
        {
            weakself.signal = @"1";
            [weakself.shopArray removeAllObjects];
            [weakself.tableView reloadData];
            [weakself removeBackgroundView];
            [weakself setEmptyView];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
       // NSLog(@"%@",error);
        
        weakself.signal = @"1";
        if (weakself.shopArray.count == 0)
        {
            [weakself.shopArray removeAllObjects];
        }
        [weakself.tableView reloadData];
        [weakself removeBackgroundView];
        [weakself setEmptyView];

        
    }];
}


#pragma mark 没有数据时显示
- (void)setEmptyView
{
    NSString * showTextStr;
    if ([self.signal isEqualToString:@"1"])
    {
        showTextStr = @"暂无商品!";
    }else
    {
        showTextStr = @"您的网络信号不好!";
        
    }
        //默认视图背景
        _backgroundView = [[ThereIsNoDataBackgroundView alloc] initWithThereIsNoDataBackgroundViewImageIcon:KNoDataBackgroundImage ImageX:ScreenWidth*0.25 ImageY:ScreenHeight *0.45 ImageW:ScreenWidth *0.5 imageH:ScreenWidth *0.5 ShowBottomText:showTextStr];
        [self.scrollView addSubview:_backgroundView];
        
    }
    
    
    
#pragma mark 移除backgroundView
    - (void)removeBackgroundView
    {
        [_backgroundView removeFromSuperview];
    }



#pragma mark 跳转购物车
- (void)PushShoppingCarVc
{
    [self.navigationController pushViewController:[[ShoppingCarController alloc] init] animated:YES];
}

#pragma mark 消息推送
 -(void)messagePushVc
{
       self.recordStr = [_defaluts objectForKey:@"is_login"];
    
    if ([self.recordStr isEqualToString:@"1"])
    {
        [self.navigationController pushViewController:[[MessageManagementViewController alloc] init] animated:YES];
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


#pragma mark 五大按钮点击事件
- (void)optionClickPushVc:(NSNotification *)notification
{
    
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    NSString *occupyTitleName;
    NSString *beautyTitleName;
    NSString *specialtyTitleName;
    NSString *classeId;

 //   NSLog(@"%@",self.shopArray);
    
    switch (index + 1) {
        case 2:{
             occupyTitleName = @"居家生活";
        }
            break;
        case 3:
        {
            beautyTitleName = @"美容美妆";
        }
            break;
        case 4:
        {
          specialtyTitleName = @"地方特产";
        }
            break;
            
        default:
            break;
    }
    
    
    NSString *classeName;
    
    
    for (NSInteger i = 0;i<self.shopArray.count;i++ )
    {
        classeName = self.shopArray[i].class_name;
        NSString *goodsId = self.shopArray[i].id;
        
        if ([classeName isEqualToString:occupyTitleName])
        {
            classeId = goodsId;
        }else if ([classeName isEqualToString:beautyTitleName])
        {
            classeId = goodsId;
        }else if([classeName isEqualToString:specialtyTitleName])
        {
            classeId = goodsId;
        }
        
    }
 
    
    switch (index + 1){
//        case 1:
//            [self.navigationController pushViewController:[[TrainingEducationViewController alloc] init] animated:YES];
//            break;
        case 1:
            self.tabBarController.selectedIndex = 2;
            
            break;
    case 2:
        {
            if (classeId.length == 0)
            {
                [JKAlert alertText:@"暂无商品"];
                return;
            }
            [self pushClassificationOfMoreViewControllerGoodsClassId:classeId ViewTitle:occupyTitleName];
        }
            
           // [self.navigationController pushViewController:[[ReleaseGoodsViewController alloc] init] animated:YES];
            
        break;
    case 3:
            if (classeId.length == 0)
            {
                [JKAlert alertText:@"暂无商品"];
                return;
            }
            
            [self pushClassificationOfMoreViewControllerGoodsClassId:classeId ViewTitle:beautyTitleName];
      //     [self pushClassificationOfMoreViewControllerGoodsClassId:self.shopArray[4].id ViewTitle:@"美容美妆"];
        break;
    case 4:
            if (classeId.length == 0)
            {
                [JKAlert alertText:@"暂无商品"];
                return;
            }
            
            [self pushClassificationOfMoreViewControllerGoodsClassId:classeId ViewTitle:specialtyTitleName];

             //[self pushClassificationOfMoreViewControllerGoodsClassId:self.shopArray[5].id ViewTitle:@"地方特产"];
            break;

            
        default:
            break;
    }
    
}

#pragma mark 跳转搜索控制器
-(void)pushSearchViewControll
{
    [self.navigationController pushViewController:[[SearGoodsViewController alloc] init] animated:YES];
}

#pragma mark 跳转商品详情
- (void)pushDetailsViewControll:(NSNotification *)notifcation
{
    NSString *goodsId = notifcation.userInfo[@"goodsId"];
    
    ShoppingViewController *shopVc = [[ShoppingViewController alloc] init];
    shopVc.goodsIdItem = goodsId;
    shopVc.page = @"1";
    
    [self.navigationController pushViewController:shopVc animated:YES];
}

#pragma mark 跳转更多商品页面
- (void)pushMoreViewControll:(NSNotification *)notifcation
{
    NSString *moreId = notifcation.userInfo[@"moreId"];
     NSString *moreName = notifcation.userInfo[@"moreName"];
    
    [self pushClassificationOfMoreViewControllerGoodsClassId:moreId ViewTitle:moreName];
    
}

#pragma mark 封装跳转更多商品页面
- (void)pushClassificationOfMoreViewControllerGoodsClassId:(NSString *)goodsClassId ViewTitle:(NSString *)viewTitle
{
    
    ClassificationOfMoreViewController *moreVc = [[ClassificationOfMoreViewController alloc] init];
    
    moreVc.classGoodsId = goodsClassId;
    moreVc.title = viewTitle;
    [self.navigationController pushViewController:moreVc animated:YES];
    
}

#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
 return self.shopArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";

    ClassifiCationOfGoodsUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[ClassifiCationOfGoodsUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    cell.Id = [self.shopArray[indexPath.row].id integerValue];
    cell.name = self.shopArray[indexPath.row].class_name;
    cell.shopItmeArray = self.shopArray[indexPath.row].shopArr;
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

#pragma mark 设置导航栏

- (void)setNav
{

        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.rightBarButtonItems = nil;
        
        self.navigationController.navigationBar.barTintColor =[UIColor colorWithHexString:@"#FF5001"];
        
        self.view.backgroundColor = [UIColor whiteColor];
        // 添加边导航栏按钮
        BackNavigationBarView *nav = [[BackNavigationBarView alloc] initBackNavView];
        nav.frame = CGRectMake(0,0, ScreenWidth,44);
        self.navigationItem.titleView = nav;

}


- (void)searViewClcik:(UITapGestureRecognizer *)tap
{
    [self.navigationController pushViewController:[[SearGoodsViewController alloc] init] animated:YES];
}

- (void)addScrollView
{
    // 创建底部scrollView
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight)];
    self.scrollView = scrView;
    scrView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:scrView];
}

#pragma mark 添加头部view
- (void)addhead
{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, Height) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:cycleScrollView];
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (int i = 0;i<self.shuffingMoldelArray.count;i++)
    {
        NSString *imageStr = self.shuffingMoldelArray[i].img_url;
        [arrTemp addObject:imageStr];
    }
    
    cycleScrollView.imageURLStringsGroup = arrTemp;
    
    [self.scrollView addSubview:cycleScrollView];
    
}

#pragma mark图片轮播器点击跳转方法
- (void)selectItemAtIndex:(NSInteger)index {
}

#pragma mark 选项区九宫格方法
- (void)optionView{
    
    self.opctionview = [[UIView alloc] initWithFrame:CGRectMake(0,Height, ScreenWidth, 85)];
    self.opctionview.backgroundColor = [UIColor whiteColor];
    [self appList];
    //控制总列数
    int totalColumns = (int)self.appList.count;
    CGFloat Y = 0;
    CGFloat W = (ScreenWidth - (totalColumns * (int)self.appList.count)) / totalColumns;
    CGFloat H = 80;
    CGFloat X = (ScreenWidth - totalColumns * W) / (totalColumns + 1);
    
    for (int index = 0; index < _appList.count; index++) {
        
        OptionModel *model = _appList[index];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat viewX = X + col * (W + X);
        CGFloat viewY = (int)self.appList.count + row * (H + Y);
        OptionView *view = [[OptionView alloc]initWithFrame:CGRectMake(viewX, viewY, W, H) Model:model Index:index];
        [self.opctionview addSubview:view];
        
    }
    [self.scrollView addSubview:self.opctionview];
}

#pragma mark 加载跑马灯文本
- (void)horseRaceLamp
{
    _horseView = [[UIView  alloc] initWithFrame:CGRectMake(0,self.opctionview.sh_bottom,ScreenWidth , 35)];
    _horseView.backgroundColor = [UIColor colorWithHexString:@"#EA4717"];
    
    [InfoturnModel InfoturnModelLocation:@0 Success:^(NSArray<InfoturnModel *> *InfoturnArray) {
        
        NSMutableArray *textArray = [NSMutableArray array];
     
        for (int i = 0;i < InfoturnArray.count; i++)
        {
            
            [textArray addObject:InfoturnArray[i].content];
            
        }
        
        self.horseRaceLampLabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 35)  textArray:textArray font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor]];
        [_horseView addSubview:self.horseRaceLampLabel];
        self.horseRaceLampLabel.backgroundColor = [UIColor colorWithHexString:@"#EA4717"];
        self.horseRaceLampLabel.speed = 1;
        [self.horseRaceLampLabel setOrientation:RollingOrientationLeft];
        [self.horseRaceLampLabel setInternalWidth:self.horseRaceLampLabel.frame.size.width / 3];
        
        // 获取文字点击文字点击
        self.horseRaceLampLabel.labelClickBlock = ^(NSInteger index){
        //    NSString *text = [textArray objectAtIndex:index];
        };
//

        
    } error:^{
        
    }];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    // 加密地址
//    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/turn/infoturn"];
//    
//   
//    NSDictionary *dict= @{@"location":@0};
//    
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
//    
//    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSArray *dataArray = responseObject[@"list"];
//        
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        NSLog(@"%@",error);
//        
//    }];

    [self.scrollView addSubview:_horseView];
    
}


// 控制器即将显示添加通知
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [self setNav];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePageHUDVc) name:@"removePageHUD" object:nil];
    //跳转搜索控制器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSearchViewControll) name:@"pushSearchVc" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailsViewControll:) name:@"pushDetailsVc"object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMoreViewControll:) name:@"pushMoreVc"object:nil];
    
    // 五大按钮点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(optionClickPushVc:) name:@"optionClick" object:nil];
    
    // 购物车
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushShoppingCarVc) name:@"pushGoodsShoppingCarVc" object:nil];
    // 消息推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagePushVc) name:@"messagePushVc" object:nil];

    
   // [self goodsLoadData];
   
}


// 控制即将消失移除通知
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
