//
//  CheckViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/20.
//  Copyright © 2017年 nen. All rights reserved.
//账单控制器

#import "CheckViewController.h"
#import "CheackTableViewCell.h"
#import "CheckOrderModel.h"
#import "CheackOrderTableViewCell.h"

@interface CheckViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *hudView;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSArray *listDataArray;

@property(nonatomic,assign) BOOL isClickBtn;

@property(nonatomic,strong) UIButton *checkBtn;

@property(nonatomic,strong) UITableView *orderTabeleView;

@property(nonatomic,strong) NSMutableArray<CheckOrderModel *> *checkArray;

@property(nonatomic,copy) NSString *flag;

@property(nonatomic,copy) NSString *page;

@property(nonatomic,strong) NSMutableArray<CheckOrderModel *> *loadMoreTableFooterViewArray;

@property(nonatomic,strong) NSArray<CheckOrderModel *> *sumDataArray;

@property(nonatomic,strong) ThereIsNoDataBackgroundView *backgroundView;

@property(nonatomic,copy) NSString *signal;

@property (nonatomic,copy) NSString *type;



@end


@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    self.type = @"0";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] init];
    self.orderTabeleView = tableView;
    tableView.rowHeight = 85;
    tableView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    tableView.delegate  = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    [self pulldownNews];
    
    
}

- (NSMutableArray *)checkArray
{
    if (!_checkArray)
    {
        _checkArray = [NSMutableArray array];
    }
    
    return _checkArray;
}

- (NSMutableArray *)loadMoreTableFooterViewArray
{
    if (!_loadMoreTableFooterViewArray)
    {
        _loadMoreTableFooterViewArray = [NSMutableArray array];
    }
    
    return _loadMoreTableFooterViewArray;
}
- (void)pulldownNews
{
    
    // 点击进入立即刷新
    self.orderTabeleView.mj_header = [SHRefreshHeader  headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.orderTabeleView.mj_header beginRefreshing];
    
}

#pragma mark 下来刷新
- (void)loadNewData
{
    [self pullUpNews];
    
    __weak typeof(self)weakself = self;
    self.page = @"1";
   // __weak UITableView *tableView = self.orderTabeleView;
    
 [CheckOrderModel checkModelType:self.type Page:self.page succes:^(NSMutableArray<CheckOrderModel *> *orderArray) {
     self.checkArray = orderArray;
     
     
     if (self.checkArray.count > 0)
     {
         self.flag = @"1";
         //         [self.orderTabeleView reloadData];
         //         [tableView.mj_header endRefreshing];
         [weakself removeBackgroundView];
         [weakself.orderTabeleView reloadData];
         [weakself.orderTabeleView.mj_header endRefreshing];
         
         
     }else
     {
         weakself.signal = @"1";
         if (self.checkArray.count >0){
             [weakself.checkArray removeAllObjects];
         }
         [weakself.orderTabeleView reloadData];
         [weakself removeBackgroundView];
         [weakself setEmptyView];
         [weakself.orderTabeleView.mj_header endRefreshing];
     }
     
 } error:^{
     
     weakself.signal = @"0";
     if (self.checkArray.count >0){
         [weakself.checkArray removeAllObjects];
     }
     [weakself.orderTabeleView reloadData];
     [weakself removeBackgroundView];
     [weakself setEmptyView];
     [weakself.orderTabeleView.mj_header endRefreshing];
     
 }];
    
}

#pragma mark 没有数据时显示
- (void)setEmptyView
{
    NSString * showTextStr;
    if ([self.signal isEqualToString:@"1"])
    {
        showTextStr = @"暂无账单!";
    }else
    {
        showTextStr = @"您的网络信号不好!";
        
    }
    
    
    //默认视图背景
    _backgroundView = [[ThereIsNoDataBackgroundView alloc] initWithThereIsNoDataBackgroundViewImageIcon:KNoDataBackgroundImage ImageX:ScreenWidth*0.25 ImageY:ScreenHeight *0.25 ImageW:ScreenWidth *0.5 imageH:ScreenWidth *0.5 ShowBottomText:showTextStr];
    [self.orderTabeleView addSubview:_backgroundView];
    
}



#pragma mark 移除backgroundView
- (void)removeBackgroundView
{
    [_backgroundView removeFromSuperview];
}



