//
//  ShoppingViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/6.
//  Copyright © 2017年 nen. All rights reserved.
// 掙钱模块

#import "ShoppingViewController.h"
#import "SHTitleButton.h"
#import "MarketingPlanViewController.h"
#import "DetailsViewController.h"
#import "EvaluationViewController.h"
#import "ConsumptionWiningController.h"
#import "detailsBtn.h"

@interface ShoppingViewController ()<UIScrollViewDelegate>
/** 当前选中的标题按钮 */
@property (nonatomic, weak) SHTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;

@property(nonatomic,copy) NSString *goodsId;

@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,assign) NSInteger number;

@end

@implementation ShoppingViewController

//+ (ShoppingViewController *)shopManager
//{
//    static ShoppingViewController *shoppinManager = nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        shoppinManager = [[self alloc] init];
//    });
//    return shoppinManager;
//}



- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBar];
    
    [self setupNav];
    
    [self setupChildViewControllers];
    
    [self setupScrollView];
    
    [self setupTitlesView];
    
    // 默认添加子控制器的view
    [self addChildVcView];
    
    self.number = 1;
    
    //[self bottoView];
    
    if (!self.page)
    {
        self.page = @"0";
        
    }else
    {
        [self titleClick:self.selectedTitleButton];
    }
  //  NSLog(@"%@",self.goodsIdItem);
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
}
- (void)setupChildViewControllers
{
    MarketingPlanViewController *all = [[MarketingPlanViewController alloc] init];
    all.groupGoodsId = self.groupGoodsId;
    all.goodsId = self.goodsIdItem;
    [self addChildViewController:all];
    
    DetailsViewController *video = [[DetailsViewController alloc] init];
    video.goodsId = self.goodsIdItem;
    video.groupBuyingId = self.groupGoodsId;
    [self addChildViewController:video];
    
    EvaluationViewController *voice = [[EvaluationViewController alloc] init];
    voice.goodsId = self.goodsIdItem;
    voice.groupGoodsId = self.groupGoodsId;
    [self addChildViewController:voice];
}


#pragma mark 底部view
- (void)bottoView
{
    if (self.number > 1 || self.number < 1)
    {
        return ;
    }
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.frame = CGRectMake(0,ScreenHeight - 50,ScreenWidth,50);
        [self.view addSubview:_bottomView];
        
        // 顾问
        UIButton *consultantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [consultantBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [consultantBtn setTitle:@"选购顾问坐诊" forState:UIControlStateNormal];
        consultantBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        consultantBtn.frame = CGRectMake(10, 10,80,30);
        
        
        [_bottomView addSubview:consultantBtn];
        
        UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [numberBtn setBackgroundImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
        [numberBtn addTarget:self action:@selector(nuberBtn) forControlEvents:UIControlEventTouchUpInside];
        numberBtn.frame = CGRectMake(consultantBtn.sh_right + 10,15,20,20);
        numberBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bottomView addSubview:numberBtn];
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageBtn setBackgroundImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
        messageBtn.imageView.contentMode =UIViewContentModeScaleAspectFit;
        messageBtn.frame = CGRectMake(numberBtn.sh_right + 10 ,15,20,20);
        [_bottomView addSubview:messageBtn];
        
        UILabel *classifyLabel = [[UILabel alloc] init];
        classifyLabel.frame = CGRectMake(ScreenWidth - 80, 10,80, 30);
        classifyLabel.text = @"常见问题分类";
        classifyLabel.font = [UIFont systemFontOfSize:12];
        [_bottomView addSubview:classifyLabel];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.frame = CGRectMake(0, 0, ScreenWidth, 1);
        topLine.backgroundColor = [UIColor grayColor];
        [_bottomView addSubview:topLine];
        
    }
    
    
}


-(void)nuberBtn
{
  //  NSLog(@"点击");
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
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
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
    NSArray *titles = @[@"选购窍门",@"商品详情",@"商品评价"];
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
    SHTitleButton *firstTitleButton = titlesView.subviews[[self.page integerValue]];
    
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
    
    if (titleButton.tag == 0)
    {
        // 把之前的底部清空
        [_bottomView removeFromSuperview];
        
         self.number = 1;
        // 添加底部
        [self bottoView];
        
    }else
    {

        [_bottomView removeFromSuperview];
    }
}


#pragma mark 设置导航栏
- (void)setNavBar
{
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


#pragma mark - 添加子控制器的view

- (void)addChildVcView
{
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.sh_width;
    if (index == 0)
    {  // 把之前的底部清空
        [_bottomView removeFromSuperview];
         self.number = 1;;
         // 添加底部
        [self bottoView];
    }else
    {
        [_bottomView removeFromSuperview];
    }
    
    switch (index){
        case 0:
            self.navigationItem.title = @"选购窍门";
            break;
        case 1:
            self.navigationItem.title = @"商品详情";
            break;
        case 2:
            self.navigationItem.title = @"商品评价";
            break;
            
        default:
            break;
    }

    
    
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


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / scrollView.sh_width;
    index = [self.page integerValue];
    SHTitleButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    // 添加子控制器的view
    [self addChildVcView];
    
    
    
    
}

- (void)tagClick
{
    //NSLog(@"选中点击对应的按钮");
}



@end
