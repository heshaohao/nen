//
//  BuddhismTableViewController.m
//  test
//
//  Created by nenios101 on 2017/3/3.
//  Copyright © 2017年 nen. All rights reserved.
//佛教

#import "BuddhismTableViewController.h"
#import "TempleViewController.h"
#import "ShufflingFigureModel.h"

@interface BuddhismTableViewController ()<UITableViewDelegate,SDCycleScrollViewDelegate>

// 图片轮播器


@property(nonatomic,strong) NSArray *shuffingMoldelArray;

@end

@implementation BuddhismTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64 + 35, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = 250;
    
  // 加载数据
    [ShufflingFigureModel shufflingFigureLocation:@"16" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        self.shuffingMoldelArray = shufflingFigure;
        self.tableView.tableHeaderView = [self headView];
        [self.tableView reloadData];
        
    } error:^{
     //  NSLog(@"失败");
    }];
    
    
  
    
}

#pragma mark 图片轮播器数组
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}


#pragma mark 添加图片轮播器
- (UIView *)headView
{
    UIView *headerView = [[UIView alloc] init];
    // 图片轮播器
 
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    NSMutableArray *arrTemp = [NSMutableArray array];
    
    [self.shuffingMoldelArray enumerateObjectsUsingBlock:^(ShufflingFigureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrTemp addObject:obj.img_url];
    }];
    
    cycleScrollView.imageURLStringsGroup = arrTemp;
    
  
   [headerView addSubview:cycleScrollView];
    

    UIView *placeNameView = [[UIView alloc] init];
    placeNameView.sh_y = cycleScrollView.sh_bottom + 5;
    placeNameView.sh_height = 26;
    placeNameView.sh_width = ScreenWidth;
    placeNameView.sh_x = 0;
   
    [headerView addSubview:placeNameView];
    UILabel *leftName = [[UILabel alloc] init];
    leftName.text = @" 你所在的省份     V";
    leftName.font = [UIFont systemFontOfSize:13];
    leftName.sh_x = 5;
    leftName.tintColor = [UIColor blackColor];
    leftName.sh_y =0;
    leftName.sh_width = ScreenWidth * 0.3;
    leftName.sh_height = 25;
    [placeNameView addSubview:leftName];
    
    UILabel *rightName = [[UILabel alloc] init];
    rightName.text = @" 你所在的省份     V";
    rightName.font = [UIFont systemFontOfSize:13];
    rightName.sh_x = leftName.sh_right + 10;
    rightName.tintColor = [UIColor blackColor];
    rightName.sh_y =0;
    rightName.sh_width = ScreenWidth * 0.3;
    rightName.sh_height = 25;
    [placeNameView addSubview:rightName];
    
    UILabel *btn = [[UILabel alloc] init];
    btn.text = @"        切换";
    btn.font = [UIFont systemFontOfSize:13];
    btn.sh_x = rightName.sh_right + 10;
    btn.tintColor = [UIColor blackColor];
    btn.sh_y =0;
    btn.sh_width = ScreenWidth * 0.2;
    btn.sh_height = 25;
    [placeNameView addSubview:btn];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor grayColor];
    bottomLine.sh_height = 1;
    bottomLine.sh_width = ScreenWidth;
    bottomLine.sh_y =  placeNameView.sh_bottom;
    bottomLine.sh_x = 0;
    
    [headerView addSubview:bottomLine];
    
    headerView.sh_height = 235;
    headerView.sh_x = 0;
    headerView.sh_y = 0;
    headerView.sh_width = ScreenWidth;
    
    return headerView;
    
}
#pragma mark图片轮播器点击方法
- (void)selectItemAtIndex:(NSInteger)index {
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[TempleViewController alloc] init] animated:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.确定重用标示:
    static NSString *ID = @"cell";
    
    // 2.从缓存池中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果空就手动创建
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BuddhismCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}

@end
