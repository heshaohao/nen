//
//  ShoppingCarController.m
//  GoodsShoppingCar
//
//  Created by nenios101 on 2017/3/16.
//  Copyright © 2017年 nen. All rights reserved.
//购物车页面

#import "ShoppingCarController.h"
#import "ShoppingCarModel.h"
#import "ShoppingCarCell.h"
#import "RecommendCell.h"
#import "CompileShoppingCarController.h"
#import "TheOrderViewController.h"
#import "RecommendationModel.h"
@interface ShoppingCarController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    // BOOL _isHiddenNavigationBarWhenDisappear;//记录当页面消失时是否需要隐藏系统导航
    BOOL _isHasTabBarController;//是否含有tabbar
    BOOL _isHasNavitationController;//是否含有导航
}
// 数据数组
@property (strong,nonatomic)NSMutableArray *dataArray;
// 按钮选择数组
@property (strong,nonatomic)NSMutableArray *selectedArray;
@property (strong,nonatomic)UITableView *myTableView;
// 全选按钮
@property (strong,nonatomic)UIButton *allSellectedButton;
// 合算价格
@property (strong,nonatomic)UILabel *totlePriceLabel;
// 底部scrollView
@property (strong,nonatomic) UIScrollView *scrollView;

// 推荐View
@property(nonatomic,strong) UIView *recommendView;

// 记录tableView的高度
@property(nonatomic,assign) CGFloat recordsRowHeight;

@property(nonatomic,strong) UICollectionView *colletionView;

@property(nonatomic,strong) NSMutableArray<ShoppingCarModel *> *shoppingCarModelArray;


@property(nonatomic,strong) NSMutableArray *selectedGoodsIdArray;
// 商品推荐数组
@property(nonatomic,strong) NSMutableArray<RecommendationModel *> *recommendationArray;

@property(nonatomic,strong) ThereIsNoDataBackgroundView * backgroundView;

@end

@implementation ShoppingCarController

- (NSMutableArray *)recommendationArray
{
    if (!_recommendationArray) {
        _recommendationArray = [NSMutableArray array];
    }
    return _recommendationArray;
}

#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
  
    [ShoppingCarModel shoppingModelsucces:^(NSMutableArray<ShoppingCarModel *> *ShoppingCarArray) {
        self.shoppingCarModelArray = ShoppingCarArray;
        
        [self changeView];
        
    } error:^{
        NSLog(@"失败");
    }];
    
    //[self recommendationData];

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"购物车";
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(compileBtn)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.attributedText = [self LZSetString:@"￥0.00"];

}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
//    _isHasTabBarController = self.tabBarController?YES:NO;
//    _isHasNavitationController = self.navigationController?YES:NO;
    
    UIScrollView *srVc = [[UIScrollView alloc] init];
    self.scrollView = srVc;
    srVc.frame = CGRectMake(0,64,ScreenWidth, ScreenHeight - 100);
    srVc.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    srVc.bounces = NO;
    [self.view addSubview:srVc];
    
    
}


#pragma mark 加载商品推荐
- (void)recommendationData
{
    [RecommendationModel recommendationModelSucces:^(NSMutableArray<RecommendationModel *> *recommendationArray) {
       // NSLog(@"%@",recommendationArray);
        
        self.recommendationArray = recommendationArray;
        
      [self addCollectView];
        
        
    } error:^{
        NSLog(@"失败");
    }];
}

