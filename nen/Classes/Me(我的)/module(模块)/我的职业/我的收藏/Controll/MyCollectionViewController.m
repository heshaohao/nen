//
//  MyCollectionViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "SHTitleButton.h"
#import "GoodsCollectionViewController.h"
#import "ShopToCollectViewController.h"
#import "PostCollectionViewController.h"
@interface MyCollectionViewController ()<UIScrollViewDelegate>

/** 当前选中的标题按钮 */
@property (nonatomic, weak) SHTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupChildViewControllers];
    
    [self setupScrollView];
    
    [self setupTitlesView];
    
    // 默认添加子控制器的view
    [self addChildVcView];

}

- (void)setupChildViewControllers
{
    GoodsCollectionViewController *goodsCollectionVc= [[GoodsCollectionViewController alloc] init];
    [self addChildViewController:goodsCollectionVc];
    
    ShopToCollectViewController *shopToCollectVc = [[ShopToCollectViewController alloc] init];
    [self addChildViewController:shopToCollectVc];
    
//    PostCollectionViewController *postCollectionVc = [[PostCollectionViewController alloc] init];
//    [self addChildViewController:postCollectionVc];
    
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
    scrollView.scrollEnabled  = NO;
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
    titlesView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];            //[[UIColor whiteColor] colorWithAlphaComponent:1];
    titlesView.frame = CGRectMake(0, 64,self.scrollView.sh_width,35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 添加标题
    NSArray *titles = @[@"商品",@"店铺"];
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
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"我的收藏";
    
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0,KNavBarBackBtnW, KNavBarBackBtnH);
    [leftButton setBackgroundImage:KNavBarBackIconColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    nagetiveSpacer.width = KNavBarSpacing;   //这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,leftBarButtonItems];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:KNavBarTittleFont],
       
       NSForegroundColorAttributeName:KNavBarTitlesColor }];
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintsColor;
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tagClick
{
    
}




@end
