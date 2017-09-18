//
//  EarnMoneyViewController.m
//  nen
//
//  Created by nenios101 on 2017/2/27.
//
//花钱

#import "EarnMoneyViewController.h"
#import "ConsumptionWiningController.h"
#import "GroupBuyingController.h"
#import "FullCashBackController.h"
#import "SHTitleButton.h"
#import "ShoppingViewController.h"
#import "MessageManagementViewController.h"
#import "ShoppingCarController.h"
@interface EarnMoneyViewController ()<UIScrollViewDelegate>
/** 当前选中的标题按钮 */
@property (nonatomic, weak) SHTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;

@end

@implementation EarnMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self setupChildViewControllers];
    
    [self setupScrollView];
    
  //  [self setupTitlesView];
    
    // 默认添加子控制器的view
    [self addChildVcView];
    
}

#pragma mark 跳转搜索控制器
-(void)pushSearchViewControll
{
    [self.navigationController pushViewController:[[SearGoodsViewController alloc] init] animated:YES];
}
#pragma mark 消息推送
-(void)messagePushVc
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
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
#pragma mark 跳转购物车
- (void)PushShoppingCarVc
{
    [self.navigationController pushViewController:[[ShoppingCarController alloc] init] animated:YES];
}


- (void)setupChildViewControllers
{
    
//    GroupBuyingController *groupBuy = [[GroupBuyingController alloc] init];
//    [self addChildViewController:groupBuy];
    
    ConsumptionWiningController *Consumption= [[ConsumptionWiningController alloc] init];
    [self addChildViewController:Consumption];

//    FullCashBackController *fullCash = [[FullCashBackController alloc] init];
//    [self addChildViewController:fullCash];
    
}


- (void)setupNav
{
    self.view.backgroundColor =[UIColor whiteColor];

}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count *scrollView.sh_width,0);
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupTitlesView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    titlesView.frame = CGRectMake(0, 64,self.scrollView.sh_width,35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 添加标题
    NSArray *titles = @[@"团购区",@"消费中奖区"];
    NSUInteger count = titles.count;
    CGFloat buttonW = self.titlesView.sh_width / count;
    CGFloat buttonH = self.titlesView.sh_height;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        SHTitleButton * titleButton = [SHTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        // 设置frame
        titleButton.frame = CGRectMake(i * buttonW ,0, buttonW, buttonH);
        
    }
    // 按钮的选中颜色
    SHTitleButton *firstTitleButton = titlesView.subviews.firstObject;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.sh_height = 1;
    indicatorView.sh_y = titlesView.sh_height - indicatorView.sh_height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    // 立刻根据文字内容计算label的宽度
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.sh_width = firstTitleButton.titleLabel.sh_width;
    indicatorView.sh_centerX = firstTitleButton.sh_centerX;
    
    // 默认情况 : 选中最前面的标题按钮
    firstTitleButton.selected = YES;
    
    self.selectedTitleButton = firstTitleButton;
    
    
}

- (void)titleClick:(SHTitleButton *)titleButton
{
    
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    
    self.selectedTitleButton = titleButton;
    
    // 底部指示器
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.sh_width = titleButton.titleLabel.sh_width;
        self.indicatorView.sh_centerX = titleButton.sh_centerX;
        
    }];
    
    
    // 让UIScrollView滚动到对应位置
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.sh_width;
    [self.scrollView setContentOffset:offset animated:YES];
    
}

#pragma mark - 添加子控制器的view

- (void)addChildVcView
{
    // 子控制器的索引
    
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.sh_width;
    
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
 
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
    
    
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}


/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //   // 选中\点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.sh_width;
    SHTitleButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    // 添加子控制器的view
    [self addChildVcView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#FF5001"];
    // 添加边导航栏按钮
    BackNavigationBarView *nav = [[BackNavigationBarView alloc] initBackNavView];
    nav.frame = CGRectMake(0,0, ScreenWidth,44);
    self.navigationItem.titleView = nav;
    
    // 消息推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagePushVc) name:@"messagePushVc" object:nil];
    
    // 搜索栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSearchViewControll) name:@"pushSearchVc" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushShoppingCarVc) name:@"pushGoodsShoppingCarVc" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tagClick
{
   // NSLog(@"选中点击对应的按钮");
}

@end