#pragma mark 添加为你推荐
- (void)addRecommendView
{
    _recommendView = [[UIView alloc] init];
    _recommendView.frame = CGRectMake(0,self.myTableView.sh_bottom, ScreenWidth,30);
    _recommendView.sh_y = self.shoppingCarModelArray.count >= 1  ? self.myTableView.sh_bottom : 0;
    _recommendView.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"↓";
    leftLabel.textColor = [UIColor lightGrayColor];
    leftLabel.frame = CGRectMake(ScreenWidth * 0.3,0,20,30);
    [_recommendView addSubview:leftLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"为你推荐";
    contentLabel.textColor = [UIColor lightGrayColor];
    contentLabel.frame = CGRectMake(leftLabel.sh_right,0,100,30);
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [_recommendView addSubview:contentLabel];
    
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"↓";
    rightLabel.textColor = [UIColor lightGrayColor];
    rightLabel.frame = CGRectMake(contentLabel.sh_right,0,20,30);
    rightLabel.textAlignment = NSTextAlignmentCenter;
    [_recommendView addSubview:rightLabel];
    
     [self.scrollView addSubview:_recommendView];
    
    
    
}
#pragma mark 添加推荐
- (void)addCollectView
{
    //创建一个layout布局类
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ScreenWidth * 0.48,150);

    //创建collectionView 
    
    NSInteger collectionH ;
    

    if ((self.recommendationArray.count % 2) == 0)
    {
        collectionH = (self.recommendationArray.count / 2) *150;
    }else if ((self.recommendationArray.count % 2) == 1)
    {
        collectionH = (((self.recommendationArray.count - 1) / 2) *150) +150;
    }
    
    _colletionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.recommendView.sh_bottom + 10,ScreenWidth, collectionH) collectionViewLayout:flowLayout];
    //隐藏水平滚动条
    _colletionView.showsHorizontalScrollIndicator = NO;
    _colletionView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    //取消弹簧效果
    _colletionView.bounces = NO;
    _colletionView.scrollEnabled = NO;
    //代理设置
    _colletionView.dataSource = self;
    _colletionView.delegate = self;
    //注册item类型
    [_colletionView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    
    [self.scrollView addSubview:_colletionView];
    
    self.scrollView.contentSize = CGSizeMake(0,_colletionView.sh_bottom);
    
}

#pragma mark collection DataSource 方法
//返回item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //返回图片数组的长度
    return self.recommendationArray.count;
    
}

//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //3. 设置数据
    cell.model = self.recommendationArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

/**
 *
 *  计算已选中商品金额
 */
-(void)countPrice {
    double totlePrice = 0.0;
    
    for (ShoppingCarModel *model in self.selectedArray) {
        
        double price = [model.price doubleValue];
       // NSLog(@"%f",price);
        
        totlePrice += price*[model.num integerValue];
//NSLog(@"%f",totlePrice);
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
    self.totlePriceLabel.attributedText = [self LZSetString:string];
}

#pragma mark - 初始化数组


- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}

- (NSMutableArray *)selectedGoodsIdArray {
    if (_selectedGoodsIdArray == nil) {
        _selectedGoodsIdArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedGoodsIdArray;
}


#pragma mark - 布局页面视图
#pragma mark -- 自定义导航


#pragma mark 导航编辑按钮
- (void)compileBtn
{
    [self.navigationController pushViewController:[[CompileShoppingCarController alloc] init] animated:YES];
}
#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = LZColorFromRGB(245, 245, 245);
    backgroundView.tag = TAG_CartEmptyView + 1;
    [self.view addSubview:backgroundView];
    
    //当有tabBarController时,在tabBar的上面
//    if (_isHasTabBarController == YES) {
//        backgroundView.frame = CGRectMake(0, ScreenHeight -  SHTabBarHeight, ScreenWidth, SHTabBarHeight);
//    } else {
//   }

  backgroundView.frame = CGRectMake(0, ScreenHeight -  SHTabBarHeight, ScreenWidth, SHTabBarHeight);
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, ScreenWidth, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:16];
    selectAll.frame = CGRectMake(10, 5, 80, SHTabBarHeight - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:sh_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:sh_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = BASECOLOR_RED;
    btn.frame = CGRectMake(ScreenWidth - 80, 0, 80, SHTabBarHeight);
    [btn setTitle:@"去结算" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor redColor];
    [backgroundView addSubview:label];
    
    label.attributedText = [self LZSetString:@"¥0.00"];
    CGFloat maxWidth = ScreenWidth - selectAll.bounds.size.width - btn.bounds.size.width - 30;
    //   CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, LZTabBarHeight)];
    label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, SHTabBarHeight);
    self.totlePriceLabel = label;
}

- (NSMutableAttributedString*)LZSetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"合计:%@",string];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"合计:"];
    [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:rang];
    return LZString;
}
#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    if (self.shoppingCarModelArray.count > 0) {
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [_recommendView removeFromSuperview];
        [_colletionView removeFromSuperview];
        
        [self removeBackgroundView];
        [self setupCartView];
        [self addRecommendView];
        [self recommendationData];
        
    } else {
        UIView *bottomView = [self.view viewWithTag:TAG_CartEmptyView + 1];
        [bottomView removeFromSuperview];
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [_recommendView removeFromSuperview];
        [_colletionView removeFromSuperview];
        [self removeBackgroundView];
        [self setupCartEmptyView];
        [self.myTableView reloadData];
        [self.colletionView reloadData];
    }
}