- (void)pullUpNews
{
    // 设置回调
    self.orderTabeleView.mj_footer = [SHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark 上啦刷新
- (void)loadMoreData
{
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
    
    __weak typeof(self)weakself = self;
    __weak UITableView *tableView = self.orderTabeleView;
    
    [CheckOrderModel checkModelType:self.type Page:self.page succes:^(NSMutableArray<CheckOrderModel *> *orderArray) {
        self.loadMoreTableFooterViewArray = orderArray;
        // 在一个数组后面拼接添加另一个数组的所有元素
        
        self.checkArray = (NSMutableArray *)[self.checkArray arrayByAddingObjectsFromArray:self.loadMoreTableFooterViewArray];
        
        [tableView reloadData];
        [tableView.mj_footer endRefreshing];

    } error:^{
        
        weakself.signal = @"0";
        if (self.checkArray.count >0){
            [weakself.checkArray removeAllObjects];
        }
        [weakself.orderTabeleView reloadData];
        [weakself removeBackgroundView];
        [weakself setEmptyView];
        [weakself.orderTabeleView.mj_footer endRefreshing];

    }];
    
}



- (NSArray *)listDataArray
{
    if (!_listDataArray)
    {
        _listDataArray = @[@{@"type":@"0",@"icon":@"icon_02",@"title":@"全部账单"},@{@"type":@"4",@"icon":@"icon_02",@"title":@"开店账单"},@{@"type":@"7",@"icon":@"icon_02",@"title":@"驾校账单"},@{@"type":@"6",@"icon":@"icon_02",@"title":@"营销公司账单"},@{@"type":@"5",@"icon":@"icon_02",@"title":@"引进公司账单"},@{@"type":@"1",@"icon":@"icon_02",@"title":@"中奖账单"},@{@"type":@"3",@"icon":@"icon_02",@"title":@"全额返账单"},@{@"type":@"0",@"icon":@"icon_02",@"title":@"服务公司账单"},@{@"type":@"0",@"icon":@"icon_02",@"title":@"品牌公司账单"}];
    }
    
    return _listDataArray;

}


#pragma mark 设置导航条
- (void)setNav
{
    self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkBtn.sh_width = 120;
    self.checkBtn.sh_height = 40;
    self.checkBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.checkBtn.titleLabel.font= [UIFont systemFontOfSize:15];
    [self.checkBtn setTitle:@"全部账单" forState:UIControlStateNormal];
    [self.checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkBtn addTarget:self action:@selector(ModalCheckV) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = self.checkBtn;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    
}

#pragma mark 弹出列表tableView
- (void)ModalCheckV
{
    if (!self.isClickBtn) {
        self.isClickBtn = YES;
        self.hudView = [[UIView alloc] init];
        
        self.flag = @"0";
        
        self.hudView .frame = CGRectMake(0,64,ScreenWidth,ScreenHeight);
        self.hudView .backgroundColor = [UIColor orangeColor];
        self.hudView.backgroundColor = [UIColor whiteColor];
        self.hudView.alpha = 0.1;
        [self.view addSubview:self.hudView ];
        UITapGestureRecognizer *hudTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeHudView)];
        
        [self.hudView  addGestureRecognizer:hudTap];
        self.tableView  = [[UITableView alloc] init];
        self.tableView.rowHeight = 30;
        self.tableView.frame = CGRectMake(0,64,ScreenWidth,self.listDataArray.count * 30 );
        self.tableView.bounces = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
        
    }else
    {
        [self removeHudView];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.flag isEqualToString:@"0"]){
    
    [self.checkBtn setTitle:self.listDataArray[indexPath.row][@"title"] forState:UIControlStateNormal];
    self.type = self.listDataArray[indexPath.row][@"type"];
        NSLog(@"%@",self.type);
    [self pulldownNews];
    [self removeHudView];
    
   }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.flag isEqualToString:@"1"])
    {
     //   NSLog(@"%p",self.checkArray);
        return self.checkArray.count;
    }else if([self.flag isEqualToString:@"0"])
    {
        return self.listDataArray.count;
        
    }else
    {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self.flag isEqualToString:@"0"])
    {
        
        NSString *Id = @"cell";
        
        CheackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
        if (!cell) {
            cell = [[CheackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        }
        
        cell.titleStr = self.listDataArray[indexPath.row][@"title"];
        cell.imageStr = self.listDataArray[indexPath.row][@"icon"];
        
        return cell;
    }else
    {
        NSString *Id = @"cell";
    CheackOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell)
    {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"CheackOrderTableViewCell" owner:nil options:nil] lastObject];
    }
        CheckOrderModel *model = self.checkArray[indexPath.row];
        
        cell.model = model;
        
      return cell;
    }
    
}

#pragma mark 设置tableView分割线两端封头
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

//cell 分割线 两端封头 实现这个两个方法 1
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark 清除弹出tableview
- (void)removeHudView
{
    self.flag = @"1";
    [self.tableView removeFromSuperview];
    [self.hudView removeFromSuperview];

    self.isClickBtn = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

    self.navigationController.navigationBar.barTintColor = KNavBarBarTintColor;
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    NSDictionary *dict = @{@"popStr":@"1"};

    [[NSNotificationCenter defaultCenter] postNotificationName:@"pop" object:self userInfo:dict];
}


@end
