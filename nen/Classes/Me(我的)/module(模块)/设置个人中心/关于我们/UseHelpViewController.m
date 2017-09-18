//
//  UseHelpViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/16.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "UseHelpViewController.h"

@interface UseHelpViewController ()

// @property(nonatomic,strong) NSArray *dataArray;

@end

@implementation UseHelpViewController

//- (NSArray *)dataArray
//{
//    if (!_dataArray)
//    {
//        _dataArray = @[@"关于网一网",@"网一网介绍",@"网一网文化",@"操作指南",@"用户身份介绍",@"积分说明",@"网币说明",@"常见问题",@"操作流程介绍",@"积分流程介绍"];
//    }
//    return _dataArray;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
  
//    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
//    self.tableView.tableFooterView = [[UIView alloc] init];
//    self.tableView.scrollEnabled = NO;
 
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(ScreenWidth *0.25,80,ScreenWidth *0.5,25);
    titleLabel.text = @"网一网公司介绍";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    UILabel *desprtLabel = [[UILabel alloc] init];
    desprtLabel.frame = CGRectMake(10,titleLabel.sh_x + 20,ScreenWidth - 20,350);
    desprtLabel.numberOfLines = 0;
    desprtLabel.font = [UIFont systemFontOfSize:14];
    desprtLabel.lineBreakMode = NSLineBreakByWordWrapping;
    desprtLabel.text = @"        广州网一网信息科技有限公司（简称网一网），坐落在广州高新技术产业示范基地的科学城，注册资本伍仟零伍拾万元整，是一家互联网+传统行业的移动应用解决方案的服务商，专注于移动APP开发 网一网公司近年来，深入建筑行业、电商行业、服装鞋帽批发零售行业，学习熟悉各个行业相关领域的业务流程，了解发现各自领域的行业痛点，陆续自主开发出了一系列产品，如营销家APP、百家惠APP、店铺管家APP等产品，致力于帮助众多企业客户便利融入“互联网+”时代，以互联网为媒介整合传统商业类型，连接各种商业渠道，打造高创新、高价值、高盈利的全新商业运作和组织架构模式。让传统企业从产品竞争、企业竞争、产业链竞争过渡到商品模式竞争阶段。网一网公司通过自主产品开发积累的移动互联网行业经验，向广大企业提供商业模式咨询、用户体验设计、APP产品开发、互联网运营推广等一站式服务，帮助企业规划和实现“互联网+”转型，挖掘商业价值，实现高速增长。";
    
    [self.view addSubview:desprtLabel];
    
    
    
}
    //
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *Id = @"cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
//    
//    if (!cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
//    }
//    
//    if (indexPath.row == 9)
//    {
//        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
//    }
//    
//    cell.textLabel.text = self.dataArray[indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    return cell;
//}
//
//#pragma mark cell 分割线 两端封头
//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//}
////cell 分割线 两端封头 实现这个两个方法 1
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"帮助中心";
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



@end