- (void)setupCartEmptyView
{
    //默认视图背景
    _backgroundView = [[ThereIsNoDataBackgroundView alloc] initWithThereIsNoDataBackgroundViewImageIcon:KShoppingCarNoDataBackgroundImage ImageX:(ScreenWidth *0.5) *0.5 ImageY:ScreenHeight *0.25  ImageW:ScreenWidth *0.5 imageH:ScreenWidth *0.5 ShowBottomText:@"购物车空空如也"];
    _backgroundView.frame = CGRectMake(0,64,ScreenWidth,ScreenHeight - 64);
    [self.view addSubview:_backgroundView];
    

}

#pragma mark 移除backgroundView
- (void)removeBackgroundView
{
    [_backgroundView removeFromSuperview];
}



#pragma mark -- 购物车有商品时的视图
- (void)setupCartView {
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.scrollEnabled =NO;
    table.delegate = self;
    table.dataSource = self;
    
    table.rowHeight = sh_CartRowHeight;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = LZColorFromRGB(245, 246, 248);
    [self.view addSubview:table];
    self.myTableView = table;
    [self.scrollView addSubview:table];
    
    //创建底部视图
    [self setupCustomBottomView];

    table.frame = CGRectMake(0, -64, ScreenWidth, self.shoppingCarModelArray.count * TAG_CartEmptyView);

    
    
}
#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shoppingCarModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShoppingCarModel *model = self.shoppingCarModelArray[indexPath.row];
    
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
    
    
    if (cell == nil) {
        cell = [[ShoppingCarCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCell"];
    }
    cell.model = model;
    
    __block typeof(cell)wsCell = cell;
    //
    // 数量+1
    [cell numberAddWithBlock:^(NSInteger number) {
        wsCell.lzNumber = number;
    // model.number = number;
      //  NSLog(@"%d",number);
        model.num = [NSString stringWithFormat:@"%d",number];
        
     //    [self.shoppingCarModelArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    // 数量 -1
    [cell numberCutWithBlock:^(NSInteger number) {
        
        wsCell.lzNumber = number;
        model.num = [NSString stringWithFormat:@"%d",number];
    
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        
        
        if (select) {
            [self.selectedArray addObject:model];
            [self.selectedGoodsIdArray addObject:model.id];
            
          //  NSLog(@"%@",self.selectedGoodsIdArray);
        } else {
            [self.selectedArray removeObject:model];
            [self.selectedGoodsIdArray removeObject:model.id];
          //  NSLog(@"%@",self.selectedGoodsIdArray);
        }
        
        if (self.selectedArray.count == self.shoppingCarModelArray.count) {
            _allSellectedButton.selected = YES;
        } else {
            _allSellectedButton.selected = NO;
        }
        
        // 计算已选中商品金额
        [self countPrice];
    }];
    
    //[cell reloadDataWithModel:model];
    return cell;
}

#pragma mark -- 页面按钮点击事件
#pragma mark --- 返回按钮点击事件
- (void)backButtonClick:(UIButton*)button {
    if (_isHasNavitationController == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (ShoppingCarModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    [self.selectedGoodsIdArray removeAllObjects];
    
    if (button.selected) {
        
        for (ShoppingCarModel *model in self.shoppingCarModelArray) {
            model.select = YES;
            [self.selectedArray addObject:model];
            [self.selectedGoodsIdArray addObject:model.id];
        }
    }
    
    [self.myTableView reloadData];
    [self countPrice];
    
}
#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    if (self.selectedArray.count > 0) {
//        for (ShoppingCarModel *model in self.selectedArray) {
//           // NSLog(@"选择的商品>>%@>>>%ld",model,(long)model.number);
//            NSLog(@"%@",self.selectedGoodsIdArray);
//            
//        }
        
       // NSLog(@"%d",self.selectedGoodsIdArray.count);
        
        TheOrderViewController *theVc = [[TheOrderViewController alloc] init];
        theVc.record = @"1";
        
        [self.selectedGoodsIdArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [theVc.shoppingCarGoodsId addObject:obj];
        }];
        
        [self.navigationController pushViewController:theVc animated:YES];
        
        
    } else {
      //  NSLog(@"你还没有选择任何商品");
    }
    
}


@end
